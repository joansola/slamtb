% INITWORLD  Initialize world

% WORLD: double cloister size 2*cSize m
cSize = 5;
world = thickCloister(-cSize,cSize,-cSize,cSize,3);
% world = [...
%      5  0  0 0   
%     10  1  1 0
%     20  1 -1 0
%     30 -1  1 0
%     40 -1 -1 0
%     41  3  3 0
%     42  3 -3 0
%     43 -3  3 0
%     44 -3 -3 0
%     45  0  0 5
%     46  0  3 5
%     50  3  0 5
%     55  0 -3 5
%     60 -3  0 5
%     65  0  1 5
%     70  1  0 5
%     75  0 -1 5
%     80 -1  0 5]';
% 
