function im_out = rgb2gray(image)

% RGB2GRAY Convert image to gray level image
%   IM_OUT = RGB2GRAY(IM) converts RGB image IM to a gray value image by
%   removing tone and saturation components. The input image is RxCxD; the
%   output image is then RxC.
%

if size(image,3) ~= 1
    im_out = sum(image,3)/3;
else
    im_out = image;
end
