function GenerateImageDataForRtl(img,imgChannel,imgHeight,imgWidth,TxtPath,fileName)
f_handle=fopen(fullfile(TxtPath, [fileName, '.txt']),'w');

           fprintf(f_handle,'%d\n',imgHeight);
           fprintf(f_handle,'%d\n',imgWidth);
           fprintf(f_handle,'%d\n',imgChannel);

for ittrChannel = 1:imgChannel
    for ittrHeight = 1:imgHeight
        for ittrWidth = 1:imgWidth
           fprintf(f_handle,'%d\n',img(ittrHeight,ittrWidth,ittrChannel));
        end
    end
end

fclose(f_handle);
