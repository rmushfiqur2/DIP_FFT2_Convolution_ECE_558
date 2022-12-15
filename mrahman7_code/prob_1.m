clc;
clear;
close all;

%% testing the padding types (1a)
kernel = ones(40,40)/1600; % big kernel (40X40) so that the paddings are visible
 
% grayscale image
im_gray = rgb2gray(imread("lena.png"));
test_all_paddings(im_gray, kernel, "gray");
% rgb image
im_rgb = imread("wolves.png");
test_all_paddings(im_rgb, kernel, "rgb");

%% testing the kernels (1a)
% only clip (zero-padding) will be used for this section

w_box = [1,1,1; 1,1,1; 1,1,1]/9;
w_derx = [-1, 1];
w_dery = [-1; 1];
w_prewittx = [-1,0,1;-1,0,1;-1,0,1];
w_prewitty = flip(w_prewittx');
w_sobelx = [-1,0,1; -2,0,2; -1,0,1];
w_sobely = flip(w_sobelx');
w_robertsx = [0,1; -1,0];
w_robertsy = flip(w_robertsx');

test_kernel(im_gray, w_box, "box filter", "gray")
test_kernel(im_gray, w_derx, "der x", "gray")
test_kernel(im_gray, w_dery, "der y", "gray")
test_kernel(im_gray, w_prewittx, "prewitt x", "gray")
test_kernel(im_gray, w_prewitty, "prewitt y", "gray")
test_kernel(im_gray, w_sobelx, "sobel x", "gray")
test_kernel(im_gray, w_sobely, "sobel y", "gray")
test_kernel(im_gray, w_robertsx, "roberts x", "gray")
test_kernel(im_gray, w_robertsy, "roberts y", "gray")

test_kernel(im_rgb, w_box, "box filter", "rgb")
test_kernel(im_rgb, w_derx, "der x", "rgb")
test_kernel(im_rgb, w_dery, "der y", "rgb")
test_kernel(im_rgb, w_prewittx, "prewitt x", "rgb")
test_kernel(im_rgb, w_prewitty, "prewitt y", "rgb")
test_kernel(im_rgb, w_sobelx, "sobel x", "rgb")
test_kernel(im_rgb, w_sobely, "sobel y", "rgb")
test_kernel(im_rgb, w_robertsx, "roberts x", "rgb")
test_kernel(im_rgb, w_robertsy, "roberts y", "rgb")

%% impulse image (1b)
impulse_im = uint8(zeros(1024,1024));
impulse_im(512,512) = 255;

figure()
imshow(impulse_im)
title('impulse image')
imwrite(impulse_im, "output/prob_1/impulse_image.png")

[padded_f, res] = my_conv2(impulse_im, w_sobely, "clip", "same");
fgr = figure();
imagesc(res)
colormap('jet'); colorbar;
grid on;
title('convolution result')
saveas(fgr, "output/prob_1/impulse_image_convolution.png")

% crop the middle 24X24 image for visibility
fgr = figure();
imagesc(res(501:524, 501:524))
colormap('jet'); colorbar;
grid on;
title('convolution result')
saveas(fgr, "output/prob_1/impulse_image_convolution_cropped.png")

%% functions
function test_all_paddings(img, kernel, img_type)
    pads = ["clip", "wrap-around", "copy-edge", "reflect-edge"];
    for i=1:length(pads)
        [padded_f, res] = my_conv2(img, kernel, pads(i), "same");
        fgr = figure();
        subplot(1,2,1)
        imshow(uint8(padded_f))
        title(pads(i) + " padded image")
        imwrite(uint8(padded_f), "output/prob_1/"+"padding_"+pads(i)+"_"+img_type+"_padded_img.png")
        subplot(1,2,2)
        imshow(uint8(res))
        title("conv2 (40 X 40 box filter)")
        imwrite(uint8(res), "output/prob_1/"+"padding_"+pads(i)+"_"+img_type+"_conv2_result.png")
        saveas(fgr, "output/prob_1/padding_"+pads(i)+"_"+img_type+".png")
    
        sgtitle(pads(i)+" box filter")
    end
end

function test_kernel(img, kernel,kernel_name, img_type)
    [padded_f, res] = my_conv2(img, kernel, "clip", "same");
    fgr = figure();
    subplot(2,2,1)
    if img_type=="gray"
        colormap("gray");
    end
    imshow(img)
    title("original image")
    ax = subplot(2,2,2);
    imagesc(kernel)
    cmap = [0.7 0 0
            0.7 0.3 0.3
            1 1 1
            0.3 0.3 0.7
            0 0 0.7];
    title(kernel_name); colormap(ax, cmap); colorbar();
    subplot(2,2,3)
    imshow(uint8(padded_f))
    title("zero padded image")
    subplot(2,2,4);
    
    if img_type=="gray"
        %imagesc(res)
        disp_img = scale_image(res);
        colorbar();
    else
        disp_img = scale_rgb(res);
    end
    imshow(disp_img)
    title("convolution result");
    imwrite(disp_img, "output/prob_1/"+"kernel_conv_result_"+kernel_name+"_"+img_type+".png")
    
    sgtitle("Convolution with " + kernel_name)
    
    saveas(fgr, "output/prob_1/kernel_"+kernel_name+"_"+img_type+".png")
end

