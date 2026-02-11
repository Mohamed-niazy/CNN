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
[image, imgHeight, imgWidth, imgChannel] = ...
    resize_image(imgPath, requiredImageWidth, requiredImageHeight, grayMode);

% ---------------------------------------------------------
% Add zero padding at the TOP of the image (2 rows)
% This is needed to allow generation of the first 3x3 window
% ---------------------------------------------------------
imageAfterPadding = [ ...
    uint8(zeros(2, imgWidth, imgChannel)); ...
    image ...
];

GenerateImageDataForRtl(imageAfterPadding,imgChannel,imgHeight+2,imgWidth,TxtPath,'PaddingVersionIn');
% ---------------------------------------------------------
% Convolution process (pixel streaming style)
% ---------------------------------------------------------
% Loop over:
%   - channels
%   - image height (including padded rows)
%   - image width
%
% Each loop iteration feeds ONE pixel into the convolution buffer

fid=fopen("../../TxtFiles\PaddingVersionGR_matrix.txt","w");
for ittrChannel = 1:imgChannel
    flag=0;
    for ittrHeight = 1:imgHeight + 2
        for ittrWidth = 1:imgWidth
if ittrWidth==1
x=1;
end 
            % Feed one pixel to the line buffer
            buffer_matrix = conv_buffer( ...
                imageAfterPadding(ittrHeight, ittrWidth, ittrChannel), ...
                imgWidth, bufferWidth, noOfColumn ...
            );

            % Perform convolution only when a full 3x3 window is available
            if  ittrHeight > 2 && ittrWidth > 2
                flag=1;
            end
            if flag
                if(ittrWidth==1)
                    newIttrWidth=imgWidth-1;
                    newIttrHeight=ittrHeight-3;
                elseif(ittrWidth==2)
                    newIttrWidth=imgWidth;
                    newIttrHeight=ittrHeight-3;
                else
                    newIttrWidth=ittrWidth-2;
                    newIttrHeight=ittrHeight-2;
                end
dumpMatrix(fid ,buffer_matrix,newIttrHeight, newIttrWidth, ittrChannel  );
                convImage(newIttrHeight, newIttrWidth, ittrChannel) = ...
                    conv_matrix(kernel, buffer_matrix);
                % if(convImage(ittrHeight-2, ittrWidth, ittrChannel)==167)
                %     x=1;
                % end
                % conv_matrix(kernel, buffer_matrix)
            end
        end
    end
end
GenerateFilterResultForRtl(convImage,imgChannel,imgHeight,imgWidth,TxtPath,'PaddingVersionGR');
fclose(fid);
% ---------------------------------------------------------
% Display final convolution output image
% ---------------------------------------------------------
figure
imshow(convImage)
title("Image after convolution")