

// ---------------------------------------------------------
//  Kernel ID Parameters
//  (Enum-style definitions with description and usage)
// ---------------------------------------------------------
parameter K_IDENTITY              = 1;
parameter K_SOBEL_X               = 2;
parameter K_SOBEL_Y               = 3;
parameter K_PREWITT_X             = 4;
parameter K_PREWITT_Y             = 5;
parameter K_SCHARR_X              = 6;
parameter K_SCHARR_Y              = 7;
parameter K_LAPLACIAN_4           = 8;
parameter K_LAPLACIAN_8           = 9;
parameter K_SHARPEN_BASIC         = 10;
parameter K_SHARPEN_STRONG        = 11;
parameter K_HIGH_BOOST            = 12;
parameter K_BOX_BLUR              = 13; // not used 
parameter K_GAUSSIAN_BLUR_1       = 14;
parameter K_GAUSSIAN_BLUR_2       = 15;
parameter K_KIRSCH_N              = 16;
parameter K_KIRSCH_S              = 17;
parameter K_KIRSCH_E              = 18;
parameter K_KIRSCH_W              = 19;
parameter K_KIRSCH_NE             = 20;
parameter K_KIRSCH_NW             = 21;
parameter K_KIRSCH_SE             = 22;
parameter K_KIRSCH_SW             = 23;
// ---------------------------------------------------------
// Kernel Definitions
// (Each kernel includes definition and usage comments)
// ---------------------------------------------------------

// Identity kernel
// Definition: Pass-through filter
// Usage: Image unchanged, pipeline validation

parameter [3*3*5-1:0] kernel_bank  [23]={
//  K_IDENTITY

{
     5'sd0,   5'sd0,   5'sd0,
     5'sd0,   5'sd1,   5'sd0,
     5'sd0,   5'sd0,   5'sd0
},


// Sobel X kernel
// Definition: First-order derivative in x-direction
// Usage: Vertical edge detection
//  K_SOBEL_X
{
     5'sd1,   5'sd0,  -5'sd1,
     5'sd2,   5'sd0,  -5'sd2,
     5'sd1,   5'sd0,  -5'sd1
},


// Sobel Y kernel
// Definition: First-order derivative in y-direction
// Usage: Horizontal edge detection
//  K_SOBEL_Y
{
     5'sd1,   5'sd2,   5'sd1,
     5'sd0,   5'sd0,   5'sd0,
    -5'sd1,  -5'sd2,  -5'sd1
},


// Prewitt X kernel
// Definition: Gradient approximation (x-direction)
// Usage: Edge detection with simple arithmetic
//  K_PREWITT_X
{
     5'sd1,   5'sd0,  -5'sd1,
     5'sd1,   5'sd0,  -5'sd1,
     5'sd1,   5'sd0,  -5'sd1
},


// Prewitt Y kernel
// Definition: Gradient approximation (y-direction)
// Usage: Horizontal edge detection
//  K_PREWITT_Y
{
     5'sd1,   5'sd1,   5'sd1,
     5'sd0,   5'sd0,   5'sd0,
    -5'sd1,  -5'sd1,  -5'sd1
},


// Scharr X kernel
// Definition: Optimized Sobel variant (x-direction)
// Usage: High-precision edge detection
//  K_SCHARR_X
{
    5'sd3,   5'sd0,  -5'sd3,
    5'sd1,   5'sd0,   5'sd0,
    5'sd3,   5'sd0,  -5'sd3
},


// Scharr Y kernel
// Definition: Optimized Sobel variant (y-direction)
// Usage: High-precision horizontal edge detection
//  K_SCHARR_Y
{
     5'sd3,   5'sd1,   5'sd3,
     5'sd0,   5'sd0,   5'sd0,
    -5'sd3,  -5'sd1,  -5'sd3
},


// Laplacian (4-neighbor)
// Definition: Second-order derivative operator
// Usage: Edge detection in all directions
//  K_LAPLACIAN_4
{
     5'sd0,  -5'sd1,   5'sd0,
    -5'sd1,   5'sd4,  -5'sd1,
     5'sd0,  -5'sd1,   5'sd0
},


// Laplacian (8-neighbor)
// Definition: Strong second-order derivative operator
// Usage: Enhanced edge response including diagonals
//  K_LAPLACIAN_8
{
    -5'sd1,  -5'sd1,  -5'sd1,
    -5'sd1,   5'sd8,  -5'sd1,
    -5'sd1,  -5'sd1,  -5'sd1
},


// Basic sharpen kernel
// Definition: High-pass enhancement filter
// Usage: Moderate edge and detail enhancement
//  K_SHARPEN_BASIC
{
     5'sd0,  -5'sd1,   5'sd0,
    -5'sd1,   5'sd5,  -5'sd1,
     5'sd0,  -5'sd1,   5'sd0
},


// Strong sharpen kernel
// Definition: Aggressive high-pass filter
// Usage: Strong detail enhancement
//  K_SHARPEN_STRONG
{
    -5'sd1,  -5'sd1,  -5'sd1,
    -5'sd1,   5'sd9,  -5'sd1,
    -5'sd1,  -5'sd1,  -5'sd1
},


// High-boost kernel
// Definition: Amplified high-pass sharpening
// Usage: Fine detail emphasis
//  K_HIGH_BOOST
{
    -5'sd1,  -5'sd1,  -5'sd1,
    -5'sd1,   5'sd8,  -5'sd1,
    -5'sd1,  -5'sd1,  -5'sd1
},




// Gaussian blur kernel (σ ≈ 5'sd0,.8)
// Definition: Weighted averaging filter
// Usage: Smooths image while preserving edges
//  K_BOX_BLUR
{
     5'sd0,   5'sd0,   5'sd0,
     5'sd0,   5'sd0,   5'sd0,
     5'sd0,   5'sd0,   5'sd0
},




// Gaussian blur kernel (σ ≈ 5'sd0,.8)
// Definition: Weighted averaging filter
// Usage: Smooths image while preserving edges
//  K_GAUSSIAN_BLUR_1
{
     5'sd1,   5'sd2,   5'sd1,
     5'sd2,   5'sd4,   5'sd2,
     5'sd1,   5'sd2,   5'sd1
},


// Strong Gaussian-like blur kernel
// Definition: Heavy smoothing filter
// Usage: Strong noise suppression
//  K_GAUSSIAN_BLUR_2
{
     5'sd1,   5'sd1,   5'sd1,
     5'sd1,   5'sd8,   5'sd1,
     5'sd1,   5'sd1,   5'sd1
},


// Kirsch North kernel
// Definition: Directional edge detector (north)
// Usage: Detects edges facing north
//  K_KIRSCH_N
{
     5'sd5,   5'sd5,   5'sd5,
    -5'sd3,   5'sd0,  -5'sd3,
    -5'sd3,  -5'sd3,  -5'sd3
},


// Kirsch South kernel
// Definition: Directional edge detector (south)
// Usage: Detects edges facing south
//  K_KIRSCH_S
{
    -5'sd3,  -5'sd3,  -5'sd3,
    -5'sd3,   5'sd0,  -5'sd3,
     5'sd5,   5'sd5,   5'sd5
},


// Kirsch East kernel
// Definition: Directional edge detector (east)
// Usage: Detects vertical edges
//  K_KIRSCH_E
{
    -5'sd3,  -5'sd3,   5'sd5,
    -5'sd3,   5'sd0,   5'sd5,
    -5'sd3,  -5'sd3,   5'sd5
},


// Kirsch West kernel
// Definition: Directional edge detector (west)
// Usage: Detects vertical edges
//  K_KIRSCH_W
{
     5'sd5,  -5'sd3,  -5'sd3,
     5'sd5,   5'sd0,  -5'sd3,
     5'sd5,  -5'sd3,  -5'sd3
},


// Kirsch North-East kernel
// Definition: Directional diagonal edge detector
// Usage: Detects NE diagonal edges
//  K_KIRSCH_NE
{
    -5'sd3,   5'sd5,   5'sd5,
    -5'sd3,   5'sd0,   5'sd5,
    -5'sd3,  -5'sd3,  -5'sd3
},


// Kirsch North-West kernel
// Definition: Directional diagonal edge detector
// Usage: Detects NW diagonal edges
//  K_KIRSCH_NW
{
     5'sd5,   5'sd5,  -5'sd3,
     5'sd5,   5'sd0,  -5'sd3,
    -5'sd3,  -5'sd3,  -5'sd3
},


// Kirsch South-East kernel
// Definition: Directional diagonal edge detector
// Usage: Detects SE diagonal edges
//  K_KIRSCH_SE
{
    -5'sd3,  -5'sd3,  -5'sd3,
    -5'sd3,   5'sd0,   5'sd5,
    -5'sd3,   5'sd5,   5'sd5
},


// Kirsch South-West kernel
// Definition: Directional diagonal edge detector
// Usage: Detects SW diagonal edges
//  K_KIRSCH_SW
{
    -5'sd3,  -5'sd3,  -5'sd3,
    -5'sd3,   5'sd0,  -5'sd3,
    -5'sd3,  -5'sd3,  -5'sd3
}
};
