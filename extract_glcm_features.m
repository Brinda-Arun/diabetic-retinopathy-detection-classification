clc;
clear all;

image_folder = 'path/to/your/cropped/images';
filenames = dir(fullfile(image_folder, '*.jpg'));
total_images = numel(filenames);

for n = 1:total_images
    f = fullfile(image_folder, filenames(n).name);
    im = imread(f);

    glcm = graycomatrix(im);
    [GLCM] = GLCM_Features4(glcm);
    cll = struct2cell(GLCM);
    mtrx = cell2mat(cll);
    a(:, n) = mtrx;
end

xlswrite('features_output', a, 1);
display('done')
