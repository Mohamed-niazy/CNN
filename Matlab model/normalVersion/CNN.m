%%
clear          % Clear workspace variables
clc            % Clear command window
close all      % Close all open figures

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('..');
disp("The used kernel is ")
parametersOfRun   % Load run parameters (kernel, image path, sizes, etc.)

% ---------------------------------------------------------
% Read image, resize it, and optionally convert to grayscale
% ---------------------------------------------------------
[imageAfterResizing, imgHeight, imgWidth, imgChannel] = ...
    resize_image(imgPath, requiredImageWidth, requiredImageHeight, grayMode);

% ---------------------------------------------------------
% Add zero padding at the TOP of the image (2 rows)
% This is needed to allow generation of the first 3x3 window
% ---------------------------------------------------------


GenerateImageDataForRtl(imageAfterResizing,imgChannel,imgHeight,imgWidth,TxtPath,'NormalVersionIn');
% ---------------------------------------------------------
% Convolution process (pixel streaming style)
% ---------------------------------------------------------
% Loop over:
%   - channels
%   - image height (including padded rows)
%   - image width
%
% Each loop iteration feeds ONE pixel into the convolution buffer

fid=fopen("../../TxtFiles\NormalVersionGR_matrix.txt","w");
for ittrChannel = 1:imgChannel
    for ittrHeight = 1:imgHeight
        for ittrWidth = 1:imgWidth
            % Feed one pixel to the line buffer
            buffer_matrix = conv_buffer( ...
                imageAfterResizing(ittrHeight, ittrWidth, ittrChannel), ...
                imgWidth, bufferWidth, noOfColumn ...
            );

            % Perform convolution only when a full 3x3 window is available
            if ittrHeight > 2 && ittrWidth > 2
                newIttrWidth=ittrWidth-2;
                newIttrHeight=ittrHeight-2;
                dumpMatrix(fid ,buffer_matrix,newIttrHeight, newIttrWidth, ittrChannel  );
                convImage(newIttrHeight, newIttrWidth, ittrChannel) = ...
                    conv_matrix(kernel, buffer_matrix);
            end
        end
    end
end
GenerateFilterResultForRtl(convImage,imgChannel,imgHeight-2,imgWidth-2,TxtPath,'NormalVersionGR');
fclose(fid);
% ---------------------------------------------------------
% Display final convolution output image
% ---------------------------------------------------------
figure
imshow(convImage)
title("Image after convolution")