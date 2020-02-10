function mid_filt = median(im)

% Median Filtering using MATLAB function
[r c] = size(im);
mid_filt = medfilt2(im,[3 3]);
figure, imshow(mid_filt);
mid_filt = mid_filt(2:r-1,2:c-1);
figure, imshow(mid_filt);
end

