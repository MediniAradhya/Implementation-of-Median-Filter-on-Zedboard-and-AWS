function im2txt(im, path)
% image to text file creation
fileID = fopen(path, 'w');
fprintf(fileID, '%d\n', im);
fclose(fileID);
end

