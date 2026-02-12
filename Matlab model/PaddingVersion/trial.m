%%
% clc;
clear all;

for i = 1 : 6^2
    buffer_matrix = conv_buffer(i,6,20,3);
end
%%
clear          % Clear workspace variables
clc            % Clear command window
close all      % Close all open figures

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp("The used kernel is ")
parametersOfRun   % Load run parameters (kernel, image path, sizes, etc.)

% ---------------------------------------------------------
% Read image, resize it, and optionally convert to grayscale
% ---------------------------------------------------------
for i= [2 6 10 14]
[image, imgHeight, imgWidth, imgChannel] = ...
    resize_image(imgPath, requiredImageWidth, requiredImageHeight, grayMode);

% ---------------------------------------------------------
% Add zero padding at the TOP of the image (2 rows)
% This is needed to allow generation of the first 3x3 window
% ---------------------------------------------------------
  kernel= kernel_bank(:,:,i)  ;
imageAfterPadding = [ ...
    uint8(zeros(2, imgWidth, imgChannel)); ...
    image ...
];

% ---------------------------------------------------------
% Convolution process (pixel streaming style)
% ---------------------------------------------------------
% Loop over:
%   - channels
%   - image height (including padded rows)
%   - image width
%
% Each loop iteration feeds ONE pixel into the convolution buffer
for ittrChannel = 1:imgChannel
    for ittrHeight = 1:imgHeight + 2
        for ittrWidth = 1:imgWidth

            % Feed one pixel to the line buffer
            buffer_matrix = conv_buffer( ...
                imageAfterPadding(ittrHeight, ittrWidth, ittrChannel), ...
                imgWidth, bufferWidth, noOfColumn ...
            );

            % Perform convolution only when a full 3x3 window is available
            if ittrHeight > 2 && ittrWidth > 2
                convImage(ittrHeight-2, ittrWidth, ittrChannel) = ...
                    conv_matrix(kernel, buffer_matrix);
            end
        end
    end
end

% ---------------------------------------------------------
% Display final convolution output image
% ---------------------------------------------------------
figure
imshow(convImage)
title("Image after convolution")
end 