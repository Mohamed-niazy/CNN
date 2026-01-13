clc;
clear all;

for i = 1 : 6^2
    buffer_matrix = conv_buffer(i,6,20,3);
end