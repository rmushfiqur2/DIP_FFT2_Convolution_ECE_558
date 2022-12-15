clc; clear; close all;

%% read
im1 = imread("lena.png");
im2 = imread("wolves.png");

im3 = rgb2gray(im1);
im4 = rgb2gray(im2);

scaled_img = scale_image(im3);

figure()
imshow(scaled_img)
colorbar()

%% my function
F = my_fft2(scaled_img);
% fft (magnitude)
figure()
imagesc(log(1+abs(fftshift(F))))
colorbar();
% fft (phase)
figure()
imagesc(angle(fftshift(F)))
colorbar();

% inverse fft
I = my_ifft2(F);
figure()
% recovered image
imshow(abs(I));
colorbar();

% distance from original
figure()
imshow(abs(real(I)-scaled_img))
colorbar();

%% reference (using built in fft2 and ifft2)
F = fft2(scaled_img);
figure()
imagesc(log(1+abs(fftshift(F))))
colorbar();

figure()
imagesc(angle(fftshift(F)))
colorbar();

I = ifft2(F);
figure()
imshow(real(I));