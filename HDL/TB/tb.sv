module conv_buffer_tb ();

  // Testbench parameters
  parameter DATA_WIDTH = 8;
  parameter BUFFER_LENGTH = 2000;
  parameter KERNEL_ROW_SIZE = 3;
  parameter KERNEL_COLUMN_SIZE = 3;
  parameter CLOCK_PERIOD = 10;

  // Testbench signals
  bit [DATA_WIDTH-1:0] in_point;
  bit clk;
  bit rst_n;
  bit [$clog2(BUFFER_LENGTH)-1:0] frame_column_size;
  bit valid_in;
  bit [DATA_WIDTH*KERNEL_COLUMN_SIZE*KERNEL_ROW_SIZE-1:0] out_matrix;
  bit valid_out;

  // Instantiate the conv_buffer module
  conv_buffer #(
      .DATA_WIDTH(DATA_WIDTH),
      .BUFFER_LENGTH(BUFFER_LENGTH),
      .KERNEL_ROW_SIZE(KERNEL_ROW_SIZE),
      .KERNEL_COLUMN_SIZE(KERNEL_COLUMN_SIZE)
  ) uut (
      .in_point(in_point),
      .clk(clk),
      .rst_n(rst_n),
      .frame_column_size(frame_column_size),
      .valid_in(valid_in),
      .out_matrix(out_matrix),
      .valid_out(valid_out)
  );

  int f_handle;

  // Testbench initial block
  initial begin
    // Open file for logging

    string log_dir;

    if (!$value$plusargs("LOG_DIR=%s", log_dir)) begin
      log_dir = "../text_logs/conv_buffer_output_tb.txt";
    end

    $display("TB logs will be saved in: %s", log_dir);

    f_handle = $fopen(log_dir, "w");
    // Initialize inputs
    initialize_inputs();
    // Apply reset
    reset();
    // Load a frame of data
    load_frame(6, 36);  // Example: 5 columns, 25 pixels

    // Wait for some time to observe outputs
    repeat (10) clk_cycle();

    // Display output matrix
    // display_output();

    // Finish simulation
    $stop;
  end

  // generate system clock 
  always generate_clk_cycle();

  // Testbench tasks
  task generate_clk_cycle();
    begin
      #(CLOCK_PERIOD / 2);
      clk = ~clk;
    end
  endtask


  task clk_cycle();
    begin
      @(posedge clk);
    end
  endtask

  task reset();
    begin
      rst_n = 0;
      clk_cycle();
      rst_n = 1;
      clk_cycle();
    end
  endtask


  task initialize_inputs();
    begin
      in_point = 0;
      frame_column_size = 0;
      valid_in = 0;
      rst_n = 1;
      clk = 0;
    end
  endtask

  task load_inputs(input bit [DATA_WIDTH-1:0] data, input bit [$clog2(BUFFER_LENGTH)-1:0] col_size);
    begin
      in_point = data;
      frame_column_size = col_size;
      valid_in = 1;
      clk_cycle();
      valid_in = 0;
    end
  endtask

  task load_frame(input bit [$clog2(BUFFER_LENGTH)-1:0] col_size, input int num_pixels);
    integer i;
    begin
      for (i = 1; i <= num_pixels; i = i + 1) begin
        load_inputs(i % 256, col_size);  // Example data pattern
        log_matrix();
      end
    end
  endtask

  task log_matrix();
    begin
      // wait(valid_out == 1'b1);
      // if (valid_out)
      for (int i = 0; i < KERNEL_ROW_SIZE; i = i + 1) begin
        for (int j = 0; j < KERNEL_COLUMN_SIZE; j = j + 1) begin
          $fwrite(f_handle, " %d", out_matrix[DATA_WIDTH*(i*KERNEL_COLUMN_SIZE+j)+:DATA_WIDTH]);
        end
        $fwrite(f_handle, "\n");
      end
      $fwrite(f_handle, "*********************************************************");
      $fwrite(f_handle, "\n");
    end
  endtask
endmodule
