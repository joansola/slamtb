function [ Lmk, Frms, Facs ] = papChangeAssoAnchorToFrm( Lmk, Frms, Facs, targetfrm, targetfac )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Look for targetfac if it is not passed as parameter
if nargin < 5
    for fac = Lmk.factors
        if ismember(targetframe,Facs(fac).frame)
            targetfac = fac;
            break;
        end
    end
end

% legend:
%   l = lmk
%   M = main frame
%   A = anchor frame
%   T = target frame
%   O = other frame
%
%     (l)      (l)       (l)        (l)
%      |        |         |          |
%     [ ]      [ ]       [ ]        [ ]
%      |       / \      / | \      / | \
%     (M)    (M) (A)  (M)(A)(T)  (M)(A)(O)
%
%     |||      |||       |||        |||
%     |||      VVV       VVV        VVV
%
%     (l)      (l)       (l)        (l)
%      |        |         |          |
%     [ ]      [ ]       [ ]        [ ]
%      |      / | \      / \       / | \
%     (M)   (M)(T)(A)  (M) (T)   (M)(T)(O)

% Update Fac.frames and Frm.factors pointers
for fac = Lmk.factors
    if fac == Lmk.par.mainfac
        % main anchor factor update
        % Nothing to do
    elseif fac == Lmk.par.assofac
        % asso anchor factor update
        Facs(fac).frames = [Lmk.par.mainfrm targetfrm Lmk.par.assofrm]; % Warning: the order in Facs(fac).frames matter!
        Frms(targetfrm).factors = [Frms(targetfrm).factors fac];
    elseif fac == targetfac
        % target factor update
        Facs(fac).frames = [Lmk.par.mainfrm targetfrm]; % Warning: the order in Facs(fac).frames matter!
        Frms(Lmk.par.assofrm).factors([Frms(Lmk.par.assofrm).factors] == fac) = [];
    else
        % all other factors update
        Facs(fac).frames(2) = targetfrm; % Warning: the order in Facs(fac).frames matter!
        Frms(Lmk.par.assofrm).factors([Frms(Lmk.par.assofrm).factors] == fac) = [];
        Frms(targetfrm).factors = [Frms(targetfrm).factors fac];
    end
end

% Update parameter values to finish swaping anchors
Lmk.par.assofac  = targetfac;
Lmk.par.assofrm  = targetfrm;
Lmk.par.assorob  = Facs(targetfac).rob;
Lmk.par.assosen  = Facs(targetfac).sen;
Lmk.par.assomeas = Facs(targetfac).meas.y;

end

