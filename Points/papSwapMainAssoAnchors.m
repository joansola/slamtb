function [ Lmk, Frms, Facs ] = papSwapMainAssoAnchors( Lmk, Frms, Facs )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% legend:
%   l = lmk
%   M = main frame
%   A = anchor frame
%   O = other frame
%
%     (l)      (l)       (l)
%      |        |         |
%     [ ]      [ ]       [ ]
%      |       / \      / | \
%     (M)    (M) (A)  (M)(A)(O)
%
%     |||      |||       |||
%     VVV      VVV       VVV
%
%     (l)      (l)       (l)
%      |        |         |
%     [ ]      [ ]       [ ]
%     / \       |       / | \
%   (A) (M)    (A)    (A)(M)(O)

% Update Fac.frames and Frm.factors pointers
for fac = Lmk.factors
    if fac == Lmk.par.mainfac 
        % main anchor factor update
        Facs(fac).frames = [Lmk.par.assofrm Lmk.par.mainfrm]; % Warning: the order in Facs(fac).frames matter!
        Frms(Lmk.par.assofrm).factors = [Frms(Lmk.par.assofrm).factors fac];
    elseif fac == Lmk.par.assofac
        % asso anchor factor update
        Facs(fac).frames([Facs(fac).frames] == Lmk.par.mainfrm) = [];
        Frms(Lmk.par.mainfrm).factors([Frms(Lmk.par.mainfrm).factors] == fac) = [];
    else
        % all other factors update
        Facs(fac).frames(1) = Lmk.par.assofrm; % Warning: the order in Facs(fac).frames matter!
        Facs(fac).frames(2) = Lmk.par.mainfrm; % Warning: the order in Facs(fac).frames matter!
    end
end

% Store current parameter values in auxiliar variables
currpar = Lmk.par;

% Update parameter values to finish swaping anchors
Lmk.par.mainfac  = currpar.assofac;
Lmk.par.mainrob  = currpar.assorob;
Lmk.par.mainsen  = currpar.assosen;
Lmk.par.mainfrm  = currpar.assofrm;
Lmk.par.mainmeas = currpar.assomeas;

Lmk.par.assofac  = currpar.mainfac;
Lmk.par.assorob  = currpar.mainrob;
Lmk.par.assosen  = currpar.mainsen;
Lmk.par.assofrm  = currpar.mainfrm;
Lmk.par.assomeas = currpar.mainmeas;

end

