function SenFig = drawSenFig(SenFig, Obs, Sen, Lmk)

% DRAWSENFIG (SENFIG, OBS, SEN, LMK)  (re)draw the sensors figures.
% return the SENFIG


visible = {'off','on'};
posOffset = [0;0];


for sen = 1:size(Obs,1)     %numel(Sen)

    for lmk = 1:size(Obs,2) %numel(Lmk)

        % Sensor type:
        % ------------
        switch Sen(sen).type

            % camera pinhole
            % --------------
            case {'pinHole'}

                % process only visible landmarks
                if Obs(sen,lmk).vis

                    % Landmark type:
                    % --------------
                    switch Lmk(lmk).type

                        % idp
                        % ---
                        case {'idpPnt'}

                            colors = ['m' 'r']; % magenta/red

                            % the measurement:
                            y = Obs(sen,lmk).meas.y;
                            set(SenFig(sen).measure(lmk),...
                                'xdata', y(1),...
                                'ydata', y(2),...
                                'color', colors(1),...
                                'vis',   visible{1+Obs(sen,lmk).measured});

                            % the ellipse
                            [X,Y] = cov2elli(Obs(sen,lmk).exp.e, Obs(sen,lmk).exp.E, 3, 10) ;
                            set(SenFig(sen).ellipse(lmk),...
                                'xdata', X,...
                                'ydata', Y,...
                                'color', colors(1+Obs(sen,lmk).updated),...
                                'vis',   'on');

                            % the label
                            pos = Obs(sen,lmk).exp.e + posOffset;
                            set(SenFig(sen).label(lmk),...
                                'position', pos,...
                                'vis',      'on');


                            % euclidian
                            % ---------
                        case {'eucPnt'}

                            colors = ['b' 'c']; % magenta/red

                            % the measurement:
                            y = Obs(sen,lmk).meas.y;
                            set(SenFig(sen).measure(lmk),...
                                'xdata', y(1),...
                                'ydata', y(2),...
                                'color', colors(1),...
                                'vis',   'on');

                            % the ellipse
                            [X,Y] = cov2elli(Obs(sen,lmk).exp.e, Obs(sen,lmk).exp.E, 3, 10) ;
                            set(SenFig(sen).ellipse(lmk),...
                                'xdata', X,...
                                'ydata', Y,...
                                'color', colors(1+Obs(sen,lmk).updated),...
                                'vis',   'on');

                            % the label
                            pos = Obs(sen,lmk).exp.e + posOffset;
                            set(SenFig(sen).label(lmk),...
                                'position', pos,...
                                'vis',      'on');





                            % ADD HERE FOR INITIALIZATION OF NEW LANDMARK's
                            % type
                            % case {'newLandmark'}
                            % do something

                            % unknown
                            % -------
                        otherwise
                            % TODO : print an error and go out
                            error(['The sensor type is unknown, cannot display the sensor ',Sen(sen).name,' with type=',Sen(sen).type,' with landmark''s type ',Lmk(lmk).type,'!\n']);
                    end

                else % Lmk is not visible : draw blank
                    set(SenFig(sen).measure(lmk),'vis','off');
                    set(SenFig(sen).ellipse(lmk),'vis','off');
                    set(SenFig(sen).label(lmk),  'vis','off');
                end

                % ADD HERE FOR INITIALIZATION OF NEW SENSORS's FIGURES
                % case {'newSensor'}
                % do something


                % unknown
                % -------
            otherwise
                error(['The sensor type is unknows, cannot display the sensor ',Sen(sen).name,' with type=',Sen(sen).type,'!']);
        end


    end
end

end
