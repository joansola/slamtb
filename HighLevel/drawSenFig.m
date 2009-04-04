function drawSenFig(SenFig, Sen, Lmk, Obs, SimObs)

% DRAWSENFIG  Redraw the sensors figures.
% 	DRAWSENFIG(SENFIG, SEN, LMK, OBS, SIMOBS) updates all the handles in
% 	the handles structure array SENFIG to reflect the observations OBS
% 	taken by sensor SEN on landmarks LMK, together with the simulated
% 	observations SIMOBS. SENFIG is the sensor structure created with
% 	CREATESENFIG.
%
%   See also CREATESENFIG, DRAWMAPFIG.


for sen = 1:size(Obs,1)     %numel(Sen)

    %     for lmk = 1:size(Obs,2) %numel(Lmk)

    % Sensor type:
    % ------------
    switch Sen(sen).type

        % camera pinhole
        % --------------
        case {'pinHole'}

            % 1. Simulated landmark visualisation
            set(SenFig(sen).raw,...
                'xdata',SimObs(sen).points(1,:),...
                'ydata',SimObs(sen).points(2,:))

            % 2. Process only visible landmarks:
            % a - first erase lmks that were drawn but are no longer visible
            vis   = [Obs(sen,:).vis];
            drawn = (strcmp((get(SenFig(sen).ellipse,'vis')),'on'))';
            erase = drawn & ~vis;

            set(SenFig(sen).measure(erase),'vis','off');
            set(SenFig(sen).ellipse(erase),'vis','off');
            set(SenFig(sen).label(erase),  'vis','off');

            % b - now draw only visible landmarks
            for lmk = find(vis)

                % Landmark type:
                % --------------
                switch Lmk(lmk).type

                    % idp
                    % ---
                    case {'idpPnt'}

                        colors = ['m' 'r']'; % magenta/red
                        drawObsPoint(SenFig(sen), Obs(sen,lmk), colors);

                        % euclidian
                        % ---------
                    case {'eucPnt'}

                        colors = ['b' 'c']'; % magenta/red
                        drawObsPoint(SenFig(sen), Obs(sen,lmk), colors);


                        % ADD HERE FOR NEW LANDMARK
                        % case {'newLandmark'}
                        % do something


                        % unknown
                        % -------
                    otherwise
                        % Print an error and exit
                        error(['Cannot display landmark type ''',Lmk(lmk).type,''' with ''',Sen(sen).type,''' sensor ''',Sen(sen).name,'''.']);
                end % and of the "switch" on sensor type



                %                 else % Lmk is not visible : draw blank
            end



            % ADD HERE FOR INITIALIZATION OF NEW SENSORS's FIGURES
            % case {'newSensor'}
            % do something


            % unknown
            % -------
        otherwise
            error(['Unknown sensor type. Cannot display''',Sen(sen).type,''' sensor ''',Sen(sen).name,'''.']);
    end


    %     end

end
