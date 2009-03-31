function s = satColor(c)

% SATCOLOR  Saturate color.
%   SATCOLOR(C) returns a color specification which corresponds to the
%   saturated version of input color C. 
%
%   For CHAR colors, C(1) in 'rgbcmybw', the output is unchanged as all
%   Matlab colors specified by CHAR are already saturated. Only the first
%   character of C is evaluated.
%
%   For vector colors C = [R G B], saturation is achieved by bringing the
%   minimum component to zero and the maximum to one. If all components are
%   equal (C is gray-level) the output is [0 0 0] (black) or [1 1 1]
%   (white) depending on the gray level MEAN(C) being greater than 0.5 or
%   not.

%   (c) 2009 Joan Sola @ LAAS-CNRS.

if isnumeric(c)

    if (numel(c) == 3)  % color is a 3-vector

        if all(c==max(c))  % color is gray. bring to black or white
            s = ones(size(c))*(max(c)>.5);

        else % color is not gray. Saturate.
            cz = c - min(c);   % bring to zero
            s  = cz / max(cz); % stretch to one

        end
    else

        error('??? Invalid color specification.')

    end

elseif ischar(c)

    c = c(1); % take first letter

    if any(c == 'rgbcmybw') % valid colors. See DOC COLORSPEC.

        s = c;              % valid char colors are already saturated.

    else

        error('??? Invalid color specification.')

    end

end
