function R=ori2mat(ori)

if length(ori)==3
    %suppose euler
    R=euler2mat(ori);
else
    %suppose quaternion
    R=squat2cos(ori);
end