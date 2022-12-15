function im_rgb = scale_rgb(im_rgb)
    im_rgb(:,:,1) =  scale_image(im_rgb(:,:,1));
    im_rgb(:,:,2) =  scale_image(im_rgb(:,:,2));
    im_rgb(:,:,3) =  scale_image(im_rgb(:,:,3));
end