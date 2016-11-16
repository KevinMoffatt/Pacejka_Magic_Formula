function [ Fy ] = Fy(alpha,Fz,gamma,filename, varargin)
%Fy calculates the lateral force
% Using the tire parameters, Fy calculates the lateral force using the
%   following equation:
%
%   Fy = Gyk*Fyp + SVyk
%
%   Input parameters:
% alpha
% Fz
% gamma %
% Slip angle
% Force in the vertical direction
% Inclination angle
%   Optional parameters:
%   Name    Values          Description
% kappa CAMMIN:CAMMAX value of kappa for computing combined slip %
%   Example: Fy(0.05, 9000, 0.1, 0.2)
%
% If no optional arguments are given, the force is calculated for pure
% slipwhereSVyk=0andGyk=1.
if nargin > 4
kappa = varargin{1};
Gyk = fG( kappa, alpha, Fz, gamma, false, filename);
S = ImportTireData(filename);
    FNOMIN = gvar('FNOMIN',S);
    dfz = (Fz - FNOMIN)./Fz;
    % Calculate Muy
Muy = fMu(gvar('PDY1',S), gvar('PDY2',S), gvar('PDY3',S), gamma, gvar('LMUY',S), dfz);
    RVY1 = gvar('RVY1',S);
    RVY2 = gvar('RVY2',S);
    RVY3 = gvar('RVY3',S);
    RVY4 = gvar('RVY4',S);
    RVY5 = gvar('RVY5',S);
    RVY6 = gvar('RVY6',S);
DVyk = Muy.*Fz.*(RVY1 + RVY2.*dfz + RVY3.*gamma).*cos(atan(RVY4.*alpha));
SVyk = DVyk.*sin(RVY5.*atan(RVY6.*kappa)); 
else
Gyk = 1;
SVyk = 0; 
end
Fy = F(alpha,Fz,gamma,false,filename).*Gyk + SVyk;
end
function [Mu] = fMu(PDX1, PDX2, PDX3, gamma, LMux, dfz)
% Inputs:
% PDX1 Longitudinal friction Mux at Fznom
% PDX2 Variation of friction Mux with load
% Ouput:
% Mu Friction coefficient
% Mux = (PDX1 + PDX2*dfz)(1 - PDX3*gamma^2)*LMux % **Removed:(1 + PPX3*dpi + PPX4*dpi^2)
Mu = (PDX1 + PDX2.*dfz).*(1 - PDX3.*gamma.^2).*LMux;
%**(1 + PPX3*dpi + PPX4*dpi^2)
end
