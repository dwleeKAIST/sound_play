function [P1, f_vec] = getSingleSideMagnitudeSpectrum(xf, fs, justSS)
if nargin < 3
    L = length(xf);
    P2  = abs(xf/L);
    if mod(L,2) % odd
        keyboard;
    else
        P1  = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
    end
else
    L = length(xf);
    P1  = xf(1:L/2+1);
    P1(2:end-1) = P1(2:end-1);
end
f_vec = fs*(0:(L/2))/L;