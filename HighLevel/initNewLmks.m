
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
            
            for idobs = SimObs.ids
                lmkKnown = 0 ; % 0:false  1:true
                for numLmkDatabase = 1:numel(Lmk)
                    if(Lmk(numLmkDatabase).id==idobs)
                        lmkKnown=1 ;
                    end ;
                end ;
                if(lmkKnown==0)
                    % new landmark
                    OneNewLmk = retroProjectEuclPntIntoPinHoleOnRob() ;
                end ;
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