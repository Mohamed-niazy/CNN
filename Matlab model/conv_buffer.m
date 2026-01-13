function buffer_matrix = conv_buffer(img_pixel, img_width, bufferWidth, noOfColumn)
% ---------------------------------------------------------
% Function: conv_buffer
%
% Description:
%   Implements a streaming convolution buffer that generates
%   a 3x3 sliding window from serial image pixel input.
%
%   This function mimics a hardware line-buffer architecture
%   commonly used in CNN accelerators.
%
%   On each input pixel, the function updates internal buffers
%   and outputs a 3x3 matrix suitable for convolution.
%
% Inputs:
%   img_pixel   - Incoming pixel value (1 pixel per call)
%   img_width   - Image width (number of columns per row)
%   bufferWidth - Width of line memory (usually equals img_width)
%   noOfColumn  - Number of columns in the convolution window (3)
%
% Output:
%   buffer_matrix - 3x3 matrix representing the current
%                   convolution window
%
% Notes:
%   - Uses persistent variables to emulate hardware registers
%     and line memories.
%   - Supports pixel-by-pixel streaming.
%   - Boundary conditions are handled by zero padding.
% ---------------------------------------------------------



% Line buffers and shift registers (stored between calls)
persistent buff_1 buff_2 buff_3   % 3 pixels per row (window)
persistent mem_1 mem_2            % Line buffers (previous rows)
persistent cnt_col cnt_row        % Column and row counters


% ---------------------------------------------------------
% Initialize buffers only once
% ---------------------------------------------------------
if isempty(buff_1)
    buff_1  = zeros(1, noOfColumn);   % Row (r-2)
    buff_2  = zeros(1, noOfColumn);   % Row (r-1)
    buff_3  = zeros(1, noOfColumn);   % Row (r)
    mem_1   = zeros(1, bufferWidth); % Store previous row
    mem_2   = zeros(1, bufferWidth); % Store row before previous
    cnt_col = 1;
    cnt_row = 1;
end


% ---------------------------------------------------------
% Read old pixels from line buffers
% ---------------------------------------------------------
temp_1 = mem_1(cnt_col);   % Pixel from previous row
temp_2 = mem_2(cnt_col);   % Pixel from two rows above


% ---------------------------------------------------------
% Write current pixel into line buffers
% ---------------------------------------------------------
mem_1(cnt_col) = img_pixel;  % Save current pixel
mem_2(cnt_col) = temp_1;     % Shift older row upward


% ---------------------------------------------------------
% Shift pixels horizontally to form 3x3 window
% ---------------------------------------------------------
buff_3 = [buff_3(2:3) img_pixel]; % Current row
buff_2 = [buff_2(2:3) temp_1];    % Previous row
buff_1 = [buff_1(2:3) temp_2];    % Two rows above


% ---------------------------------------------------------
% Output the 3x3 convolution window
% Apply zero padding at image boundaries
% ---------------------------------------------------------
if cnt_row > 3
    if cnt_col == 1
        % Left edge padding
        buffer_matrix = [ ...
            [buff_1(1:2) 0]; ...
            [buff_2(2:3) 0]; ...
            [buff_3(2:3) 0] ];
    elseif cnt_col == 2
        % Second column padding
        buffer_matrix = [ ...
            [buff_1(1) 0 0]; ...
            [buff_2(3) 0 0]; ...
            [buff_3(3) 0 0] ];
    else
        % Fully valid window
        buffer_matrix = [buff_1; buff_2; buff_3];
    end
else
    % Top edge padding (first rows)
    buffer_matrix = [buff_1; buff_2; buff_3];
end


% ---------------------------------------------------------
% Update pixel position counters
% ---------------------------------------------------------
if cnt_col == img_width
    cnt_col = 1;           % Reset the column counter
    cnt_row = cnt_row + 1; % Move to next row
else
    cnt_col = cnt_col + 1; % Move to next column
end

end
