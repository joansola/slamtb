% RMSEPLOTS  Plot the results of RMSE analysis for slamtb.
%   RMSEPLOTS is a script for evaluating average RMSE performance of
%   slamtb. It displays the results of RMSEANALYSIS.
%
%   Specify the types of landmarks in variable:  lmkTypes.
%   Specify the number of runs for each lmk in:  numRuns.
%   Specify the length of each run in         :  numFrames.
%   Specify the location of log files in      :  logsDir.
%
%   These values must match those in RMSEANALYSIS. For the state dimension,
%   it must much that of the RMSE computation within SLAMTBSLAVE file.
%
%   See also SLAMTBSLAVE, RMSEANALYSIS.

% Copyright 2010 Joan Sola @ LAAS-CNRS

% lmkTypes = {'hmgPnt','ahmPnt','idpPnt'};
lmkTypes = {'idpPnt'};
% lmkTypes = {'plkLin','aplLin','hmgLin','ahmLin','idpLin'};
% lmkTypes = {'plkLin','aplLin'};
% lmkTypes = {'hmgLin','ahmLin','idpLin'};

numRuns   = 25;
numFrames = 400;

logsDir   = '~/SLAM/logs/pose6d/RMSE/test/';

df = 1;
titles = 'xyzrpy';
colors = 'rgbmc';
figure(60)
clf

for lt = 1:numel(lmkTypes)
    lmkType = lmkTypes{lt};
    
    rmseData{lt}.errdata=zeros(6,numFrames,numRuns);
    rmseData{lt}.errmean=zeros(6,numFrames);    
    rmseData{lt}.stddata=zeros(6,numFrames,numRuns);
    rmseData{lt}.stdmean=zeros(6,numFrames);
    
    for nRun = 1:numRuns
        logFileName = [logsDir lmkType '-rmse-' num2str(nRun,'%02d') '.log'];
        
        fid = fopen(logFileName,'r');
        fgetl(fid);
        data = fscanf(fid,'%d %f %f %f %f %f %f %f %f %f %f %f %f\n',[13 inf]);
        rmseData{lt}.errdata(:,:,nRun) = data(2:7,:);
        rmseData{lt}.stddata(:,:,nRun) = data(8:13,:);
        
        fclose(fid);
    end
    rmseData{lt}.errmean = std(rmseData{lt}.errdata,0,3);
    rmseData{lt}.stdmean = mean(rmseData{lt}.stddata,3);
    
    %     This draws linear plots in separate axes
    for i = 1:3 % 3 position DOF
        ax(lt,i) = subplot(2,3,i);
        hold on
        plot(1:df:numFrames,100*rmseData{lt}.errmean(i,1:df:numFrames)','linestyle','-','color',colors(lt))
        title(titles(i))
        plot(1:df:numFrames,200*rmseData{lt}.stdmean(i,1:df:numFrames)','linestyle','-','color',colors(lt),'linewidth',2)
        hold off
    end    
    for i = 4:6 % 3 orientation DOF
        ax(lt,i) = subplot(2,3,i);
        hold on
        plot(1:df:numFrames,rad2deg(rmseData{lt}.errmean(i,1:df:numFrames))','linestyle','-','color',colors(lt))
        title(titles(i))
        plot(1:df:numFrames,rad2deg(2*rmseData{lt}.stdmean(i,1:df:numFrames))','linestyle','-','color',colors(lt),'linewidth',2)
        hold off
    end    
end



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
%   Copyright (c) 2014-2015, Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

