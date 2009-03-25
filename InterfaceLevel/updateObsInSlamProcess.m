
function Obs_sen = updateObsInSlamProcess(Obs_sen, Lmk)


% UPDATEOBSINSLAMPROCESS  Update OBS information after SLAM observation.
%   UPDATEOBSINSLAMPROCESS(OBS_SEN, LMK) updates .meas and .exp fields in
%   OBS_SEN.
%
%   This function is in developpement.

% for each Lmk in the state
% for numLmk = 1:numel(Lmk)
%     lmkId = Lmk(numLmk).id ;
%     % if used
%     if(Lmk(numLmk).used)
%         
%         % if exists in Obs:
%         
%         
%         % Test
%         
%         Obs_sen(numLmk).meas.y = Lmk(numLmk).state.x;
%         Obs_sen(numLmk).meas.R = Lmk(numLmk).state.P;
%         Obs_sen(numLmk).meas.e = Lmk(numLmk).state.x;
%         Obs_sen(numLmk).meas.E = Lmk(numLmk).state.P;
%         Obs_sen(numLmk).measured = true;
%         Obs_sen(numLmk).matched  = true;
%         Obs_sen(numLmk).updated  = false;
%         Obs_sen(numLmk).vis = true;
%     end ;
% end ;



%     id         = 195;
%     Lmk(10).id = id; % Simulate landmark exists in map in position index 23.
%     lmk  = find([Lmk.id] == id);
%     for sen = 1:numel(Sen)
%         oidx = find(SimObs(sen).ids == id);
%         if ~isempty(oidx)
%             Obs(sen,lmk)  = testObs(Obs(sen,lmk), SimObs(sen).points(:,oidx), 5^2*eye(2));
%             Obs(sen,lmk).lid = id;
%         else
%             Obs(sen,lmk).vis = false;
%         end
%     end
% 
% Obs.meas.y = pos;
% Obs.meas.R = COV;
% 
% Obs.exp.e = Obs.meas.y;
% Obs.exp.E = Obs.meas.R;
% 
% Obs.measured = true;
% Obs.matched  = true;
% Obs.updated  = false;
% 
% Obs.vis = true;


end
