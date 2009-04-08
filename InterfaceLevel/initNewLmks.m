
<<<<<<< .mine
function [Lmk,Obs] = initNewLmks(Rob, Sen, Lmk, Obs, SimObs)
% function Lmk = initNewLmks(Rob, Sen, SimObs, Lmk)
=======
function Lmk = initNewLmks(Rob, Sen, Raw, Lmk)
>>>>>>> .r157

% INITNEWLMKS  Initialise some new landmarks from recent observations.
%   LMK = INITNEWLMKS(ROB, SEN, SIMOBS, LMK) returns the new set of
%   landmarks.
%
%   This "new set" contains the "old set" plus new elements. These new
%   elements are extracted from the recent observations (SIMOBS), from the
%   current state estimated (ROB for robot and SEN for the sensor).
%
%   Finally, we can have a mean and a variance-covariance estimation for
%   the new landmark state.
%

%
%   To do this operation, we must "inverse" the observation function. but
%   if the function is not inversible (2D information -> 3D point for
%   example), we must introduce a 3rd ad-hoc information (the distance for
%   example).

global Map

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
            for idobs = Raw.data.ids

                % observation not in known lmk:
                if(~any(~is_usable & [Lmk.id]==idobs))
                    
                    inv_depth_nob = Lmk(indexNew).nom.n ;
                    point = Raw.data.points(:,find([Raw.data.ids]==idobs)) ;
                    [idp, IDPrf, IDPsf, IDPsk, IDPsd, IDPpix, IDPrho] = ...
                        retroProjectIdpPntFromPinHoleOnRob( ...
                            Rob.frame, ...
                            Sen.frame, ...
                            Sen.par.k, ...
                            Sen.par.d, ...
                            point, ...
                            inv_depth_nob) ;

                    Lmk(indexNew).used     = true ;
                    Lmk(indexNew).id       = idobs ;
                    Lmk(indexNew).sig      = idobs ;
                    Lmk(indexNew).state.x  = idp ;

                    % TODO put better variance-covariance matrix
                    Rpix = Sen.par.pixCov ;
                    Rnob = Lmk(indexNew).nom.N ;
                    % if the sensor frame is in the state
                    % IDPmap = [IDPrf IDPsf] ;
                    IDPmap = IDPrf ;
                    % if the sensor frame is in the state
                    % Rmap = Map.P([Rob.frame.r;Sen.frame.r],[Rob.frame.r;Sen.frame.r]) ;
                    Rmap = Map.P(Rob.frame.r,Rob.frame.r) ;
                    
                    % var_covar LL
                    Lmk(indexNew).state.P  = ...
                        IDPpix*Rpix*IDPpix' + ...  % by pixel cov
                        IDPrho*Rnob*IDPrho' + ...  % by nob   cov
                        IDPmap*Rmap*IDPmap'     ;  % by map   cov
                    
                    % covar_LX
                    P_RX = Map.P(Rob.frame.r,find(Map.used)) ;
                    P_LX = IDPrf*P_RX ;
                    
                    % frame range in Map
                    Lmk(indexNew).state.r = addToMap(Lmk(indexNew).state.x,Lmk(indexNew).state.P,P_LX);

                    % only 1 idp-add for each time-step
                    break ;
                end ;
            end ;
        else
            %disp('Not enough free space to initialise new Lmk')
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