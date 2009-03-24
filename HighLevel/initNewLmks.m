
function Lmk = initNewLmks(Rob, Sen, SimObs, Lmk)

%  INITNEWLMKS  initialise some new landmarks from recent observations.
%   LMK = INITNEWLMKS(ROB, SEN, SIMOBS, LMK) returns the new set of
%   landmarks.
%   
%   This "new set" contains the "old set" plus new elements. These new
%   elements are extracted from the recent observations (SIMOBS), from the
%   current state estimated (ROB for robot and SEN for the sensor).
%
%   To do this operation, we must "inverse" the observation function. but
%   if the function is not inversible (2D information -> 3D point for
%   example), we must introduce a 3rd ad-hoc information (the distance for
%   example).
%   
%   Finally, we can have a mean and a variance-covariance estimation for
%   the new landmark state.
%

    switch Sen.type

        % camera pinHole
        case {'pinHole'}
            
            % Lmk(i) is of type 'idpPnt':
            is_idp = strcmp({Lmk.type},'idpPnt') ;
            %           FREE          IDP
            is_usable = ~[Lmk.used] & is_idp ;
            if(any(is_usable==1))
                indexNew = find(is_usable==1, 1, 'first') ;
                % foreach id of observed lmk
                for idobs = SimObs.ids
                    % observation not in known lmk:
                    if(~any(~is_usable & [Lmk.id]==idobs))
                        inv_depth_nob = Lmk(indexNew).nom.n ;
                        point = SimObs.points(:,find([SimObs.ids]==idobs)) ;
                        idp = retroProjectIdpPntFromPinHoleOnRob(Rob.frame, Sen.frame, Sen.par.k, Sen.par.d, point, inv_depth_nob) ;
                        Lmk(indexNew).used     = 1 ;
                        Lmk(indexNew).id       = idobs ;
                        Lmk(indexNew).state.x  = idp ;
                        % TODO put correct variance-covariance matrix
                        Lmk(indexNew).state.P  = eye(6) ;
                        % frame range in Map
                        Lmk(indexNew).state.r = addToMap(Lmk(indexNew).state.x,Lmk(indexNew).state.P);
                        % only 1 idp-add for each time-step
                        break ;
                    end ;
                end ;
            else
                disp('Not enough free space to initialise new Lmk')
            end ;
            
 %             [SimObs.points, s] = projectEuclPntIntoPinHoleOnRob(SimRob.frame, SimSen.frame, SimSen.par.k, SimSen.par.d, SimLmk.points);
%             SimObs.ids=SimLmk.ids;
% 
%             front=(s>0);
%             intsquare=inSquare(SimObs.points,[0 SimSen.par.imSize(1) 0 SimSen.par.imSize(2)]);
%             vis=(front&intsquare);
% 
%             SimObs.points(:, ~vis)=[];
%             SimObs.ids(~vis)=[];

            % unknown
            % -------
        otherwise
            % Print an error and exit
            error(['Unknown sensor type. Cannot operate an initialisation of landmark with ''',Sen.type,''' sensor ''',Sen.name,'''.']);

    end % end of the "switch" on sensor type



end