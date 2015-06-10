
clear all
clc
%----------------------------------------
[namefile,pathname]=uigetfile({'*.bmp;*.tif;*.tiff;*.jpg;*.jpeg;*.gif','IMAGE Files (*.bmp,*.tif,*.tiff,*.jpg,*.jpeg,*.gif)'},'Chose GrayScale Image');
I=imread(strcat(pathname,namefile));
P = I;
%--------------------------------------------------------------------------

input_image1=imread([pathname namefile]);
F=input_image1;
imshow(F);
title('original image');
[u v w]=size(F);
if w==3
  F=rgb2gray(F);
end

% imagesc(F);
% drawnow;
hold on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%display input image
%add noise
input_image=imnoise(input_image1,'speckle',.01);% noise level by .01
%give the number of decomposition level which must be integer and should not exceed 3

n = 3; 
%*****************************************************************************
[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters('haar');

axis image; set(gca,'XTick',[],'YTick',[]); title('Original')
% We will use the 9/7 filters with symmetric extension at the
% boundaries.
wname = 'bior4.4';
warning off
% Compute a 2-level decomposition of the image using the 9/7 filters.
[wc,s] = wavedec2(F,2,wname);

% Extract the level 1 coefficients.
a1 = appcoef2(wc,s,wname,1);         
h1 = detcoef2('h',wc,s,1);           
v1 = detcoef2('v',wc,s,1);           
d1 = detcoef2('d',wc,s,1);           

% Extract the level 2 coefficients.
a2 = appcoef2(wc,s,wname,2);
h2 = detcoef2('h',wc,s,2);
v2 = detcoef2('v',wc,s,2);
d2 = detcoef2('d',wc,s,2);

% Display the decomposition up to level 1 only.
%ncolors = size(map,1);              % Number of colors.
ncolors=55;  % change value as per required brightness
sz = size(F);
cod_a1 = wcodemat(a1,ncolors); cod_a1 = wkeep(cod_a1, sz/2);
cod_h1 = wcodemat(h1,ncolors); cod_h1 = wkeep(cod_h1, sz/2);
cod_v1 = wcodemat(v1,ncolors); cod_v1 = wkeep(cod_v1, sz/2);
cod_d1 = wcodemat(d1,ncolors); cod_d1 = wkeep(cod_d1, sz/2);
figure,image([cod_a1,cod_h1;cod_v1,cod_d1]);
axis image; set(gca,'XTick',[],'YTick',[]); title('Single stage decomposition')
C = cod_a1;
C = I;
%--------------------------------------------------------------------------
cod_a1 = uint8(cod_a1);
imwrite(cod_a1,'test.bmp');
k=imfinfo('test.bmp');
ib=k.Width*k.Height*k.BitDepth/8;
cb=k.FileSize;
compression_ratio=ib/cb
%----------------------------------------
a = size(I);
s1 = a(1);
s2 = a(2);
%-------------------------------------------------------------------------
[namefile,pathname]=uigetfile({'*.bmp;*.tif;*.tiff;*.jpg;*.jpeg;*.gif','IMAGE Files (*.bmp,*.tif,*.tiff,*.jpg,*.jpeg,*.gif)'},'Chose GrayScale Image');
F15=imread(strcat(pathname,namefile));
% figure,imshow(F15);
F15 = imresize(F15,[s1 s2]);
n = 4; % Number of bits to replace 1 <= n <= 7

[Stego, Extracted] = LSBHide(I, F15, n);

figure, imshow(Stego);
title('Stegno Image');
figure, imshow(Extracted)
title('extracted image');

% x = snr(Stego)
%--------------------------------------------------------------------------
% Reverse process
[N M] = size(Stego);
   ima=max(Stego(:));
   ima = double(ima);
   imi=min(Stego(:));
   imi=double(imi);
   ims=std(Stego(:));
   
   snr=20*log10((ima-imi)./ims)
   MSE = sqrt((sum(sum((double(Stego)).^2)))/(N*M));
   PSNR = 10*log10(255^2/MSE);
   sprintf('The PSNR is: %5.2fdB.',PSNR(1))
   disp('          ');
   sprintf('The MSE is: %5.2fdB.',MSE(1))



reverse_pro = Stego;
Stego_rev = uint8(bitor(bitand(reverse_pro, bitcmp(2^n - 1, 8)) , bitshift(I, n - 8)));
Extracted_rev = uint8(bitand(255, bitshift(Stego_rev, 8 - n)));

figure,imshow(Stego_rev);
title('original extracted image')
figure,imshow(Extracted_rev);
title('hided image')

