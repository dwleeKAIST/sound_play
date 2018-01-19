function [y_t, amplify]  = applyFreqResp(x_t, fs, freqResp, freqRange, varargin)
ai      = 1; params  = {}; values  = {};
while ai <= length(varargin)
    params{end + 1}     = varargin{ai}; ai = ai + 1;
    values{end + 1}     = varargin{ai}; ai = ai + 1;
end
%% default
nRep     = 1;
for i = 1:length(params)
    switch params{i}
        case 'nRep'; nRep = values{i};
    end
end
%%
x_f          = fft(x_t);
L            = length(x_f);
f_vec        = fs*(0:(L/2))/L;
if f_vec(end)>40000
    keyboard;
end
%% interpolation
vq               = interp1(freqRange, freqResp, f_vec,'linear');
vq(isnan(vq(:))) = -20;
freqResp_ts      = getTwoSideSpectrum(vq, L);

%%
amplify          = 10.^(freqResp_ts./10)';
% figure(3); subplot(211); plot(abs(x_f));
% subplot(212); plot(amplify);

y_f       = x_f.*amplify.^(nRep);

y_t       = real(ifft(y_f));

