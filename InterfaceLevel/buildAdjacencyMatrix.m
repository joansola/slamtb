function [A, a, B, b] = buildAdjacencyMatrix(Lmk,Frm,Fac)

nframes  = sum([Frm.used]);
nlmks    = sum([Lmk.used]);

% Motion
A = sparse(nframes,nframes);
a = zeros(nframes,3);

% Measurements
B = sparse(nframes+nlmks,nframes+nlmks);
b = zeros(nframes+nlmks,3);

for fac = find([Fac.used])
    
    frames = Fac(fac).frames;
    lmk = Fac(fac).lmk;

    switch Fac(fac).type
        case'motion'
            A(frames(1),frames(2))   = 1;
            a(frames(1),1:3) = Frm(frames(1)).state.x(1:3)';
            a(frames(2),1:3) = Frm(frames(2)).state.x(1:3)';
        case 'absolute'
        case 'measurement'
            B(frames,lmk+nframes) = 1;
            b(frames,1:3) = Frm(frames).state.x(1:3)';
            b(lmk+nframes,1:3) = Lmk(lmk).state.x(1:3)';
    end

end
