function [ Mx,My,Mz ] = MomentCalc(fn, Fz, Fx, Fy, gamma, alpha, varargin)
%MOMENTCALC Calculates the moment in the x, y, and z directions
% MomentCalc calculates the overturning moment, Mx; rolling resistance
%   moment, My; and the self aligning moment, Mz.
%
%   Input parameters: (Note: deleted a lot of comments)
% Br=
% Cr=1
% Dr = Fz*((QDZ6 + QDZ7*dfz)*LRES + (QDZ8 + QDZ9*dfz)*gz)*R0*LMuy 
S = ImportTireData(fn);

%   Overturning Moment, Mx
R0 = gvar('UNLOADED_RADIUS',S);
LMx = gvar('LMX',S);
QSX1 = gvar('QSX1',S);
QSX2 = gvar('QSX2',S);
QSX3 = gvar('QSX3',S);
FNOMIN = gvar('FNOMIN',S);
LVMx = 1;
Mx = R0.*Fz.*LMx.*(QSX1.*LVMx - QSX2.*gamma + QSX3.*Fy./FNOMIN);
%   Rolling Resistance moment, My
QSY1 = gvar('QSY1',S);
QSY2 = gvar('QSY2',S);
dfz = (Fz - FNOMIN)./Fz;
if gvar('FITTYP',S) ~= 5
    Vx = varargin{1};
    LMy = gvar('LMY',S);
    QSY3 = gvar('QSY3',S);
    LONGVL = gvar('LONGVL',S);
My = -R0.*FNOMIN.*LMy.*(QSY1 + QSY2.*Fx./FNOMIN + QSY3.*abs(Vx./LONGVL)+ QSY4.*(Vx./LONGVL)^4);
elseif QSY1 == 0 && QSY2 == 0
    PKX1 = gvar('PKX1',S);
    PKX2 = gvar('PKX2',S);
    PKX3 = gvar('PKX3',S);
    LKx = gvar('LKX',S);
Kx = (PKX1 + PKX2.*dfz).*exp(PKX3.*dfz).*Fz.*LKx;
SVx = fSV(gvar('PVX1',S),gvar('PVX2',S),dfz,Fz,gvar('LVX',S),gvar('LMUX',S)); SHx = fSH(gvar('PHX1',S),gvar('PHX2',S),gvar('LHX',S),dfz);
    My = R0.*(SVx + Kx.*SHx);
end

%   Self aligning moment, Mz
QHZ1 = gvar('QHZ1',S);
QHZ2 = gvar('QHZ2',S);
QHZ3 = gvar('QHZ3',S);
QHZ4 = gvar('QHZ4',S);
LGAZ = gvar('LGAZ',S);
gz = gamma.*LGAZ;
SHt = QHZ1 + QHZ2.*dfz + (QHZ3 + QHZ4.*dfz).*gz;
at = alpha + SHt;
QBZ1 = gvar('QBZ1',S);
QBZ2 = gvar('QBZ2',S);
QBZ3 = gvar('QBZ3',S);
QBZ4 = gvar('QBZ4',S);
QBZ5 = gvar('QBZ5',S);
LKY  = gvar('LKY',S);
LMUY = gvar('LMUY',S);
Bt = (QBZ1 + QBZ2.*dfz + QBZ3.*dfz.^2).*(1+ QBZ4.*gz + QBZ5.*abs(gz)).*LKY./LMUY;
QCZ1 = gvar('QCZ1',S);
QDZ1 = gvar('QDZ1',S);
QDZ2 = gvar('QDZ2',S);
QDZ3 = gvar('QDZ3',S);
QDZ4 = gvar('QDZ4',S);
LTR  = gvar('LTR',S);



 
Ct = QCZ1;
Dt = Fz.*(QDZ1 + QDZ2.*dfz).*(1 + QDZ3.*gz+ QDZ4.*gz.^2).*R0./FNOMIN.*LTR;
QEZ1 = gvar('QEZ1',S);
QEZ2 = gvar('QEZ2',S);
QEZ3 = gvar('QEZ3',S);
QEZ4 = gvar('QEZ4',S);
QEZ5 = gvar('QEZ5',S);
Et = (QEZ1 + QEZ2.*dfz + QEZ3.*dfz.^2).*(1+ (QEZ4 + QEZ5.*gz).*2./pi.*atan(Bt.*Ct.*at));
                   
warning(['Et = ' Et ' which is greater than one.']);
if Et > ones(size(Et))
end
t = Dt.*cos(Ct.*atan(Bt.*at - Et.*(Bt.*at - atan(Bt.*at)))).*cos(alpha);
%Residual moment, Mzr
SHy = fSH(gvar('PHY1',S),gvar('PHY2',S),gvar('LHY',S),dfz);
SVy = fSV(gvar('PVY1',S),gvar('PVY2',S),dfz,Fz, gvar('LVY ',S),gvar('LMUY',S)); PKY1 = gvar('PKY1',S);
PKY4 = 2; %gvar('PKY4',S); *** not in imput data
PKY5 = 0; %gvar('PKY5',S); *** not in imput data
PKY2 = gvar('PKY2',S);
PKY3 = gvar('PKY3',S);
LFZO = gvar('LFZO',S);
Ky = PKY1.*FNOMIN.*sin(PKY4.*atan(Fz./(PKY2+PKY5.*gamma.^2)./FNOMIN./LFZO)).*(1 - PKY3.*abs(gamma)).*LKY;
SHf = SHy + SVy./Ky;
ar = alpha + SHf;
QBZ9 = gvar('QBZ9',S);
QBZ10 = 1; %gvar('QBZ10',S); *** not found in tire data QDZ6 = gvar('QDZ6',S);
QDZ7 = gvar('QDZ7',S);
LRES = gvar('LRES',S);
QDZ8 = gvar('QDZ8',S);
QDZ9 = gvar('QDZ9',S);
%****

% Calculate Muy
Muy = fMu(gvar('PDY1',S), gvar('PDY2',S), gvar('PDY3',S), gamma, gvar('LMUY',S), dfz);
% Calculate Dy
Dy = fD(Muy, Fz);
% Calculate Cy
Cy = fC(gvar('PCY1',S), gvar('LCY',S));
% Calculate By
By = fB(Ky, Cy, Dy);
%****
Br = QBZ9.*LKY./LMUY + QBZ10.*By.*Cy;
Cr = 1;
Dr = Fz.*((QDZ6 + QDZ7.*dfz).*LRES + (QDZ8 + QDZ9.*dfz).*gz).*R0.*LMUY; Mzr = Dr.*cos(Cr.*atan(Br.*ar)).*cos(alpha);
Mz = -t.*Fy + Mzr;
end

function [SV] = fSV(PVX1,PVX2,dfz,Fz,LVx,LMux)
% Inputs:
% PVX1
% PVX2
% LVx
% LMux
% Fz
% dfz %
% Vertical shift Svx/Fz at Fznom
% Variation of shift Svx/Fz with load
% Scale factor of Fx vertical shift
% Scale factor of Fx peak friction coefficient ka scaled with SHx
% Dimensionless increment of vertical force Fz
% Ouput:
%   SV = (PVX1 + PVX2*dfz)*Fz*LVx*LMux
SV = Fz.*(PVX1 + PVX2.*dfz).*LVx.*LMux;
end

function [SH] = fSH(PHX1, PHX2, LHx,dfz)
% Inputs:
% PHX1
% PHX2
% LHX
% Horizontal shift Shx at Fznom
% Variation of shift Shx with load
% Scale factor of Fx horizontal shift Dimensionless increment of vertical force Fz
%   dfz
%
% Ouput:
%   SHx = (PHX1 + PHX2*dfz)*LHx
SH = (PHX1 + PHX2.*dfz).*LHx;
end

function [Mu] = fMu(PDX1, PDX2, PDX3, gamma, LMux, dfz)
% Inputs:
%
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
%
% Ouput:
%
C = PCX1*LCx;
end
% Calculate B
function [B] = fB(K, C, D)
% Inputs:
%
% Ouput:
%
B = K./(C.*D);
end
