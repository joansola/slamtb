function SenFig = drawSenFig(SenFig, Sen, Raw, Obs)

% DRAWSENFIG  Redraw one sensor figure.
% 	DRAWSENFIG(SENFIG, SEN, RAW, OBS) updates all the handles in the
% 	handles structure SENFIG to reflect the observations OBS taken by
% 	sensor SEN, together with the raw data RAW. SENFIG is one sensor figure
% 	structure created with CREATESENFIG.
%
%   See also CREATESENFIG, DRAWMAPFIG.


% Sensor type:
% ------------
switch Sen.type

    % camera pinhole
    % --------------
    case {'pinHole'}

        % 1. Raw data visualisation
        drawRaw(SenFig, Raw);

        % 2. Process only visible landmarks:
        % a - first erase lmks that were drawn but are no longer visible
        vis   = [Obs(:).vis];
        drawn = SenFig.drawn;
        erase = drawn & ~vis;
        if any(erase)
            set(SenFig.measure(erase),'vis','off');
            set(SenFig.mean(erase),   'vis','off');
            set(SenFig.ellipse(erase),'vis','off');
            set(SenFig.label(erase),  'vis','off');
            SenFig.drawn(erase) = false;
        end

        % b - now draw only visible landmarks
        for lmk = find(vis)

            SenFig.drawn(lmk) = true;

            % Landmark type:
            % --------------
            switch Obs(lmk).ltype
                
                case {'idpPnt'}  % IDP point
                    colors = ['m' 'r']'; % magenta/red
                    drawObsPnt(SenFig, Obs(lmk), colors);

                case {'eucPnt'}  % Euclidean point
                    colors = ['b' 'c']'; % blue/cyan
                    drawObsPnt(SenFig, Obs(lmk), colors);

                case {'hmgPnt'}  % Homogeneous point
                    colors = ['m' 'r']'; % magenta/red
                    drawObsPnt(SenFig, Obs(lmk), colors);
                    
                case {'plkLin'}  % Plucker line
                    colors = ['b' 'c']'; % blue/cyan
                    drawObsLin(SenFig, Obs(lmk), colors, Sen.par.imSize);

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
