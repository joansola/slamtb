function out_im = imresize2(im,H)

% IMRESIZE2 Image resize, no Image Processing Toolbox needed
%   IO = IMRESIZE2(I,R) resizes image I by zoom factor R and writes the
%   resulting image in IO. It uses linear interpolation to generate the
%   output pixels.
%
%   IO = IMRESIZE2(I,H) accepts an affine martix H for the mapping.
%
%   NOTE1: at this time, the final size of IO is the same of I. This means
%   that the image I is cropped. If you want a true resizing with this
%   function as-is, extend the size of I with zeros on all 4 borders to the
%   size required by IO.
%
%   NOTE2: at this time, only zomming in is supported. If R<1 the output
%   image will be the same as the input one.

%   (c) Joan Sola 2008

if numel(H) == 1

    r = H;

    if r <= 1
        out_im = im;
    else

        ir = 1/r; % inverse of zoom factor

        sv = size(im,1); % image size
        su = size(im,2);

        v0 = sv/2; % center of input and output images
        u0 = su/2;

        out_im = zeros(size(im)); % output image, same size as input

        for V = 1:sv
            for U = 1:su % [V;U] destination pixel
                v = v0 + (V-v0)*ir; % [v;u] origin pixel
                u = u0 + (U-u0)*ir;

                vul = floor(v); % [vul;uul] Upper left origin pixel
                uul = floor(u);

                vur = vul;      % upper right
                uur = uul + 1;

                vll = vul + 1;  % lower left
                ull = uul;

                vlr = vul + 1;  % lower right
                ulr = uul + 1;

                dv = v - vul;   % pixel fraction
                du = u - uul;

                out_im(V,U) = (... % linear interpolation of pixel luminance
                    (1-dv)*(1-du)*im(vul,uul) + ...
                    (1-dv)*du*im(vur,uur) + ...
                    dv*(1-du)*im(vll,ull) + ...
                    dv*du*im(vlr,ulr));

            end
        end
    end

elseif numel(H) == 4

    sv = size(im,1); % image size
    su = size(im,2);

    v0 = sv/2; % center of input and output images
    u0 = su/2;

    U0 = [u0;v0];

    G = H^-1;


    out_im = zeros(size(im)); % output image, same size as input


    for V = 1:sv
        for U = 1:su % [V;U] destination pixel

            Ui = U0 + G*([U;V]-U0); % input pixel

            u = Ui(1);
            v = Ui(2);

            % restrict to patch values
            u = min(u,su-1); u = max(1,u);
            v = min(v,sv-1); v = max(1,v);

            vul = floor(v); % [vul;uul] Upper left origin pixel
            uul = floor(u);

            vur = vul;      % upper right
            uur = uul + 1; %if uur>su,uur=su;end

            vll = vul + 1; %if vll>sv,vll=sv;end % lower left
            ull = uul;

            vlr = vul + 1; %if vlr>sv,vlr=sv;end % lower right
            ulr = uul + 1; %if ulr>su,ulr=su;end

            dv = v - vul;   % pixel fraction
            du = u - uul;

            out_im(V,U) = (... % linear interpolation of pixel luminance
                (1-dv)*(1-du)*im(vul,uul) + ...
                (1-dv)*du*im(vur,uur) + ...
                dv*(1-du)*im(vll,ull) + ...
                dv*du*im(vlr,ulr));

        end
    end

else

    error('Input warping parameter H must be either scalar or 2x2 matrix')

end

return

%% tests

% first run some IDP slam program to get variable Lmk initializad.

a = deg2rad(4);
r = 1.2;
H = [cos(a) -sin(a);sin(a) cos(a)]'*r;
I = Lmk.Idp(1).sig.I;
J = imresize2(I,H);
figure(98);image(I);colormap(gray(255));axis image
figure(99);image(J);colormap(gray(255));axis image



% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

