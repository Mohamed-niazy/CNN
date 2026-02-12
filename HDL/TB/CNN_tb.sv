module CNN_tb ();


  // Testbench parameters
  parameter PIXEL_WIDTH = 8;
  parameter KERNEL_WIDTH = 5;
  parameter ADDER_TYPE = "RIPPLE";
  parameter MULTIPLIER_TYPE = "ARRAY";
  parameter KERNEL_ROW_SIZE = 3;
  parameter KERNEL_COLUMN_SIZE = 3;
  parameter BUFFER_LENGTH = 2000;
  parameter CLOCK_PERIOD = 10;  // Clock period in time units

  // Testbench signals



  logic                             clk;
  logic                             rst_n;
  logic [          PIXEL_WIDTH-1:0] in_point;
  logic [$clog2(BUFFER_LENGTH)-1:0] frame_column_size;
  logic [$clog2(BUFFER_LENGTH)-1:0] frame_row_size;
  logic                             valid_in;
  logic [                      4:0] kernel_type;
  logic [          PIXEL_WIDTH-1:0] conv_res;
  logic                             valid_out;

  // Instantiate the CNN for testing

  NormalversionCNN #(
      .PIXEL_WIDTH       (PIXEL_WIDTH),         // Pixel width (e.g., 8-bit grayscale)
      .KERNEL_WIDTH      (KERNEL_WIDTH),        // Kernel coefficient width
      .ADDER_TYPE        (ADDER_TYPE),          // Adder architecture (for synthesis experiments)
      .MULTIPLIER_TYPE   (MULTIPLIER_TYPE),     // Multiplier architecture
      .KERNEL_ROW_SIZE   (KERNEL_ROW_SIZE),     // Convolution window size (3×3)
      .KERNEL_COLUMN_SIZE(KERNEL_COLUMN_SIZE),  // Derived parameters
      .BUFFER_LENGTH     (BUFFER_LENGTH)
  ) inst_CNN (
      .clk              (clk),
      .rst_n            (rst_n),
      .in_point         (in_point),
      .frame_column_size(frame_column_size),
      .frame_row_size(frame_row_size),
      .valid_in         (valid_in),
      .kernel_type      (kernel_type),        //
      .conv_res         (conv_res),
      .valid_out        (valid_out)
  );

  int fid_in, fid_error_logged, fid_log, fid_GR;



  // Testbench initial block
  initial begin

    run_program();
    // Finish simulation
    $stop;
  end

  // generate system clock 
  always generate_clk_cycle();

  ////////////////////////////////////////
  ///////// Testbench tasks //////////////
  ///////////////////////////////////////
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

  // task for reset  the design
  task reset();
    begin
      rst_n = 0;
      clk_cycle();
      rst_n = 1;
      clk_cycle();
    end
  endtask

  // task to initialize inputs with default values
  task initialize_inputs();
    begin
      rst_n = 1;
      clk = 0;
      in_point = 0;
      frame_column_size = 0;
      frame_row_size = 0;
      valid_in = 0;
      kernel_type = 9;  // Default kernel type (e.g., 0 for identity)

    end
  endtask


  task load_inputs(input bit [PIXEL_WIDTH-1:0] data,
                   input bit [$clog2(BUFFER_LENGTH)-1:0] col_size,
                   input bit [$clog2(BUFFER_LENGTH)-1:0] row_size);
    begin
      in_point = data;
      frame_column_size = col_size;
      frame_row_size = row_size;
      valid_in = 1;
      clk_cycle();
      valid_in = 0;
    end
  endtask

  task load_frame(input int fid);
    int imgRow, imgCol, imgChannel;
    logic [PIXEL_WIDTH-1:0] input_pixel;
    int x;

    x = $fscanf(fid, "%d\n", imgRow);
    x = $fscanf(fid, "%d\n", imgCol);
    x = $fscanf(fid, "%d\n", imgChannel);


    for (int ittrCh = 0; ittrCh < imgChannel; ittrCh++)
      for (int ittrRow = 0; ittrRow < imgRow; ittrRow++)
        for (int ittrCol = 0; ittrCol < imgCol; ittrCol++) begin

          if ($feof(fid)) begin
            $display("End of input file reached while loading frame data.");
            disable load_frame;  // Exit the task if end of file is reached
          end else begin
            x = $fscanf(fid, "%d\n", input_pixel);
            load_inputs(input_pixel, imgCol,imgRow);  // Load a frame with 5 columns and 25 pixels
          end
        end

  endtask

  task log_matrix(int fid);
    begin

      $fwrite(fid, "                *********************************** \n");
      $fwrite(fid, "                - Start logging the buffer output - \n");
      $fwrite(fid, "                *********************************** \n");
      for (int i = 0; i < KERNEL_ROW_SIZE; i = i + 1) begin
        $fwrite(fid, "\n                ");
        for (int j = 0; j < KERNEL_COLUMN_SIZE; j = j + 1) begin
          $fwrite(fid, " %d",
                  inst_CNN.out_matrix[PIXEL_WIDTH*(i*KERNEL_COLUMN_SIZE+j)+:PIXEL_WIDTH]);
        end
      end
      $fwrite(fid, "\n");
    end
  endtask


  task run_program();
    begin
      open_text_files();
      initialize_inputs();
      reset();
      fork
        start_stimulus();
        log_outputs();
        check_outputs();
      join_any
    end
  endtask

  task start_stimulus();
    begin
      load_frame(fid_in);
    end
  endtask


  task open_text_files();

    string log_dir;
    string txt_dir;
    string log_file_name;
    string error_logging_file_name;
    string in_file_name;
    string gr_file_name;
    begin
      if (!$value$plusargs("LOG_DIR=%s", log_dir)) begin
        $error("Log directory not specified. Use +LOG_DIR=<%s> to set the log directory.", log_dir);
      end
      if (!$value$plusargs("TXT_DIR=%s", txt_dir)) begin
        $error("Input directory not specified. Use +TXT_DIR=<%s> to set the input directory.",
               txt_dir);
      end

      log_file_name = $sformatf("%s/sim.log", log_dir);
      error_logging_file_name = $sformatf("%s/error.log", log_dir);
      in_file_name = $sformatf("%s/PaddingVersionIn.txt", txt_dir);
      gr_file_name = $sformatf("%s/PaddingVersionGR.txt", txt_dir);



      fid_log = $fopen(log_file_name, "w");
      if (fid_log == 0) begin
        $error("Failed to open log file: %s", log_file_name);
      end else begin
        $display("TB results will be saved in: %s", log_file_name);
      end

      fid_error_logged = $fopen(error_logging_file_name, "w");
      if (fid_error_logged == 0) begin
        $error("Failed to open error log file: %s", error_logging_file_name);
      end else begin
        $display("TB error logs will be saved in: %s", error_logging_file_name);
      end

      fid_in = $fopen(in_file_name, "r");
      if (fid_in == 0) begin
        $error("Failed to open input file: %s", in_file_name);
      end else begin
        $display("Input data will be read from: %s", in_file_name);
      end

      fid_GR = $fopen(gr_file_name, "r");
      if (fid_GR == 0) begin
        $error("Failed to open GR file: %s", gr_file_name);
      end else begin
        $display("Ground truth data will be read from: %s", gr_file_name);
      end

    end
  endtask
  task log_outputs();
    begin
     forever begin
        if (valid_out) begin
          $fwrite(fid_log, "%0d row %0d, col %0d  \n", conv_res, inst_CNN.inst_PaddingVersionconv_buffer.cnt_row,inst_CNN.inst_PaddingVersionconv_buffer.cnt_col);
          clk_cycle();
        end
              #1;  
      end
    end
  endtask

  task check_outputs();
    logic [PIXEL_WIDTH-1:0] expected_value;
    int cnt_error;
    int x,row,col,ch;
    begin
      
      cnt_error = 0;
      forever begin
        if (valid_out) begin
          x = $fscanf(fid_GR, "%d %d %d %d \n", expected_value, row,col,ch);
          // $display("Expected %d, got %d", expected_value, conv_res);
          if (conv_res != expected_value) begin
            cnt_error++;
            $fwrite(fid_error_logged,
                    "*********************************************************\n");
            $fwrite(fid_error_logged, "Error #%d: Expected %d, got %d at time %t\n", cnt_error,
                    expected_value, conv_res, $time);
            $fwrite(fid_error_logged, "row %d, col %d, ch %d\n", row,col,ch);
            $fwrite(fid_error_logged, "row %d, col %d \n", inst_CNN.inst_PaddingVersionconv_buffer.cnt_row,inst_CNN.inst_PaddingVersionconv_buffer.cnt_col);
            log_matrix(fid_error_logged);
          end
          clk_cycle();
        end
        #1;
      end
    end
  endtask


endmodule
