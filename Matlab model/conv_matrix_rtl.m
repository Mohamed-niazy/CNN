function point=conv_matrix_rtl(kernel_val,img_matrix,noOfRow,noOfColumn)
point = 0;
for ittr_row = 1:noOfRow
    for ittr_col=1:noOfColumn
point = point + kernel_val(ittr_row,ittr_col)*img_matrix(ittr_row,ittr_col);
    end
end
