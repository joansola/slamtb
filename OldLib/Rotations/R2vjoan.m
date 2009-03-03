function v = R2v(R)

% R2V Rotation matrix to rotation vector conversion (inverse rodrigues
% formula)

SQ = (R-R')/2;

su = [SQ(3,2) SQ(1,3) SQ(2,1)]'; % sinus times norm. vector
s2 = su'*su; % squared sinus of rotation angle

s = whos('R');

if strcmp(s.class,'sym') || s2 > 1e-8
    sina = sqrt(s2);
    a = asin(sina);

    v = a*su/sina;
else
    v = zeros(3,1);
end



