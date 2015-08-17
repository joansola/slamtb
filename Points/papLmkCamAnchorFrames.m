function [ maincamframe, assocamframe ] = papLmkCamAnchorFrames( Lmk, Sen, Frm )
%PAPLMKCAMANCHORFRAMES Returns the anchor frames of a landmark
%  The anchor frames are the camera frames obtained by composing the anchor
%  frames with the sensor frame.

% Type error check
if strcmp(Lmk.type,'papPnt') == false
    error('Expected landmark of type papPnt instead of ''%s''.',Lmk.type);
end

% get camera anchor poses from frames and sensors
mainframe = updateFrame(Frm(Lmk.par.mainfrm).state);
assoframe = updateFrame(Frm(Lmk.par.assofrm).state);
maincamframe = composeFrames(mainframe,Sen.frame);
assocamframe = composeFrames(assoframe,Sen.frame);

end