unction [out] = GLCM_Features4(glcmin,pairs)
% Computes 22 GLCM texture features from a Grey Level Co-occurrence Matrix.
% Based on Haralick (1973), Soh & Tsatsoulis (1999), Clausi (2002).
%
% Features computed:
%   Autocorrelation       (out.autoc)
%   Contrast              (out.contr)
%   Correlation matlab    (out.corrm)
%   Correlation [1,2]     (out.corrp)
%   Cluster Prominence    (out.cprom)
%   Cluster Shade         (out.cshad)
%   Dissimilarity         (out.dissi)
%   Energy                (out.energ)
%   Entropy               (out.entro)
%   Homogeneity matlab    (out.homom)
%   Homogeneity [2]       (out.homop)
%   Maximum probability   (out.maxpr)
%   Sum of squares        (out.sosvh)
%   Sum average           (out.savgh)
%   Sum variance          (out.svarh)
%   Sum entropy           (out.senth)
%   Difference variance   (out.dvarh)
%   Difference entropy    (out.denth)
%   Info measure corr 1   (out.inf1h)
%   Info measure corr 2   (out.inf2h)
%   Inv diff normalized   (out.indnc)
%   Inv diff mom norm     (out.idmnc)
%
% Usage:
%   I = imread('image.tif');
%   glcm = graycomatrix(I, 'Offset', [2 0; 0 2]);
%   stats = GLCM_Features4(glcm, 0);
%
% pairs = 1 : combine diagonally opposite GLCM pairs (Haralick symmetric)
% pairs = 0 : use glcm as-is (default)

if ((nargin > 2) || (nargin == 0))
    error('Too many or too few input arguments. Enter GLCM and pairs.');
elseif (nargin == 2)
    if ((size(glcmin,1) <= 1) || (size(glcmin,2) <= 1))
        error('The GLCM should be a 2-D or 3-D matrix.');
    elseif (size(glcmin,1) ~= size(glcmin,2))
        error('Each GLCM should be square with NumLevels rows and NumLevels cols');
    end
elseif (nargin == 1)
    pairs = 0;
    if ((size(glcmin,1) <= 1) || (size(glcmin,2) <= 1))
        error('The GLCM should be a 2-D or 3-D matrix.');
    elseif (size(glcmin,1) ~= size(glcmin,2))
        error('Each GLCM should be square with NumLevels rows and NumLevels cols');
    end
end

format long e

if (pairs == 1)
    newn = 1;
    for nglcm = 1:2:size(glcmin,3)
        glcm(:,:,newn) = glcmin(:,:,nglcm) + glcmin(:,:,nglcm+1);
        newn = newn + 1;
    end
elseif (pairs == 0)
    glcm = glcmin;
end

size_glcm_1 = size(glcm,1);
size_glcm_2 = size(glcm,2);
size_glcm_3 = size(glcm,3);

out.autoc = zeros(1,size_glcm_3);
out.contr = zeros(1,size_glcm_3);
out.corrm = zeros(1,size_glcm_3);
out.corrp = zeros(1,size_glcm_3);
out.cprom = zeros(1,size_glcm_3);
out.cshad = zeros(1,size_glcm_3);
out.dissi = zeros(1,size_glcm_3);
out.energ = zeros(1,size_glcm_3);
out.entro = zeros(1,size_glcm_3);
out.homom = zeros(1,size_glcm_3);
out.homop = zeros(1,size_glcm_3);
out.maxpr = zeros(1,size_glcm_3);
out.sosvh = zeros(1,size_glcm_3);
out.savgh = zeros(1,size_glcm_3);
out.svarh = zeros(1,size_glcm_3);
out.senth = zeros(1,size_glcm_3);
out.dvarh = zeros(1,size_glcm_3);
out.denth = zeros(1,size_glcm_3);
out.inf1h = zeros(1,size_glcm_3);
out.inf2h = zeros(1,size_glcm_3);
out.indnc = zeros(1,size_glcm_3);
out.idmnc = zeros(1,size_glcm_3);

glcm_sum  = zeros(size_glcm_3,1);
glcm_mean = zeros(size_glcm_3,1);
glcm_var  = zeros(size_glcm_3,1);

u_x = zeros(size_glcm_3,1);
u_y = zeros(size_glcm_3,1);
s_x = zeros(size_glcm_3,1);
s_y = zeros(size_glcm_3,1);

p_x       = zeros(size_glcm_1, size_glcm_3);
p_y       = zeros(size_glcm_2, size_glcm_3);
p_xplusy  = zeros((size_glcm_1*2 - 1), size_glcm_3);
p_xminusy = zeros((size_glcm_1), size_glcm_3);

hxy  = zeros(size_glcm_3,1);
hxy1 = zeros(size_glcm_3,1);
hx   = zeros(size_glcm_3,1);
hy   = zeros(size_glcm_3,1);
hxy2 = zeros(size_glcm_3,1);
corm = zeros(size_glcm_3,1);
corp = zeros(size_glcm_3,1);

for k = 1:size_glcm_3
    glcm_sum(k)  = sum(sum(glcm(:,:,k)));
    glcm(:,:,k)  = glcm(:,:,k) ./ glcm_sum(k);
    glcm_mean(k) = mean2(glcm(:,:,k));
    glcm_var(k)  = (std2(glcm(:,:,k)))^2;

    for i = 1:size_glcm_1
        for j = 1:size_glcm_2
            p_x(i,k) = p_x(i,k) + glcm(i,j,k);
            p_y(i,k) = p_y(i,k) + glcm(j,i,k);
            p_xplusy((i+j)-1, k)         = p_xplusy((i+j)-1, k) + glcm(i,j,k);
            p_xminusy((abs(i-j))+1, k)   = p_xminusy((abs(i-j))+1, k) + glcm(i,j,k);
        end
    end
end

i_matrix      = repmat([1:size_glcm_1]', 1, size_glcm_2);
j_matrix      = repmat([1:size_glcm_2],  size_glcm_1, 1);
i_index       = j_matrix(:);
j_index       = i_matrix(:);
xplusy_index  = [1:(2*(size_glcm_1)-1)]';
xminusy_index = [0:(size_glcm_1-1)]';
mul_contr     = abs(i_matrix - j_matrix).^2;
mul_dissi     = abs(i_matrix - j_matrix);

for k = 1:size_glcm_3
    out.contr(k) = sum(sum(mul_contr .* glcm(:,:,k)));
    out.dissi(k) = sum(sum(mul_dissi .* glcm(:,:,k)));
    out.energ(k) = sum(sum(glcm(:,:,k).^2));
    out.entro(k) = -sum(sum(glcm(:,:,k) .* log(glcm(:,:,k) + eps)));
    out.homom(k) = sum(sum(glcm(:,:,k) ./ (1 + mul_dissi)));
    out.homop(k) = sum(sum(glcm(:,:,k) ./ (1 + mul_contr)));
    out.sosvh(k) = sum(sum(glcm(:,:,k) .* ((i_matrix - glcm_mean(k)).^2)));
    out.indnc(k) = sum(sum(glcm(:,:,k) ./ (1 + (mul_dissi ./ size_glcm_1))));
    out.idmnc(k) = sum(sum(glcm(:,:,k) ./ (1 + (mul_contr ./ (size_glcm_1^2)))));
    out.maxpr(k) = max(max(glcm(:,:,k)));

    u_x(k) = sum(sum(i_matrix .* glcm(:,:,k)));
    u_y(k) = sum(sum(j_matrix .* glcm(:,:,k)));
    s_x(k) = (sum(sum(((i_matrix - u_x(k)).^2) .* glcm(:,:,k))))^0.5;
    s_y(k) = (sum(sum(((j_matrix - u_y(k)).^2) .* glcm(:,:,k))))^0.5;

    corp(k) = sum(sum(i_matrix .* j_matrix .* glcm(:,:,k)));
    corm(k) = sum(sum((i_matrix - u_x(k)) .* (j_matrix - u_y(k)) .* glcm(:,:,k)));

    out.autoc(k) = corp(k);
    out.corrp(k) = (corp(k) - u_x(k)*u_y(k)) / (s_x(k)*s_y(k));
    out.corrm(k) = corm(k) / (s_x(k)*s_y(k));

    out.cprom(k) = sum(sum(((i_matrix + j_matrix - u_x(k) - u_y(k)).^4) .* glcm(:,:,k)));
    out.cshad(k) = sum(sum(((i_matrix + j_matrix - u_x(k) - u_y(k)).^3) .* glcm(:,:,k)));

    out.savgh(k) = sum((xplusy_index + 1) .* p_xplusy(:,k));
    out.senth(k) = -sum(p_xplusy(:,k) .* log(p_xplusy(:,k) + eps));
    out.svarh(k) = sum(((xplusy_index + 1) - out.senth(k)).^2 .* p_xplusy(:,k));

    out.denth(k) = -sum(p_xminusy(:,k) .* log(p_xminusy(:,k) + eps));
    out.dvarh(k) = sum((xminusy_index.^2) .* p_xminusy(:,k));

    hxy(k)  = out.entro(k);
    glcmk   = glcm(:,:,k)';
    glcmkv  = glcmk(:);

    hxy1(k) = -sum(glcmkv .* log(p_x(i_index,k) .* p_y(j_index,k) + eps));
    hxy2(k) = -sum(p_x(i_index,k) .* p_y(j_index,k) .* log(p_x(i_index,k) .* p_y(j_index,k) + eps));
    hx(k)   = -sum(p_x(:,k) .* log(p_x(:,k) + eps));
    hy(k)   = -sum(p_y(:,k) .* log(p_y(:,k) + eps));

    out.inf1h(k) = (hxy(k) - hxy1(k)) / (max([hx(k), hy(k)]));
    out.inf2h(k) = (1 - exp(-2*(hxy2(k) - hxy(k))))^0.5;
end

end
