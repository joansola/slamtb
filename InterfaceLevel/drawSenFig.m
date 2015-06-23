function SenFig = drawSenFig(SenFig, Sen, Raw, Obs, FigOpt)

% DRAWSENFIG  Redraw one sensor figure.
% 	DRAWSENFIG(SENFIG, SEN, RAW, OBS, FIGOPT) updates all the handles in
% 	the handles structure SENFIG to reflect the observations OBS taken by
% 	sensor SEN, together with the raw data RAW. SENFIG is one sensor figure
% 	structure created with CREATESENFIG.
%
%   See also CREATESENFIG, DRAWMAPFIG.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

% Sensor type:
% ------------
switch Sen.type

    % camera pinhole
    % --------------
    case {'pinHole','pinHoleDepth'}

        % 1. Raw data visualisation
        switch Raw.type
            case 'simu'
                drawRawPnts(SenFig, Raw);
                drawRawLines(SenFig, Raw);
            case 'dump'
                set(SenFig.img,'cdata',Raw.data.img);
                drawRawPnts(SenFig, Raw);
                drawRawLines(SenFig, Raw);
            case 'img'
                set(SenFig.img,'cdata',Raw.data.img);
            otherwise
        end

        % 2. Process only visible landmarks:
        % a - first erase lmks that were drawn but are no longer visible
        vis   = [Obs(:).vis];
        drawn = SenFig.drawn;
        erase = drawn & ~vis;
        if any(erase)
            set(SenFig.measure(erase),   'vis', 'off');
            set(SenFig.mean(erase),      'vis', 'off');
            set(SenFig.ellipse(erase,:), 'vis', 'off');
            set(SenFig.label(erase),     'vis', 'off');
            SenFig.drawn(erase) = false;
        end

        % b - now draw only visible landmarks
        for lmk = find(vis)

            SenFig.drawn(lmk) = true;
            % Landmark type:
            % --------------
            switch Obs(lmk).ltype
                
                case {'eucPnt'}  % Euclidean point
                    colors = FigOpt.sensor.colors.defPnt;
                    drawObsPnt(SenFig, Obs(lmk), colors, FigOpt.sensor.showEllip);

                case {'idpPnt','hmgPnt','ahmPnt','fhmPnt'}  % IDP and HMG points
                    colors = FigOpt.sensor.colors.othPnt;
                    drawObsPnt(SenFig, Obs(lmk), colors, FigOpt.sensor.showEllip);

                case {'plkLin','aplLin','idpLin','hmgLin', 'ahmLin'}  % lines
                    colors = FigOpt.sensor.colors.othLin; 
                    drawObsLin(SenFig, Obs(lmk), colors, FigOpt.sensor.showEllip);

                    % ADD HERE FOR NEW LANDMARK TYPE
                case {'newLandmark'}
                    % do something


                otherwise
                    % Print an error and exit
                    error('??? Unable to display landmark ''%s'' with sensor ''%s''.',Obs(lmk).ltype,Sen.type);

            end % and of the "switch" on sensor type

        end

    
    % --------------
    case {'omniCam'}

        % 1. Raw data visualisation
        if strcmp(Raw.type,'simu')
            drawRawPnts(SenFig, Raw);
        else
            %drawRawImage(SenFig, Raw);
            imshow(Raw.img,'InitialMagnification', 'fit', 'Parent', SenFig.axes);
        end
        
        % 2. Process only visible landmarks:
        % a - first erase lmks that were drawn but are no longer visible
        vis   = [Obs(:).vis];
        drawn = SenFig.drawn;
        erase = drawn & ~vis;
        if any(erase)
            set(SenFig.measure(erase),   'vis', 'off');
            set(SenFig.mean(erase),      'vis', 'off');
            set(SenFig.ellipse(erase,:), 'vis', 'off');
            set(SenFig.label(erase),     'vis', 'off');
            SenFig.drawn(erase) = false;
        end
        % b - now draw only visible landmarks
        for lmk = find(vis)

            SenFig.drawn(lmk) = true;

            % Landmark type:
            % --------------
            switch Obs(lmk).ltype
                
                case {'eucPnt'}  % Euclidean point
                    colors = FigOpt.sensor.colors.defPnt;
                    drawObsPnt(SenFig, Obs(lmk), colors, FigOpt.sensor.showEllip);

                case {'idpPnt','hmgPnt','ahmPnt','fhmPnt'}  % IDP and HMG points
                    colors = FigOpt.sensor.colors.othPnt;
                    drawObsPnt(SenFig, Obs(lmk), colors, FigOpt.sensor.showEllip);

                case {'plkLin','aplLin','idpLin','hmgLin', 'ahmLin'}  % Plucker line
                    colors = FigOpt.sensor.colors.othLin; 
                    drawObsLin(SenFig, Obs(lmk), colors, FigOpt.sensor.showEllip);

                    % ADD HERE FOR NEW LANDMARK TYPE
                case {'newLandmark'}
                    % do something


                otherwise
                    % Print an error and exit
                    error('??? Unable to display landmark ''%s'' with sensor ''%s''.',Obs(lmk).ltype,Sen.type);

            end % and of the "switch" on sensor type

        end
        
   
        % ADD HERE FOR INITIALIZATION OF NEW SENSORS's FIGURES
        % case {'newSensor'}
        % do something


        % unknown
        % -------
    otherwise
        error('??? Unknown sensor type ''%s''.',Sen.type);
end


%     end

% end



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

