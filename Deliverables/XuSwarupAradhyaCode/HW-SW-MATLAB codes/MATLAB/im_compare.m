function im_compare(mid_filt,hw_out)
% Compares MATLAB and Hardware output to check whether they are same
[r c] = size(mid_filt);
for i = 1:r
    for j = 1:c
        
        fprintf('SW: %d ; HW: %d\n',mid_filt(i,j), hw_out(i,j));
    end
end

if(mid_filt == hw_out)
    disp('Images have the same pixel values')
end
end

