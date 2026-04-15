clc;
clear all;

image_folder = 'path/to/your/images/to/flip';
filenames = dir(fullfile(image_folder, '*.jpg'));
total_images = numel(filenames);

for n = 1:total_images
    f = fullfile(image_folder, filenames(n).name);
    im = imread(f);
    imflp = flip(im, 2);
    path = strcat('path/to/output/flipped/', filenames(n).name);
    imwrite(imflp, path);
end

display('done')
