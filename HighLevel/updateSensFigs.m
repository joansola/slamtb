function updateSensFigs(SenFig, Obs, Sen, Lmk)

% update the figures for each sensors

    for sen = 1:numel(Sen)
        for lmk = 1:numel(Lmk)
            
                % Sensor type:
                % ------------
                switch Sen(sen).type

                    % camera pinhole
                    % --------------
                    case {'pinHole'}
                        
                        
                        % Landmark type:
                        % --------------

                        switch Lmk(lmk).type

                            % idp
                            % ---
                            case {'idpPnt'}
                                
                                % the measurement:
%                                 if Lmk(lmk).vis
%                                     xy = Obs(sen,lmk).meas.y ;
%                                     [X,Y] = cov2elli(Obs(sen,lmk).meas.y, Obs(sen,lmk).meas.R, 3, 10) ;
%                                 else
%                                     
%                                 end
                                
                                
                                
                            % euclidian
                            % ---------
                            case {'eucPnt'}
                                
                                
                                
                                
                            % ADD HERE FOR INITIALIZATION OF NEW LANDMARK's
                            % type
                            % case {'newLandmark'}
                                % do something
                       
                            % unknown
                            % -------
                            otherwise
                                % TODO : print an error and go out
                                fprintf(['\n Error, the sensor type is unknows in (updateSensFigs.m), cannot display the sensor ',Sen(sen).name,' with type=',Sen(sen).type,' with landmark''s type ',Lmk(lmk).type,'!\n\n\n']);
                        end


                    % ADD HERE FOR INITIALIZATION OF NEW SENSORS's FIGURES
                    % case {'newSensor'}
                        % do something


                    % unknown
                    % -------
                    otherwise
                        % TODO : print an error and go out
                        fprintf(['\n Error, the sensor type is unknows in (updateSensFigs.m), cannot display the sensor ',Sen(sen).name,' with type=',Sen(sen).type,'!\n\n\n']);
                end

            
        end
    end

end
