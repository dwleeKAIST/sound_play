function xf_ts = getTwoSideSpectrum(xf_ss)

% xf_ss_ = xf_ss(1:(end/2+1));
xf_ts  = [xf_ss, xf_ss(end:-1:3)];