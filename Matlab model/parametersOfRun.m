kernels_values


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% K_IDENTITY              = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detedction kernels 
% K_SOBEL_X               = 2;
% K_SOBEL_Y               = 3;
% K_PREWITT_X             = 4;
% K_PREWITT_Y             = 5;
% K_SCHARR_X              = 6;
% K_SCHARR_Y              = 7;
% K_LAPLACIAN_4           = 8;
% K_LAPLACIAN_8           = 9;

% K_KIRSCH_N              = 16;
% K_KIRSCH_S              = 17;
% K_KIRSCH_E              = 18;
% K_KIRSCH_W              = 19;
% K_KIRSCH_NE             = 20;
% K_KIRSCH_NW             = 21;
% K_KIRSCH_SE             = 22;
% K_KIRSCH_SW             = 23;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sharpening kernel
% K_SHARPEN_BASIC         = 10;
% K_SHARPEN_STRONG        = 11;
% K_HIGH_BOOST            = 12;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%blur kernel
% K_BOX_BLUR              = 13;
% K_GAUSSIAN_BLUR_1       = 14;
% K_GAUSSIAN_BLUR_2       = 15;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

usedkernel=10;
forcedActivaeGrayMode= 0 ;
kernel= kernel_bank(:,:,usedkernel);
noOfColumn=3;
noOfRow=3;
bufferWidth=2500;
requiredImageWidth=200;
requiredImageHeight=200;
imgPath= "D:\mm\niazy.jpg";
TxtPath= 'E:\CNN\TxtFiles';
grayMode= ~((usedkernel>9 && usedkernel<16)|usedkernel==1)| forcedActivaeGrayMode ;
