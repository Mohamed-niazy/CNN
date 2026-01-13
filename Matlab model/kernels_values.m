%% =========================================================
%  Kernel Bank (3x3)
%
%  Description:
%  This file defines a bank of 3x3 image-processing kernels
%  stored in a single 3D array:
%
%      kernel_bank(row, col, kernel_id)
%
%  Each kernel_id is defined as a parameter (enum-style)
%  with a clear description and usage.
%
%  Suitable for:
%   - CNN MATLAB modeling
%   - RTL / ASIC convolution engines
%   - ROM-based kernel storage
%   =========================================================


%% ---------------------------------------------------------
%  Kernel ID Parameters
%  (Enum-style definitions with description and usage)
% ---------------------------------------------------------

% K_IDENTITY:
% Identity kernel – output equals input
% Usage: Debugging, bypass path validation, CNN sanity checks
K_IDENTITY              = 1;

% K_SOBEL_X:
% Sobel horizontal gradient kernel
% Usage: Detects vertical edges (x-direction intensity change)
K_SOBEL_X               = 2;

% K_SOBEL_Y:
% Sobel vertical gradient kernel
% Usage: Detects horizontal edges (y-direction intensity change)
K_SOBEL_Y               = 3;

% K_PREWITT_X:
% Prewitt horizontal gradient kernel
% Usage: Edge detection with lower noise sensitivity
K_PREWITT_X             = 4;

% K_PREWITT_Y:
% Prewitt vertical gradient kernel
% Usage: Detects horizontal edges
K_PREWITT_Y             = 5;

% K_SCHARR_X:
% Scharr horizontal gradient kernel
% Usage: High-accuracy edge detection with improved symmetry
K_SCHARR_X              = 6;

% K_SCHARR_Y:
% Scharr vertical gradient kernel
% Usage: Accurate detection of horizontal edges
K_SCHARR_Y              = 7;

% K_LAPLACIAN_4:
% Laplacian kernel (4-neighbor)
% Usage: Second-order edge detection in all directions
K_LAPLACIAN_4           = 8;

% K_LAPLACIAN_8:
% Laplacian kernel (8-neighbor)
% Usage: Stronger edge detection including diagonals
K_LAPLACIAN_8           = 9;

% K_SHARPEN_BASIC:
% Basic sharpening kernel
% Usage: Enhances edges while preserving image structure
K_SHARPEN_BASIC         = 10;

% K_SHARPEN_STRONG:
% Strong sharpening kernel
% Usage: Aggressive enhancement of high-frequency details
K_SHARPEN_STRONG        = 11;

% K_HIGH_BOOST:
% High-boost sharpening kernel
% Usage: Strong emphasis on fine details and edges
K_HIGH_BOOST            = 12;

% K_BOX_BLUR:
% Box (mean) blur kernel
% Usage: Noise reduction and smoothing
K_BOX_BLUR              = 13;

% K_GAUSSIAN_BLUR_1:
% Gaussian blur kernel (σ ≈ 0.8)
% Usage: Smooths image with minimal edge distortion
K_GAUSSIAN_BLUR_1       = 14;

% K_GAUSSIAN_BLUR_2:
% Stronger Gaussian-like blur kernel
% Usage: Heavy smoothing and noise suppression
K_GAUSSIAN_BLUR_2       = 15;

% K_KIRSCH_N:
% Kirsch compass kernel (North)
% Usage: Directional edge detection (north direction)
K_KIRSCH_N              = 16;

% K_KIRSCH_S:
% Kirsch compass kernel (South)
% Usage: Directional edge detection (south direction)
K_KIRSCH_S              = 17;

% K_KIRSCH_E:
% Kirsch compass kernel (East)
% Usage: Directional detection of vertical edges
K_KIRSCH_E              = 18;

% K_KIRSCH_W:
% Kirsch compass kernel (West)
% Usage: Directional detection of vertical edges
K_KIRSCH_W              = 19;

% K_KIRSCH_NE:
% Kirsch compass kernel (North-East)
% Usage: Diagonal edge detection
K_KIRSCH_NE             = 20;

% K_KIRSCH_NW:
% Kirsch compass kernel (North-West)
% Usage: Diagonal edge detection
K_KIRSCH_NW             = 21;

% K_KIRSCH_SE:
% Kirsch compass kernel (South-East)
% Usage: Diagonal edge detection
K_KIRSCH_SE             = 22;

% K_KIRSCH_SW:
% Kirsch compass kernel (South-West)
% Usage: Diagonal edge detection
K_KIRSCH_SW             = 23;


%% ---------------------------------------------------------
%  Kernel Storage Allocation
%  ---------------------------------------------------------
NUM_KERNELS = 23;

kernel_bank = zeros(3, 3, NUM_KERNELS);


%% ---------------------------------------------------------
%  Kernel Definitions
%  (Each kernel includes definition and usage comments)
%  ---------------------------------------------------------

% Identity kernel
% Definition: Pass-through filter
% Usage: Image unchanged, pipeline validation
kernel_bank(:,:,K_IDENTITY) = [
     0   0   0;
     0   1   0;
     0   0   0
];


% Sobel X kernel
% Definition: First-order derivative in x-direction
% Usage: Vertical edge detection
kernel_bank(:,:,K_SOBEL_X) = [
     1   0  -1;
     2   0  -2;
     1   0  -1
];


% Sobel Y kernel
% Definition: First-order derivative in y-direction
% Usage: Horizontal edge detection
kernel_bank(:,:,K_SOBEL_Y) = [
     1   2   1;
     0   0   0;
    -1  -2  -1
];


% Prewitt X kernel
% Definition: Gradient approximation (x-direction)
% Usage: Edge detection with simple arithmetic
kernel_bank(:,:,K_PREWITT_X) = [
     1   0  -1;
     1   0  -1;
     1   0  -1
];


% Prewitt Y kernel
% Definition: Gradient approximation (y-direction)
% Usage: Horizontal edge detection
kernel_bank(:,:,K_PREWITT_Y) = [
     1   1   1;
     0   0   0;
    -1  -1  -1
];


% Scharr X kernel
% Definition: Optimized Sobel variant (x-direction)
% Usage: High-precision edge detection
kernel_bank(:,:,K_SCHARR_X) = [
     3   0  -3;
    10   0 -10;
     3   0  -3
];


% Scharr Y kernel
% Definition: Optimized Sobel variant (y-direction)
% Usage: High-precision horizontal edge detection
kernel_bank(:,:,K_SCHARR_Y) = [
     3  10   3;
     0   0   0;
    -3 -10  -3
];


% Laplacian (4-neighbor)
% Definition: Second-order derivative operator
% Usage: Edge detection in all directions
kernel_bank(:,:,K_LAPLACIAN_4) = [
     0  -1   0;
    -1   4  -1;
     0  -1   0
];


% Laplacian (8-neighbor)
% Definition: Strong second-order derivative operator
% Usage: Enhanced edge response including diagonals
kernel_bank(:,:,K_LAPLACIAN_8) = [
    -1  -1  -1;
    -1   8  -1;
    -1  -1  -1
];


% Basic sharpen kernel
% Definition: High-pass enhancement filter
% Usage: Moderate edge and detail enhancement
kernel_bank(:,:,K_SHARPEN_BASIC) = [
     0  -1   0;
    -1   5  -1;
     0  -1   0
];


% Strong sharpen kernel
% Definition: Aggressive high-pass filter
% Usage: Strong detail enhancement
kernel_bank(:,:,K_SHARPEN_STRONG) = [
    -1  -1  -1;
    -1   9  -1;
    -1  -1  -1
];


% High-boost kernel
% Definition: Amplified high-pass sharpening
% Usage: Fine detail emphasis
kernel_bank(:,:,K_HIGH_BOOST) = [
    -1  -1  -1;
    -1   8  -1;
    -1  -1  -1
];


% Box blur kernel
% Definition: Uniform averaging filter
% Usage: Noise reduction and smoothing
kernel_bank(:,:,K_BOX_BLUR) = (1/9) * [
     1   1   1;
     1   1   1;
     1   1   1
];


% Gaussian blur kernel (σ ≈ 0.8)
% Definition: Weighted averaging filter
% Usage: Smooths image while preserving edges
kernel_bank(:,:,K_GAUSSIAN_BLUR_1) = (1/16) * [
     1   2   1;
     2   4   2;
     1   2   1
];


% Strong Gaussian-like blur kernel
% Definition: Heavy smoothing filter
% Usage: Strong noise suppression
kernel_bank(:,:,K_GAUSSIAN_BLUR_2) = (1/16) * [
     1   1   1;
     1   8   1;
     1   1   1
];


% Kirsch North kernel
% Definition: Directional edge detector (north)
% Usage: Detects edges facing north
kernel_bank(:,:,K_KIRSCH_N) = [
     5   5   5;
    -3   0  -3;
    -3  -3  -3
];


% Kirsch South kernel
% Definition: Directional edge detector (south)
% Usage: Detects edges facing south
kernel_bank(:,:,K_KIRSCH_S) = [
    -3  -3  -3;
    -3   0  -3;
     5   5   5
];


% Kirsch East kernel
% Definition: Directional edge detector (east)
% Usage: Detects vertical edges
kernel_bank(:,:,K_KIRSCH_E) = [
    -3  -3   5;
    -3   0   5;
    -3  -3   5
];


% Kirsch West kernel
% Definition: Directional edge detector (west)
% Usage: Detects vertical edges
kernel_bank(:,:,K_KIRSCH_W) = [
     5  -3  -3;
     5   0  -3;
     5  -3  -3
];


% Kirsch North-East kernel
% Definition: Directional diagonal edge detector
% Usage: Detects NE diagonal edges
kernel_bank(:,:,K_KIRSCH_NE) = [
    -3   5   5;
    -3   0   5;
    -3  -3  -3
];


% Kirsch North-West kernel
% Definition: Directional diagonal edge detector
% Usage: Detects NW diagonal edges
kernel_bank(:,:,K_KIRSCH_NW) = [
     5   5  -3;
     5   0  -3;
    -3  -3  -3
];


% Kirsch South-East kernel
% Definition: Directional diagonal edge detector
% Usage: Detects SE diagonal edges
kernel_bank(:,:,K_KIRSCH_SE) = [
    -3  -3  -3;
    -3   0   5;
    -3   5   5
];


% Kirsch South-West kernel
% Definition: Directional diagonal edge detector
% Usage: Detects SW diagonal edges
kernel_bank(:,:,K_KIRSCH_SW) = [
    -3  -3  -3;
     5   0  -3;
     5   5  -3
];
