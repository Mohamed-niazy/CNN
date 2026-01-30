`include "kernel_value.svh"


module CNN #(
    parameter PIXEL_WIDTH        = 8,         // Pixel width (e.g., 8-bit grayscale)
    parameter KERNEL_WIDTH       = 5,         // Kernel coefficient width
    parameter ADDER_TYPE         = "RIPPLE",  // Adder architecture (for synthesis experiments)
    parameter MULTIPLIER_TYPE    = "ARRAY",   // Multiplier architecture
    parameter KERNEL_ROW_SIZE    = 3,         // Convolution window size (3×3)
    parameter KERNEL_COLUMN_SIZE = 3,         // Derived parameters
    parameter BUFFER_LENGTH      = 2000
) (
    input  wire                             clk,
    input  wire                             rst_n,
    input  wire [          PIXEL_WIDTH-1:0] in_point,
    input  wire [$clog2(BUFFER_LENGTH)-1:0] frame_column_size,
    input  wire                             valid_in,
    input  wire [                      4:0] kernel_type,        //
    output wire [          PIXEL_WIDTH-1:0] conv_res,
    output wire                             valid_out
);



  wire [KERNEL_ROW_SIZE*   KERNEL_COLUMN_SIZE   *  PIXEL_WIDTH-1:0] out_matrix;
  wire                                                              blur_flag;


  assign blur_flag = (kernel_type == K_GAUSSIAN_BLUR_1 || kernel_type == K_GAUSSIAN_BLUR_2  ); // 1: blur kernel, 0: others


  conv_buffer #(
      .DATA_WIDTH        (PIXEL_WIDTH),
      .BUFFER_LENGTH     (BUFFER_LENGTH),
      .KERNEL_ROW_SIZE   (KERNEL_ROW_SIZE),
      .KERNEL_COLUMN_SIZE(KERNEL_COLUMN_SIZE)
  ) inst_conv_buffer (
      .clk(clk),
      .rst_n(rst_n),
      .in_point(in_point),
      .frame_column_size(frame_column_size),
      .valid_in(valid_in),
      .out_matrix(out_matrix),
      .valid_out(valid_out)
  );



  conv_mat #(
      .IMAGE_WIDTH    (PIXEL_WIDTH),
      .KERNEL_WIDTH   (KERNEL_WIDTH),
      .ADDER_TYPE     (ADDER_TYPE),
      .MULTIPLIER_TYPE(MULTIPLIER_TYPE),
      .MATRIX_SIZE    (KERNEL_COLUMN_SIZE)
  ) inst_conv_mat (
      .in_matrix(out_matrix),
      .kernel(kernel_bank[kernel_type]),
      .blur_flag(blur_flag),
      .conv_res(conv_res)
  );





endmodule
