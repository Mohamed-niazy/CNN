function point = conv_matrix(kernel_val, img_matrix)
% ---------------------------------------------------------
% Function: conv_matrix
%
% Description:
%   Computes a single convolution output value by applying
%   a kernel to an image patch (matrix).
%
%   The function performs element-wise multiplication
%   between the kernel and the corresponding image window,
%   then sums all products to generate one output pixel.
%
% Inputs:
%   kernel_val   - Convolution kernel (e.g., 3x3 matrix)
%   img_matrix   - Image patch with the same size as kernel
%
% Output:
%   point        - Convolution result (single pixel value)
%
% Notes:
%   - Image patch is cast to double to avoid overflow
%     during multiplication and accumulation.
%   - Output is cast to uint8, suitable for image display.
%   - This function represents ONE convolution point,
%     similar to a MAC tree in hardware.
% ---------------------------------------------------------


% Perform element-wise multiplication between kernel and image patch,
% then sum all values to produce a single convolution output
point = uint8(floor(sum( sum( kernel_val .* double(img_matrix) ), "all" )) );

end
