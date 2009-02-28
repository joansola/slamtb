function Lmk = initLmk(Rob,Sens,Obs,Nobs,Lmk)

global Map

lr = Lmk.r; % landmark range

if strncmp(Lmk.type,'idp',3)
    
    if strncmp(Sens.type,'persp',5)
        
        ls = invPinHoleIdp(Sens.f,Sens.k,
    
    