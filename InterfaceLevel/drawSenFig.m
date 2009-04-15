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
        set(SenFig.raw,...
            'xdata',Raw.data.points(1,:),...
            'ydata',Raw.data.points(2,:))

        % 2. Process only visible landmarks:
        % a - first erase lmks that were drawn but are no longer visible
        vis   = [Obs(:).vis];
        drawn = (strcmp((get(SenFig.ellipse,'vis')),'on'))';
        erase = drawn & ~vis;

        set(SenFig.measure(erase),'vis','off');
        set(SenFig.ellipse(erase),'vis','off');
        set(SenFig.label(erase),  'vis','off');

        % b - now draw only visible landmarks
        for lmk = find(vis)

            % Landmark type:
            % --------------
            switch Obs(lmk).ltype

                % idp
                % ---
                case {'idpPnt'}

                    colors = ['m' 'r']'; % magenta/red
                    drawObsPoint(SenFig, Obs(lmk), colors);

                    % euclidian
                    % ---------
                case {'eucPnt'}

                    colors = ['b' 'c']'; % magenta/red
                    drawObsPoint(SenFig, Obs(lmk), colors);


                    % ADD HERE FOR NEW LANDMARK
                    % case {'newLandmark'}
                    % do something


                    % unknown
                    % -------
                otherwise
                    % Print an error and exit
                    error(['Cannot display landmark type ''',Obs(lmk).ltype,''' with ''',Sen.type,''' sensor ''',Sen.name,'''.']);
            end % and of the "switch" on sensor type



            %                 else % Lmk is not visible : draw blank
        end



        % ADD HERE FOR INITIALIZATION OF NEW SENSORS's FIGURES
        % case {'newSensor'}
        % do something


        % unknown
        % -------
    otherwise
        error(['Unknown sensor type. Cannot display''',Sen.type,''' sensor ''',Sen.name,'''.']);
end


%     end

% end
