function [ F ] = F(ka, Fz, gamma, isX, filename)
% Initialize S
S = ImportTireData(filename);
% Calculates dfz which is the dimensionless increment of vertical force Fz % dfz = (Fz - Fz0)/Fz where Fz0 = FNOMIN
FNOMIN = gvar('FNOMIN',S);
dfz = (Fz - FNOMIN)./Fz;
if isX == true %&& isValid == true
% Mux = (PDX1 + PDX2*dfz)(1 - PDX3*gamma^2)*LMux % **Removed:(1 + PPX3*dpi + PPX4*dpi^2)
PDX3 = 0;
% replaced PDX3 with 0 because PDX3 is not found in file
Mux = fMu(gvar('PDX1',S), gvar('PDX2',S), PDX3, gamma, gvar('LMUX',S), dfz);
% Calculate Dx
D = fD(Mux, Fz);
% Calculate Cx
C = fC(gvar('PCX1',S), gvar('LCX',S));
% Calculate Kxk
% Kxk = (PKX1 + PKX2*dfz)exp(PKX3*dfz)*Fz*LKxk
% **Removed: (1 + PPX1*dpi + PPX2*dpi^2)
PKX1 = gvar('PKX1',S);
PKX2 = gvar('PKX2',S);
PKX3 = gvar('PKX3',S);
LKxk = gvar('LKX',S);
Kxk = (PKX1 + PKX2.*dfz()).*exp(PKX3.*dfz()).*Fz.*LKxk;
% Calculate Bx
B = fB(Kxk, C, D);
% Calculate SHx
SH = fSH(gvar('PHX1',S),gvar('PHX2',S),gvar('LHX',S),dfz);
% Correct kappa
ka = ka + SH;
E = fEx(gvar('PEX1',S), gvar('PEX2',S), gvar('PEX3',S), dfz, gvar('PEX4',S),ka,gvar('LEX',S));
SV = fSV(gvar('PVX1',S),gvar('PVX2',S),dfz,Fz,gvar('LVX',S),gvar('LMUX',S));
else %calculate y force
% Calculate Muy
Muy = fMu(gvar('PDY1',S), gvar('PDY2',S), gvar('PDY3',S), gamma, gvar('LMUY',S), dfz);
% Calculate Dy
D = fD(Muy, Fz);
% Calculate Cy
C = fC(gvar('PCY1',S), gvar('LCY',S));
% Calculate Kya
% Kya = PKY1*FNOMIN*sin(PKY4*arctan(Fz/(PKY2 +
% PKY5*gamma^2)/FNOMIN))*(1 - PKY3*abs(gamma))*LKya
% ** removed (1 + PPY1*dpi) twice
PKY1 = gvar('PKY1',S);
%FNOMIN already initiated
PKY4 = 2; %gvar('PKY4',S); *** not in imput data
PKY5 = 0; %gvar('PKY5',S); *** not in imput data
PKY2 = gvar('PKY2',S);
PKY3 = gvar('PKY3',S);
LFZO = gvar('LFZO',S);
LKY = gvar('LKY',S);
Kya = PKY1.*FNOMIN.*sin(PKY4.*atan(Fz./(PKY2+PKY5.*gamma.^2)./FNOMIN./LFZO)).*(1 - PKY3.*abs(gamma)).*LKY;
% Calculate By
B = fB(Kya, C, D);
% Calculate Kyg
PVY3 = gvar('PVY3',S);
PVY4 = gvar('PVY4',S);
% ** removed (1 + PPY5*dpi)
Kyg = (PVY3 + PVY4.*dfz).*Fz;
% Calculate SHy
SHy0 = fSH(gvar('PHY1',S),gvar('PHY2',S),gvar('LHY',S),dfz); SVyg = Fz.*(PVY3 + PVY4.*dfz).*gamma.*LKY.*gvar('LMUY',S); SHyg = (Kyg.*gamma - SVyg)./Kya;
SH = SHy0 + SHyg;
% Calculate SVy
SVy0 = fSV(gvar('PVY1',S),gvar('PVY2',S),dfz,Fz, gvar('LVY ',S),gvar('LMUY',S));
SV = SVy0 + SVyg;
% Correct alpha
ka = ka + SH;
E = fEy(gvar('PEY1',S), gvar('PEY2',S), gvar('PEY3',S), dfz, gvar('PEY4',S),ka,gvar('LEY',S),gamma);
end
% Calculate Fx
F = (D.*sin(C.*atan(B.*ka - E.*(B.*ka - atan(B.*ka))))+SV); 
end
% Calculate Mu
function [Mu] = fMu(PDX1, PDX2, PDX3, gamma, LMux, dfz)
% Inputs:
%  PDX1   Longitudinal friction Mux at Fznom
% PDX2 Variation of friction Mux with load
% Ouput:
% Mu Friction coefficient
% Mux = (PDX1 + PDX2*dfz)(1 - PDX3*gamma^2)*LMux % **Removed:(1 + PPX3*dpi + PPX4*dpi^2)
Mu = (PDX1 + PDX2.*dfz).*(1 - PDX3.*gamma.^2).*LMux;
%**(1 + PPX3*dpi + PPX4*dpi^2)
end
% Calculate D
function [D] = fD(Mu, Fz)
% Inputs:
% Mu    Friction coefficient
% Fz    Vertical reaction force
% Output:
% D     Peak value
D = Mu.*Fz;
end
% Calculate C
function [C] = fC(PCX1, LCx)
% Inputs:
% PCX1 Shape factor Cfx for longitudinal force % LCx Scale factor of Fx shape factor
% Ouput:
%C
C = PCX1*LCx;
end
% Calculate B
function [B] = fB(K, C, D)
% Inputs: %K %C %D
% Ouput:
%B
B = K./(C.*D); 
end
% Calculate SH
function [SH] = fSH(PHX1, PHX2, LHx,dfz)
% Inputs:
% PHX1
% PHX2
% LHX
Horizontal shift Shx at Fznom
Variation of shift Shx with load
Scale factor of Fx horizontal shift Dimensionless increment of vertical force Fz
%   dfz
%
% Ouput:
%   SHx = (PHX1 + PHX2*dfz)*LHx
SH = (PHX1 + PHX2.*dfz()).*LHx;
end
function [E] = fEx(PEX1, PEX2, PEX3, dfz, PEX4,kappax,LEx)
% Inputs:
% PEX1
% PEX2
% PEX3
% PEX4
Longitudinal curvature Efx at Fznom
Variation of curvature Efx with load
Variation of curvature Efx with load squared
Factor in curvature Efx while driving
% LEX Scale factor of Fx curvature factor
% kappax ka scaled with SHx
% dfz Dimensionless increment of vertical force Fz
%
% Ouput:
% E = (PEX1 + PEX2*dfz + PEX3*dfz^2)(1 - PEX4*sgn(kappax))*LEx
E = (PEX1 + PEX2.*dfz + PEX3.*dfz.^2).*(1 - PEX4.*sign(kappax)).*LEx; 
end
function [E] = fEy(PEY1, PEY2, PEY3, dfz, PEY4,alphay,LEy,gamma)
% Inputs:
% PEX1
% PEX2
% PEX3
% PEX4
% LEX
% Longitudinal curvature Efx at Fznom
% Variation of curvature Efx with load
% Variation of curvature Efx with load squared
% Factor in curvature Efx while driving
% Scale factor of Fx curvature factor
% kappax ka scaled with SHx
% dfz Dimensionless increment of vertical force Fz
%
% Ouput:
% E = (PEX1 + PEX2*dfz)(1 - (PEY3 + PEY4*gamma)*sgn(kappax))*LEx
E = (PEY1 + PEY2.*dfz).*(1 - (PEY3 + PEY4.*gamma).*sign(alphay)).*LEy; 
if E > ones(size(E))
warning(['Ey = ' E ' which is greater than or equal to 1']); 
end
end
function [SV] = fSV(PVX1,PVX2,dfz,Fz,LVx,LMux)
% Inputs:
% PVX1
% PVX2
% LVx
% LMux
% Fz
% dfz %
% Ouput:
% SV=
SV = Fz.*(PVX1 + PVX2.*dfz).*LVx.*LMux; 
end