function hw_out = txt2im(r, c, path)
%% text file to image convesrion
fileID = fopen(path, 'r');
A = fscanf(fileID, '%d');

hw_out=reshape(A,[r,c]);
imshow(hw_out, [0 255]);

hw_out = hw_out(1:r-2,1:c-2);
figure, imshow(hw_out, [0 255]);
end

