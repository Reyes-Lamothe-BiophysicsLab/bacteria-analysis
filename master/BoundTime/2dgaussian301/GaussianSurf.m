%Fit an isotropic Gaussian surface (sigmax == sigmay)
function[res]=GaussianSurf(im)
zac=im;
[xsize,ysize]=size(zac);
[xi,yi] = meshgrid([1:ysize], [1:xsize]);
zi =zac;
clear opts;
opts.iso = true;
res = autoGaussianSurf(xi,yi,zi,opts);
% subplot(1,2,1);imagesc(xi(:),yi(:),zi);
% subplot(1,2,2);imagesc(xi(:),yi(:),res.G);
end