function dumpMatrix(fid ,mat,idRow,idCol,idCh  )

fprintf(fid,"************************************\n");
fprintf(fid,"%3d %3d %3d\n\n",idRow,idCol,idCh);
fprintf(fid,"%3d %3d %3d\n",mat(1,1),mat(1,2),mat(1,3));
fprintf(fid,"%3d %3d %3d\n",mat(2,1),mat(2,2),mat(2,3));
fprintf(fid,"%3d %3d %3d\n",mat(3,1),mat(3,2),mat(3,3));




