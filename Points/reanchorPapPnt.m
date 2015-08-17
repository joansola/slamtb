function [ Lmk, Frms, Facs ] = reanchorPapPnt( Rob, Sen, Lmk, Obs , Frms, Facs, currFrmIdx, currFacIdx )
%REANCHORPAPPNT Perform a reanchoring of a pap pnt if needed.
%   [ LMK, FRMS, FACS ] = REANCHORPAPPNT( ROB, SEN, LMK, OBS , FRMS, FACS,
%   CURRFRMIDX, CURRFACIDX ) test if the frame FRMS(CURRFRMIDX) is a better
%   anchor than the current main and associated anchor frames, and perform
%   a reanchoring if needed. Note we consider here that the a projection
%   factor to the current frame was already added to the graph.
% 
%   The test is based on the parallax angle values computed using the frame
%   estimates and the observations from these frames. We do not reanchor if
%   the current parallax is above a MAXPARTHRESHOLD. The reanchoring
%   procedure is composed of the following steps:
%      1. update FACS.FRAMES of projection factors to this landmark;
%      2. update LMK.ANCHORFAC
%      3. update pointers on LMK.PAR
%      4. update LMK.STATE.X

%   Copyright 2015 Ellon Paiva @ LAAS-CNRS.

% Only continue if the current factor is not one of the factors linking
% only to anchor frames
if Lmk.par.mainfac == currFacIdx || Lmk.par.assofac == currFacIdx
    return
end
 
% Only continue if the current parallax is not good enough
% TODO: Make MAXPARTHRESHOLD a program option
MAXPARTHRESHOLD = 0.5;
if Lmk.state.x(9) > MAXPARTHRESHOLD
    return
end

% Get main, associated and current camera frames
[ maincamframe, assocamframe ] = papLmkCamAnchorFrames( Lmk, Sen, Frms );
currcamframe = composeFrames(updateFrame(Frms(currFrmIdx).state),Sen.frame);

% Get parallax angle between main anchor frame and current frame, and
% between associated anchor frame and current frame
papmaincurr = measurements2pap(maincamframe, Lmk.par.mainmeas, ...
                               currcamframe, Obs.meas.y,       ...
                               Sen.par.k, Sen.par.c);
papassocurr = measurements2pap(assocamframe, Lmk.par.assomeas, ...
                               currcamframe, Obs.meas.y,       ...
                               Sen.par.k, Sen.par.c);

% Based on the new parallax angles, test if the current frame is a better
% anchor than the current anchors
[~, bestParIdx] = max([Lmk.state.x(9) papmaincurr(9) papassocurr(9)]);
switch bestParIdx
    case 1 % Parallax main-asso is better
        % do nothing
        
    case 2 % Parallax main-current is better, perform the reanchoring
        % Update factors frame indices
        for fac = Lmk.factors
            if fac == Lmk.par.mainfac 
                % No update. The main factor is the same.
                continue;
            elseif fac == Lmk.par.assofac
                % asso anchor factor update
                Facs(fac).frames = [Lmk.par.mainfrm currFrmIdx Lmk.par.assofrm];
            elseif fac == currFacIdx   
                % current factor update
                Facs(fac).frames = [Lmk.par.mainfrm currFrmIdx];
            else
                % all other factors update
                Facs(fac).frames(2) = currFrmIdx;
            end
        end

        % Update anchor factor list
        Lmk.par.assofac = currFacIdx;
        
        % make current frame the new associated anchor
        Lmk.par.assorob = Rob.rob;
        Lmk.par.assofrm = currFrmIdx;
        Lmk.par.assomeas = Obs.meas.y;
        
        % Update lmk state
        Lmk.state.x = papmaincurr;
        
    case 3 % Parallax asso-current is better, perform the reanchoring
        % Update factors frame indices
        for fac = Lmk.factors
            if fac == Lmk.par.mainfac 
                % main anchor factor update
                Facs(fac).frames = [Lmk.par.assofrm currFrmIdx Lmk.par.mainfrm];
            elseif fac == Lmk.par.assofac
                % asso anchor factor update
                Facs(fac).frames = [Lmk.par.assofrm];
            elseif fac == currFacIdx   
                % current factor update
                Facs(fac).frames = [Lmk.par.assofrm currFrmIdx];
            else
                % all other factors update
                Facs(fac).frames(1) = Lmk.par.assofrm;
                Facs(fac).frames(2) = currFrmIdx;
            end
        end
        
        % Update anchor factor list
        Lmk.par.mainfac = Lmk.par.assofac;
        Lmk.par.assofac = currFacIdx;
        
        % make asso anchor frame the new main anchor frame; make the
        % current frame the new asso anchor frame
        Lmk.par.mainrob  = Lmk.par.assorob;
        Lmk.par.mainfrm  = Lmk.par.assofrm;
        Lmk.par.mainmeas = Lmk.par.assomeas;
        Lmk.par.assorob  = Rob.rob;
        Lmk.par.assofrm  = currFrmIdx;
        Lmk.par.assomeas = Obs.meas.y;
        
        % Update lmk state
        Lmk.state.x = papassocurr;
        
end

end

