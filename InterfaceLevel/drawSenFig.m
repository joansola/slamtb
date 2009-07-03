function drawSenFig(SenFig, Sen, Raw, Obs)

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

        % 1. Simulated landmark visualisation
        set(SenFig.raw.points,...
            'xdata',Raw.data.points.coord(1,:),...
            'ydata',Raw.data.points.coord(2,:))

        % 2. Process only visible landmarks:
        % a - first erase lmks that were drawn but are no longer visible
        vis   = [Obs(:).vis];
        drawn = (strcmp((get(SenFig.ellipse(:,1),'vis')),'on'))';
        erase = drawn & ~vis;

        set(SenFig.measure(erase),'vis','off');
        set(SenFig.ellipse(erase),'vis','off');
        set(SenFig.label(erase),  'vis','off');

        % b - now draw only visible landmarks
        for lmk = find(vis)

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



            %                 else % Lmk is not visible : draw blank
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
