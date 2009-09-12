% NEESPLOTS  Plot the results of NEES analysis for slamtb.
%   NEESPLOTS is a script for evaluating average NEES performance of
%   slamtb. It displays the results of NEESANALYSIS.
%
%   Specify the types of landmarks in variable:  lmkTypes.
%   Specify the number of runs for each lmk in:  numRuns.
%   Specify the length of each run in         :  numFrames.
%   Specify the state dimension in:           :  dimX.
%   Specify the location of log files in      :  logsDir.
%
%   These values must match those in NEESANALYSIS. For the state dimension,
%   it must much that of the NEES computation within SLAMTBSLAVE file.
%
%   See also SLAMTBSLAVE, NEESANALYSIS.

lmkTypes = {'hmgPnt','idpPnt','ahmPnt'};
% lmkTypes = {'hmgPnt','ahmPnt'};

numRuns   = 25;
numFrames = 800;

dimX      = 6;
logsDir   = '~/SLAM/logs/pose6d/oneHpDiverges/';

DOF       = dimX*numRuns;

switch DOF
    case 18
        Lnees = 8.231/numRuns;
        Hnees = 31.526/numRuns;
    case 30
        Lnees = 16.971/numRuns;
        Hnees = 46.979/numRuns;
    case 60
        Lnees = 40.482/numRuns;
        Hnees = 83.298/numRuns;
    case 150
        Lnees = 117.985/numRuns;
        Hnees = 185.800/numRuns;
    otherwise
        error('??? Chi square DOF not defined.')
end

yLim = [300 100 20];

for lt = 1:numel(lmkTypes)
    lmkType = lmkTypes{lt};
    neesData{lt}.data=zeros(numRuns,numFrames);
    neesData{lt}.mean=zeros(1,numFrames);

    for nRun = 1:numRuns
        logFileName = [logsDir lmkType '-' num2str(nRun,'%02d') '.log'];

        fid = fopen(logFileName,'r');
        fgetl(fid);
        data = fscanf(fid,'%d %f\n',[2 inf]);
        neesData{lt}.data(nRun,:) = data(2,:);
    end
    neesData{lt}.mean = mean(neesData{lt}.data);

    figure(50)
    ax(lt) = subplot(3,1,lt);
    plot(1:10:numFrames,neesData{lt}.data(:,1:10:numFrames)','linestyle','-','color',[.5 .5 .5])
    title(lmkType)
    hold on
    plot(neesData{lt}.mean,'linestyle','-','color','k','linewidth',2)
    plot([1 numFrames],Lnees*[1 1],'-r')
    plot([1 numFrames],Hnees*[1 1],'-r')
    ylim([0 yLim(lt)])
    hold off
    xlabel('Time (frames)')
    ylabel(['Avg. NEES, ' num2str(dimX) '-DOF, ' num2str(numRuns) ' runs'])
end

