function [x,P] = kpredict(x,P,Fx,Fu,u,U)

% KPREDICT Prediction step of KF
%   [X,P] = KPREDICT(X,P,Fx,Fu,u,U) computes the KF prediction step of a
%   system evolving as
%
%       x = Fx*x + Fu*u
%
%   {X,P} is the state estimate.
%   {u,U} is the command estimate. Set u=0 for white perturbation.
%   Fx,Fu are the evolution and perturbation matrices.
%
%   See also KUPDATE, EPREDICT, EUPDATE, DUPDATE, DEUPDATE

x = Fx*x + Fu*u;

P = Fx*P*Fx' + Fu*U*Fu';
