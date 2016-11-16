function [ G ] = fG( kappa, alpha, Fz, gamma, isX, filename)
%fG calculates the combined slip modification factor for the x or y direction
% fG uses the tire parameters as well as the inputs to compute the
% combined slip factor G, which equation is shown below: %
% G = (cos(C*atan(B*ak - E*(B*alphaS - atan(B*alphaS)))))/
% (cos(C*atan(B*SH - E*(B*SH - atan(B*SH))))) %
% where
%   alphaS = alphaF + SH
% B = (RBX1 + RBX3*gamma^2)*cos(atan(RBX2*kappa))*LXA
% C=RCX1
% E=REX1+REX2
% SH = RHX1
S = ImportTireData(filename);
FNOMIN = gvar('FNOMIN',S);
dfz = (Fz - FNOMIN)./Fz;
if gvar('USE_MODE',S) ~= 4
warning('Tire data file is not configured for combined slip. \n USE_MODE = %d: Fx,Fy,Mx,My,Mz uncombined force/moment calculation',gvar('USE_MODE',S));
G = 1; 
else
    if isX
        RHX1 = gvar('RHX1',S);
        RBX1 = gvar('RBX1',S);
        RBX2 = gvar('RBX2',S);
        RBX3 = 0; %not in tire data gvar('RBX3',S);
        RCX1 = gvar('RCX1',S);
        REX1 = gvar('REX1',S);
        REX2 = gvar('REX2',S);
        LXA = gvar('LXAL',S);
B = (RBX1 + RBX3.*gamma.^2).*cos(atan(RBX2.*kappa)).*LXA; SH = RHX1;
akS = alpha + SH; %akS: alphaS = alphaF + SHxa
    else
        RHY1 = gvar('RHY1',S);
        RHY2 = gvar('RHY2',S);
        RBY1 = gvar('RBY1',S);
        RBY2 = gvar('RBY2',S);
        RBY3 = gvar('RBY3',S);
        RBY4 = 0; %not in tire data gvar('RBY4',S);
        RCX1 = gvar('RCY1',S);
        REX1 = gvar('REY1',S);
        REX2 = gvar('REY2',S);
        LYK = gvar('LYKA',S);

B = (RBY1 + RBY4.*gamma.^2).*cos(atan(RBY2.*(alpha - RBY3))).*LYK; SH = RHY1 + RHY2.*dfz;
akS = kappa + SH; %akS: kappaS = kappa + SHyk
    end
    C = RCX1;
    E = REX1 + REX2.*dfz;
G = (cos(C.*atan(B.*akS - E.*(B.*akS - atan(B.*akS)))))./(cos(C.*atan(B.*SH - E.*(B.*SH - atan(B.*SH)))));
end
end
