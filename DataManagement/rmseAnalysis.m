% RMSEANALYSIS  RMSE analysis for slamtb.
%   RMSEANALYSIS is a script for evaluating average RMSE performance of
%   slamtb. It uses a slave version of SLAMTB, called SLAMTBSLAVE, and runs
%   it for N times with different kinds of landmarks.
%
%   Specify the types of landmarks in variable:  lmkTypes.
%   Specify the number of runs for each lmk in:  numRuns.
%   Specify the length of each run in         :  numFrames.
%   Specify the destination of log files in   :  logsDir.
%   Specify the rendering period in           :  rendPeriod.
%   Specify lmk parametrization with the flag :  reparametrize.
%   Specify N random seeds in                 :  randSeeds.
%
%   The result of this process is a set of log files. The contents of these
%   files can be plotted with NEESPLOTS.
%
%   See also SLAMTBSLAVE, NEESPLOTS, NEES, ROBOTNEES.

errorAnalysisFunction = @robotRmse;
logsDir    = '~/SLAM/logs/pose6d/RMSE/test/';
logFileHeader = 'frame, err: x y z r p y, std: x y z r p y';

% lmkTypes   = {'ahmPnt'};
% lmkTypes   = {'hmgPnt','idpPnt','ahmPnt'};
% lmkTypes   = {'hmgPnt'};
lmkTypes   = {'idpPnt'};
% lmkTypes   = {'idpPnt','ahmPnt'};
% lmkTypes   = {'plkLin','aplLin','hmgLin','ahmLin','idpLin'};
% lmkTypes   = {'aplLin','idpLin','ahmLin'};
% lmkTypes   = {'idpLin','ahmLin'};
% lmkTypes   = {'aplLin'};
% lmkTypes   = {'plkLin','aplLin'};

numRuns    = 25;
numFrames  = 400;

rendPeriod = 40;
reparametrize = false;
pixelNoise = 1;
noiseFactor = 1;

% randSeeds  = round(10000*rand(1,numRuns));

randSeeds = [8687 8440 3999 2599 8001 4314 9106 1818 2638 1455 1361 8693 5797 5499 1450 8530 6221 3510 5132 4018 7600 2399 1233 1839 2400];
% save [logsDir 'randSeeds.log'] randSeeds -ascii

for l = 1:numel(lmkTypes)
    lmkType = lmkTypes{l};
    for nRun = 1:numRuns
        disp(' ')
        disp('==============================')
        fprintf('Lmk type: %s -- Run #: %d\n',lmkType, nRun);
        disp('==============================')
        logFileName = [logsDir lmkType '-rmse-' num2str(nRun,'%02d') '.log'];
%         logFileName = [lmkType '-' num2str(nRun,'%02d') '.log']
        slamtbSlave;
    end
end

rmsePlots;








