function [P1] = getSingleSideMagnitudeSpectrum(xf, justSS)

L = length(xf);
if nargin==1
    P2  = abs(xf/L);
    scale = 2;
else
    P2 = abs(xf);
    scale = 1;
end
%%
% keyboard;
if mod(L,2) % odd
    keyboard;
else
    P1  = P2(1:L/2+1);
    P1(2:end-1) = scale*P1(2:end-1);
end