function xf_ts = getTwoSideSpectrum(xf_ss, L)

if L==length(xf_ss)*2-2
    xf_ts  = [xf_ss, xf_ss(end:-1:3)];
elseif L==length(xf_ss)*2-1
    xf_ts  = [xf_ss, xf_ss(end:-1:2)];
else
    keyboard;
end