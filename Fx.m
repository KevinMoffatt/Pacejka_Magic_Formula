function [Fx] = Fx(kappa,Fz,gamma,filename,varargin)
%Fx Calculates the Longitudinal force
% Fx calculates the longitudinal force in the x or y-direction using the
%   tire parameters in cell array S.
%
%   Input parameters:
% kappa
% Fz
% gamma %
% Longitudinal slip
% Force in the vertical direction
% Inclination angle
%   Optional parameters:
%   Name    Values          Description
% alpha ALPMIN:ALPMAX value of alpha for computing combined slip %
%   Example: Fx(0.05, 9000, 0.1, 0.2)
%       alpha is set equal to 0.2
%   The equation is as follows:
%
% F= (D*sin[C*arctan{B*ka - E(B*ka - arctan(Bx*ka))}] + SVx)*Gx
if nargin > 4
    % Combined slip
    alpha = varargin{1};
G = fG( kappa, alpha, Fz, gamma, true, filename); 
else % Pure slip
G = 1; 
end
Fx = G.*F(kappa, Fz, gamma, true, filename);
end