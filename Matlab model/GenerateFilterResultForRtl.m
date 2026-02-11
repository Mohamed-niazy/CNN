function GenerateFilterResultForRtl(img,imgChannel,imgHeight,imgWidth,TxtPath,fileName)
f_handle=fopen(fullfile(TxtPath, [fileName, '.txt']),'w');

for ittrChannel = 1:imgChannel
    for ittrHeight = 1:imgHeight
        for ittrWidth = 1:imgWidth
           fprintf(f_handle,'%d %d %d %d\n',img(ittrHeight,ittrWidth,ittrChannel),ittrHeight,ittrWidth,ittrChannel);
        end
    end
end

fclose(f_handle);
