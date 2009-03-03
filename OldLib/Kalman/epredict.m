function [x,P,Fx,Fu] = epredict(x,P,f,u,U,dt,varargin)

% EPREDICT Prediction step of EKF
%   [X,P] = EPREDICT(X,P,@f,u,U,DT) computes the EKF prediction step of a
%   system evolving as
%
%       x = f(x,u,dt)
%
%   {X,P} is the state estimate.
%   {u,U} is the command estimate. Set u=0 for white perturbation.
%   f     is the evolution function. It must be in the form [x,Fx,Fu] = f(x,u),
%       where Fx and Fu are the Jacobians wrt the state x and the control
%       input u.
%   DT    is the sample time
%
%   EPREDICT(...,DT,VARARGIN) allows entering additional parameters to the
%   function f(), i.e., f(X,U,VARARGIN{:}). This may be used in INS to pass
%   the gravity vector parameter.
%
%   [X,P,Fx,Fu] = EPREDICT(...) provides the prediction function Jacobians
%   wrt X and u.
%
%   See also KPREDICT, KUPDATE, EUPDATE, DUPDATE, DEUPDATE, VARARGIN

[x,Fx,Fu] = f(x,u,dt,varargin{:});

P = Fx*P*Fx' + Fu*U*Fu';
