function [ResizedImage, imgHeight, imgWidth, imgChannel] = ...
    resize_image(imgPath, requiredImageWidth, requiredImageHeight, grayMode)
% ---------------------------------------------------------
% Function: resize_image
%
% Description:
%   Reads an image from disk, resizes it using pixel skipping
%   (downsampling), and optionally converts it to grayscale.
%   The function also displays the image before and after resizing.
%
% Inputs:
%   imgPath              - Path to the input image file
%   requiredImageWidth   - Desired output image width
%   requiredImageHeight  - Desired output image height
%   grayMode             - Grayscale control flag
%                           1 -> Convert image to grayscale
%                           0 -> Keep original color channels
%
% Outputs:
%   ResizedImage         - Output resized image
%   imgHeight            - Height of resized image
%   imgWidth             - Width of resized image
%   imgChannel           - Number of image channels (1 or 3)
%
% Notes:
%   - Resizing is done by subsampling (pixel skipping).
%   - No interpolation is used (hardware-friendly approach).
%   - Suitable for fast preprocessing and CNN input modeling.
% ---------------------------------------------------------


% ---------------------------------------------------------
% Read input image from file
% ---------------------------------------------------------
img = imread(imgPath);


% ---------------------------------------------------------
% Display original image with its dimensions
% ---------------------------------------------------------
figure
imshow(img)
title(['Image before resize by ' ...
       int2str(size(img,1)) ' x ' ...
       int2str(size(img,2)) ' x ' ...
       int2str(size(img,3))])


% ---------------------------------------------------------
% Get original image dimensions
% ---------------------------------------------------------
tempimgHeight = size(img,1);   % Original image height
tempimgWidth  = size(img,2);   % Original image width


% ---------------------------------------------------------
% Compute vertical skipping step (height downsampling)
% ---------------------------------------------------------
% If the required height is smaller than the original,
% compute a skipping step to reduce rows.
if requiredImageHeight < tempimgHeight
    skipingHeightStep = ceil(tempimgHeight / requiredImageHeight);
else
    skipingHeightStep = 1;     % No downsampling in height
end


% ---------------------------------------------------------
% Compute horizontal skipping step (width downsampling)
% ---------------------------------------------------------
% If the required width is smaller than the original,
% compute a skipping step to reduce columns.
if requiredImageWidth < tempimgWidth
    skipingWidthStep = ceil(tempimgWidth / requiredImageWidth);
else
    skipingWidthStep = 1;      % No downsampling in width
end


% ---------------------------------------------------------
% Resize image using pixel skipping (subsampling)
% ---------------------------------------------------------
% Select pixels at fixed intervals while preserving channels
tempImage = img( ...
    1:skipingHeightStep:tempimgHeight, ...
    1:skipingWidthStep:tempimgWidth, ...
    : ...
);


% ---------------------------------------------------------
% Optional grayscale conversion
% ---------------------------------------------------------
if grayMode == 1
    % Convert RGB image to grayscale
    imgChannel   = 1;
    ResizedImage = rgb2gray(tempImage);
else
    % Keep original color image
    imgChannel   = size(img,3);
    ResizedImage = tempImage;
end


% ---------------------------------------------------------
% Get resized image dimensions
% ---------------------------------------------------------
imgHeight = size(ResizedImage,1);
imgWidth  = size(ResizedImage,2);


% ---------------------------------------------------------
% Display resized image with its dimensions
% ---------------------------------------------------------
figure
imshow(ResizedImage)
title(['Image After resize by ' ...
       int2str(imgHeight) ' x ' ...
       int2str(imgWidth) ' x ' ...
       int2str(imgChannel)])

end
