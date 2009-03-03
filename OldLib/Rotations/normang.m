%
% normalize angle to [-pi, pi]

function [a] = normang(ang);
  
  ang = ang - (ang>pi)*2*pi;
  ang = ang + (ang<-pi)*2*pi;

  a = ang;
  
  
  
  
  