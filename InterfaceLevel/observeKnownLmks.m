
function RobNew = observeKnownLmks(Rob, Sen, SimObs, Lmk)

%  OBSERVEKNOWNLMKS update what can be done with non-first observations.
%   ROB = observeKnownLmks(ROB, SEN, SIMOBS, LMK) returns the new robot
%   after some updates wrt some landmark observations.
%
%

switch Sen.type

    % camera pinHole
    case {'pinHole'}

        % Lmk(i) is of type 'idpPnt':
        is_idp = strcmp({Lmk.type},'idpPnt') ;
        %           FREE          IDP
        is_usable = [Lmk.used] & is_idp ;

        if(any(is_usable==1))
            indexNew = find(is_usable==1, 1, 'first') ;

            % foreach id of observed lmk
            for idobs = SimObs.ids

                % observation not in known lmk:
                if(~any(~is_usable & [Lmk.id]==idobs))
                    inv_depth_nob = Lmk(indexNew).nom.n ;
                    point = SimObs.points(:,find([SimObs.ids]==idobs)) ;
                    [idp, IDPrf, IDPsf, IDPsk, IDPsd, IDPpix, IDPrho] = retroProjectIdpPntFromPinHoleOnRob(Rob.frame, Sen.frame, Sen.par.k, Sen.par.d, point, inv_depth_nob) ;

                    Lmk(indexNew).used     = true ;
                    Lmk(indexNew).id       = idobs ;
                    Lmk(indexNew).state.x  = idp ;

                    % TODO put better variance-covariance matrix
                    Lmk(indexNew).state.P  = IDPpix*Sen.par.pixCov*IDPpix' + IDPrho*Lmk(indexNew).nom.N*IDPrho' ; % + ... ???

                    % frame range in Map
                    %Lmk(indexNew).state.r = addToMap(Lmk(indexNew).state.x,Lmk(indexNew).state.P);

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



    RobNew = Rob ;

end
