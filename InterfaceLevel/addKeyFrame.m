function [Rob,Lmk,Trj,Frm,Fac] = addKeyFrame(Rob,Lmk,Trj,Frm,Fac,factorRob, factorType)

global Map

% Add frame to trajectory
[Lmk,Trj,Frm,Fac] = addFrmToTrj(...
    Lmk,...
    Trj,...
    Frm,...
    Fac);

% Add to Map
r = newRange(Frm(Trj.head).state.dsize);
blockRange(r);
Frm(Trj.head).state.r = r;
Map.x(r) = 0;

% Update new frame with Rob info
[Rob, Frm(Trj.head)] = rob2frm(...
    Rob,...
    Frm(Trj.head));

% Create motion factor
fac = find([Fac.used] == false, 1, 'first');

switch factorType
    
    case 'absolute'
        [Frm(Trj.head), Fac(fac)] = makeAbsFactor(...
            Frm(Trj.head), ...
            Fac(fac), ...
            Rob);
        
    case 'motion'
        head_old = mod(Trj.head - 2, Trj.maxLength) + 1;
        [Frm(head_old), Frm(Trj.head), Fac(fac)] = makeMotionFactor(...
            Frm(head_old), ...
            Frm(Trj.head), ...
            Fac(fac), ...
            factorRob);
        
    otherwise
        error('??? Unknown or invalid factor type ''%s''.', facType)
end

