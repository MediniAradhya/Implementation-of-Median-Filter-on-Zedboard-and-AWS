im = imread('lena.png');
figure, imshow(im);

im_gray = rgb2gray(im);
figure, imshow(im_gray);

im_gray = imresize(im_gray,[128 128]);
figure, imshow(im_gray);

[r c] = size(im_gray);

%padded = padarray(im_resize,[1 1], 0, 'both');
%figure, imshow(padded);

% adding noise (optional)
%im_noise = imnoise(im_resize,'salt & pepper');
%figure, imshow(im_noise);

% Median Filtering MATLAB code
mid_filt = median(im_gray);

% image to text file creation (file saved in sw_in.txt)
path = '//Users//anushkasw//OneDrive - University of Florida//Anushka//RC//Project//Dataset//final results//lena128.txt';
im2txt(im_gray, path);

% image to text file creation (file saved in sw_in.txt)
path = '//Users//anushkasw//OneDrive - University of Florida//Anushka//RC//Project//Dataset//final results//lenahw.txt';
hw_out = txt2im(r,c,path);

% Checking if Hardware and MATLAB results are same
im_compare(mid_filt, hw_out);

