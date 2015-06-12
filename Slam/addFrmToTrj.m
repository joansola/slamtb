function [Trj,Frm,Fac] = addFrmToTrj(Trj,Frm,Fac)

% ADDFRMTOTRJ Add frame to trajectory
%   [Trj,Frm,Fac] = ADDFRMTOTRJ(Trj,Frm,Fac) Adds a frame to
%   the trajectory Trj.
%
%   The trajectory is a circular array, so when all positions are full,
%   adding a new frame overwrites the oldest one. In such case, all factors
%   linking to the discarded frame are cleared.
%
%   The added frame is empty, and only its ID is created, distinct to all
%   other IDs.


% Advance HEAD
Trj.head = mod(Trj.head, Trj.maxLength) + 1;

% Update TAIL
if Trj.length < Trj.maxLength

    % Trj is not yet full. Just lengthen.
    Trj.length = Trj.length + 1;

else
    % Trj was full. Oldest frame is overwritten !!
    
    % Copy oldest frame for eventual later use.
    oldFrm = Frm(Trj.tail);

    % Advance TAIL
    Trj.tail = mod(Trj.tail, Trj.maxLength) + 1;
    
    % Clear all factors linking to oldFrm
    for factorId = oldFrm.factors;
        Fac([Fac.id] == factorId).used = false;
    end
    
end

% Complete the new frame before appending it to structure array Frm
id = newId;

% Update Trj
Trj.frmIds(Trj.head) = id;

Frm(Trj.head).id = id;



