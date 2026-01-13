module conv_mat #(
    parameter IMAGE_WIDTH     = 8,         // Pixel width (e.g., 8-bit grayscale)
              KERNEL_WIDTH    = 5,         // Kernel coefficient width
              ADDER_TYPE      = "RIPPLE",  // Adder architecture (for synthesis experiments)
              MULTIPLIER_TYPE = "ARRAY",   // Multiplier architecture
              MATRIX_SIZE     = 3          // Convolution window size (3×3)
) (
    // Flattened 3×3 image window input (each pixel is IMAGE_WIDTH bits)
    input logic [IMAGE_WIDTH * MATRIX_SIZE**2 - 1 : 0] in_matrix,

    // Flattened 3×3 kernel coefficients (signed)
    input logic signed [KERNEL_WIDTH * MATRIX_SIZE**2 - 1 : 0] kernel,

    // Control: if blur_flag=1 → divide by 16 (used for averaging/blur filters)
    input logic blur_flag,

    // 8-bit output pixel after convolution + saturation
    output logic [IMAGE_WIDTH-1:0] out_matrix
);

  // Width of each multiplication result (pixel × kernel)
  localparam MUL_WIDTH = IMAGE_WIDTH + KERNEL_WIDTH;

  // Stores results of 9 multipliers (each MUL_WIDTH bits)
  logic signed [MUL_WIDTH * MATRIX_SIZE**2 - 1 : 0] mul_results;

  // Temporary row-wise sums:
  // sum_res_c1_c2: sum of column0 + column1 for each of 3 rows
  // sum_res_c12_c3: final row sum (col0 + col1 + col2)
  logic signed [MUL_WIDTH * MATRIX_SIZE - 1 : 0] sum_res_c1_c2;
  logic signed [MUL_WIDTH * MATRIX_SIZE - 1 : 0] sum_res_c12_c3;

  // Final summing logic outputs
  logic signed [MUL_WIDTH-1:0] sum_temp;
  logic signed [MUL_WIDTH-1:0] final_sum;
  logic signed [MUL_WIDTH-1:0] temp_div;

  genvar ittr;
  generate
    begin

      //--------------------------------------------------------------------
      // 1) Generate 9 multipliers for the 3×3 window
      //--------------------------------------------------------------------
      for (ittr = 0; ittr < MATRIX_SIZE ** 2; ittr = ittr + 1) begin : gen_mults

        multiplier #(
            .MULTIPLIER_TYPE(MULTIPLIER_TYPE),
            .WIDTH_A        (IMAGE_WIDTH + 1),  // +1 for zero extension
            .WIDTH_B        (KERNEL_WIDTH)
        ) inst_multiplier (
            .a({1'b0, in_matrix[ittr*IMAGE_WIDTH+:IMAGE_WIDTH]}),  // make pixel unsigned
            .b(kernel[ittr*KERNEL_WIDTH+:KERNEL_WIDTH]),
            .product(mul_results[ittr*MUL_WIDTH+:MUL_WIDTH])
        );

      end


      //--------------------------------------------------------------------
      // 2) Row-wise adder tree
      // For each row:
      //   (pixel0*kernel0) + (pixel1*kernel1) + (pixel2*kernel2)
      //--------------------------------------------------------------------
      for (ittr = 0; ittr < MATRIX_SIZE; ittr = ittr + 1) begin : gen_adder_inputs

        // Sum column 0 + column 1
        adder #(
            .ADDER_TYPE(ADDER_TYPE),
            .WIDTH(MUL_WIDTH)
        ) inst_adder_c1_c2 (
            .a(mul_results[(ittr*MATRIX_SIZE+0)*MUL_WIDTH+:MUL_WIDTH]),
            .b(mul_results[(ittr*MATRIX_SIZE+1)*MUL_WIDTH+:MUL_WIDTH]),
            .sum(sum_res_c1_c2[ittr*MUL_WIDTH+:MUL_WIDTH]),
            .cout()
        );

        // Add column 2 → complete row sum
        adder #(
            .ADDER_TYPE(ADDER_TYPE),
            .WIDTH(MUL_WIDTH)
        ) inst_adder_c12_c3 (
            .a(sum_res_c1_c2[ittr*MUL_WIDTH+:MUL_WIDTH]),
            .b(mul_results[(ittr*MATRIX_SIZE+2)*MUL_WIDTH+:MUL_WIDTH]),
            .sum(sum_res_c12_c3[ittr*MUL_WIDTH+:MUL_WIDTH]),
            .cout()
        );

      end
    end
  endgenerate


  //--------------------------------------------------------------------
  // 3) Add the 3 row results: row0 + row1 + row2
  //--------------------------------------------------------------------
  adder #(
      .ADDER_TYPE(ADDER_TYPE),
      .WIDTH(MUL_WIDTH)
  ) inst_final_adder_1_2 (
      .a(sum_res_c12_c3[0+:MUL_WIDTH]),
      .b(sum_res_c12_c3[MUL_WIDTH+:MUL_WIDTH]),
      .sum(sum_temp),
      .cout()
  );

  adder #(
      .ADDER_TYPE(ADDER_TYPE),
      .WIDTH(MUL_WIDTH)
  ) inst_final_adder_12_3 (
      .a(sum_temp),
      .b(sum_res_c12_c3[2*MUL_WIDTH+:MUL_WIDTH]),
      .sum(final_sum),
      .cout()
  );


  //--------------------------------------------------------------------
  // 4) Optional division for blur (divide by 16 → shift right by 4)
  //--------------------------------------------------------------------
  assign temp_div = final_sum >> (blur_flag ? 4 : 0);


  //--------------------------------------------------------------------
  // 5) Saturation logic:
  //    - If negative → output 0
  //    - If value exceeds 8-bit range → output 255
  //    - Else → output lower IMAGE_WIDTH bits
  //--------------------------------------------------------------------
  assign out_matrix = final_sum[MUL_WIDTH-1] ? 'b0 :  // Negative value → 0
      |temp_div[MUL_WIDTH-2:IMAGE_WIDTH] ? 'hff :  // Overflow → clamp to 255
      temp_div[IMAGE_WIDTH-1:0];  // Valid range


endmodule
