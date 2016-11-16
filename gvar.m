function [ B ] = gvar(varName, S )
%GVAR Gets data from S corresponding to varName
% GVAR (varName as String, S as 1x2 Cell Array) searchs for an exact match of
% varName in the first column of cell array S. If a match is found, GVAR returns
% the value from the 2nd column of S with the same row index.
%   Date Last Revised: 6 Aug 10
x = strmatch(varName, S{1});
if x > 0
    B = S{2}(x);
else
error(['The variable ' varName ' was not found in imported data.'])
end end