function Line = initPluckerLine(Line,Cam,Obs,Beta)

% INITPLUCKERLINE  Initialize Plucker line.
%   L = INITPLUCKERLINE(L,C,O,BETA) initializes a line by updating the
%   line structure L and the global map structure Map. It considers an
%   observation O taken from a camera C. the non-measurable degrees of
%   freedom are provided in BETA.

global Map

cr = Cam.r;  % camera range
lr = Line.r; % line range
mr = find(Map.used); % map range - without line range

hm = Obs.hm;
Rhm = Obs.Rhm;

beta = Beta.beta;
BETA = Beta.BETA;

[L,Lc,Lk,Lhm,Lb] = retroProjectPlucker(Cam.X,Cam.cal,hm,beta);

Map.X(lr) = L;

Pcc = Map.P(cr,cr);
Pcm = Map.P(cr,mr);

Map.P(lr,lr) = Lc*Pcc*Lc' + Lhm*Rhm*Lhm' + Lb*BETA*Lb';
Map.P(lr,mr) = Lc*Pcm;
Map.P(mr,lr) = Map.P(lr,mr)';

Map.used(lr) = true;
Map.free(lr) = false;

Line.used = true;

% REMOVE OR SET TO 0
Line.s = 8*[-1;1];
