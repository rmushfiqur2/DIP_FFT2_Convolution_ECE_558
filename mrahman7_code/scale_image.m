function scaled_image = scale_image(im_gray)
    r = double(im_gray);
    m = min(r(:));
    M = max(r(:));
    scaled_image = (r-m)/(M-m); % format double
end