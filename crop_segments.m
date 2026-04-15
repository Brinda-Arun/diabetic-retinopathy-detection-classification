clc;
clear all;
close all;

image_folder = 'path/to/your/grayscale/images';
filenames = dir(fullfile(image_folder, '*.jpg'));
total_images = numel(filenames);

for n = 1:total_images
    f = fullfile(image_folder, filenames(n).name);
    im = imread(f);

    imcrp1 = imcrop(im, [367 232 1410 1003]);
    path1 = strcat('path/to/output/upper/', filenames(n).name);
    imwrite(imcrp1, path1);

    imcrp2 = imcrop(im, [331 767 1410 1003]);
    path2 = strcat('path/to/output/middle/', filenames(n).name);
    imwrite(imcrp2, path2);

    imcrp3 = imcrop(im, [487 445 1410 1003]);
    path3 = strcat('path/to/output/lower/', filenames(n).name);
    imwrite(imcrp3, path3);
end

display('done')
