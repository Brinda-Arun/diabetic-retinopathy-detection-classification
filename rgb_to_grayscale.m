clc;
clear all;
close all;

image_folder = 'path/to/your/flipped/images';
filenames = dir(fullfile(image_folder, '*.jpg'));
total_images = numel(filenames);

for n = 1:total_images
    f = fullfile(image_folder, filenames(n).name);
    im = imread(f);
    imm = rgb2gray(im);
    path = strcat('path/to/output/grayscale/', filenames(n).name);
    imwrite(imm, path);
end

display('done')
