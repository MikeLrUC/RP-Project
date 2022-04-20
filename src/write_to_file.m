function write_to_file(y, ypred, filename)
    fid = fopen(filename,'w');
    
    fprintf(fid, "y,ypred\n"); % comentar se nao se quiser a label das colunas
    for i = 1: size(y, 2)
        fprintf(fid, "%d,%d\n", y(1, i), ypred(1, i));
    end
    fclose(fid);
end