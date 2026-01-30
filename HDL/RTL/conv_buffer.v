module conv_buffer #(
    parameter DATA_WIDTH         = 8,
    parameter BUFFER_LENGTH      = 2000,
    parameter KERNEL_ROW_SIZE    = 3,
    parameter KERNEL_COLUMN_SIZE = 3
) (
    input  wire                                                             clk,
    input  wire                                                             rst_n,
    input  wire [                                           DATA_WIDTH-1:0] in_point,
    input  wire [                                $clog2(BUFFER_LENGTH)-1:0] frame_column_size,
    input  wire                                                             valid_in,
    output reg  [KERNEL_ROW_SIZE*   KERNEL_COLUMN_SIZE   *  DATA_WIDTH-1:0] out_matrix,
    output reg                                                              valid_out
);

  reg [KERNEL_ROW_SIZE*DATA_WIDTH-1:0] buff_1, buff_2, buff_3;
  reg [KERNEL_ROW_SIZE*DATA_WIDTH-1:0] temp_buff_1, temp_buff_2, temp_buff_3;
  // reg  mem_1 mem_2          
  reg [$clog2(BUFFER_LENGTH)-1:0] cnt_col, cnt_row, reg_cnt_col;

  reg [DATA_WIDTH-1:0] temp_1, temp_2;
  reg reg_flag, reg_valid_in;
  wire flag;

  assign flag =(cnt_col >= KERNEL_COLUMN_SIZE - 1) && (cnt_row >= KERNEL_COLUMN_SIZE - 1)?  1'b1 : 1'b0;

  //   assign out_matrix = {buff_3, temp_buff_2, temp_buff_1};
  //   assign out_matrix = (valid_out)?{temp_buff_3, temp_buff_2, temp_buff_1}:
  //                                   { {(KERNEL_ROW_SIZE*DATA_WIDTH){1'b0}} };
  assign temp_buff_3 = {
    in_point, buff_3[(KERNEL_COLUMN_SIZE*DATA_WIDTH-1)-:(KERNEL_COLUMN_SIZE-1)*DATA_WIDTH]
  };
  assign temp_buff_2 = {
    temp_1, buff_2[(KERNEL_COLUMN_SIZE*DATA_WIDTH-1)-:(KERNEL_COLUMN_SIZE-1)*DATA_WIDTH]
  };
  assign temp_buff_1 = {
    temp_2, buff_1[(KERNEL_COLUMN_SIZE*DATA_WIDTH-1)-:(KERNEL_COLUMN_SIZE-1)*DATA_WIDTH]
  };


  always @(*) begin
    if (!rst_n) begin
      out_matrix = {(KERNEL_ROW_SIZE * KERNEL_COLUMN_SIZE * DATA_WIDTH) {1'b0}};
    end else begin
      if (valid_out) begin
        if (cnt_col == 1)
          out_matrix = {
            {{DATA_WIDTH{1'b0}}, buff_3[DATA_WIDTH*2-1:0]},
            {{DATA_WIDTH{1'b0}}, temp_buff_2[DATA_WIDTH*2-1:0]},
            {{DATA_WIDTH{1'b0}}, temp_buff_1[DATA_WIDTH*2-1:0]}
          };
        else if (cnt_col == 2)
          out_matrix = {
            {{(DATA_WIDTH * 2) {1'b0}}, buff_3[DATA_WIDTH-1:0]},
            {{(DATA_WIDTH * 2) {1'b0}}, temp_buff_2[DATA_WIDTH-1:0]},
            {{(DATA_WIDTH * 2) {1'b0}}, temp_buff_1[DATA_WIDTH-1:0]}
          };
        else out_matrix = {buff_3, temp_buff_2, temp_buff_1};
      end else out_matrix = {(KERNEL_ROW_SIZE * KERNEL_COLUMN_SIZE * DATA_WIDTH) {1'b0}};
    end

  end

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      cnt_col <= 0;
      reg_cnt_col <= 0;
      cnt_row <= 0;
      valid_out <= 0;
      buff_3 <= {(KERNEL_ROW_SIZE * DATA_WIDTH) {1'b0}};
      buff_2 <= {(KERNEL_ROW_SIZE * DATA_WIDTH) {1'b0}};
      buff_1 <= {(KERNEL_ROW_SIZE * DATA_WIDTH) {1'b0}};
      reg_flag <= 1'b0;
      reg_valid_in <= 1'b0;

    end else begin
      if (valid_in) begin

        buff_3 <= temp_buff_3;
        buff_2 <= temp_buff_2;
        buff_1 <= temp_buff_1;


        if (cnt_col == frame_column_size - 1) begin
          cnt_col <= 0;
          cnt_row <= cnt_row + 1'b1;
        end else cnt_col <= cnt_col + 1'b1;

        if ((cnt_col >= KERNEL_COLUMN_SIZE - 1) && (cnt_row >= KERNEL_COLUMN_SIZE - 1)) begin
          reg_flag <= 1'b1;
        end
        reg_cnt_col <= cnt_col;

        if (flag || reg_flag) valid_out <= 1'b1;

      end

    end
    reg_valid_in <= valid_in;

  end



  trueDualMemReadFirst #(
      .RAM_WIDTH(DATA_WIDTH),  // Specify RAM data width
      .RAM_DEPTH(BUFFER_LENGTH),  // Specify RAM depth (number of entries)
      .INIT_FILE("")// Specify name/location of RAM initialization file if using one (leave blank if not)
  ) inst_mem_1 (
      .addra(cnt_col),  // Port A address bus, width determined from RAM_DEPTH
      //   .addrb((cnt_col==0)? frame_column_size :  cnt_col - 1'b1),  // Port B address bus, width determined from RAM_DEPTH
      .addrb(cnt_col),  // Port B address bus, width determined from RAM_DEPTH
      .dina(in_point),  // Port A RAM input data
      .dinb({DATA_WIDTH{1'b0}}),  // Port B RAM input data
      .clka(clk),  // Clock
      .wea(valid_in),  // Port A write enable
      .web(1'b0),  // Port B write enable
      .ena(valid_in      ),// Port A RAM Enable, for additional power savings, disable port when not in use
      .enb(       valid_in      ),// Port B RAM Enable, for additional power savings, disable port when not in use
      .douta(),  // Port A RAM output data
      .doutb(temp_1)
  );
  trueDualMemReadFirst #(
      .RAM_WIDTH(DATA_WIDTH),  // Specify RAM data width
      .RAM_DEPTH(BUFFER_LENGTH),  // Specify RAM depth (number of entries)
      .INIT_FILE("")// Specify name/location of RAM initialization file if using one (leave blank if not)
  ) inst_mem_2 (
      .addra(reg_cnt_col),  // Port A address bus, width determined from RAM_DEPTH
      //   .addrb((cnt_col==0)? frame_column_size :  cnt_col - 1'b1),  // Port B address bus, width determined from RAM_DEPTH
      .addrb(cnt_col),  // Port B address bus, width determined from RAM_DEPTH
      .dina(temp_1),  // Port A RAM input data
      .dinb({DATA_WIDTH{1'b0}}),  // Port B RAM input data
      .clka(clk),  // Clock
      .wea(reg_valid_in),  // Port A write enable
      .web(1'b0),  // Port B write enable
      .ena(reg_valid_in      ),// Port A RAM Enable, for additional power savings, disable port when not in use
      .enb(       valid_in      ),// Port B RAM Enable, for additional power savings, disable port when not in use
      .douta(),  // Port A RAM output data
      .doutb(temp_2)
  );

endmodule
