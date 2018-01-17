addpath('bin')
%% load sound source
src    = 'source\harvey_gonads.wav';

[v, fs] = audioread(src);
v = v(1:end-1);
ts  = 1/fs;
l_y = size(v,1)/fs;
disp(['Sampling rate : ' num2str(fs/1000) 'kHz ( ' num2str(ts*1000) 'ms)'])
t_vec = ts:ts:l_y;

%% choose the mic
lpath = 'mic_response\';
% fname = 'audio-technica_AT2010';
fname = 'audio-technica_ATM33a';
%% P1 : single-sided spectrum 
vf  = fft(v);
[P1, f_vec]      = getSingleSideMagnitudeSpectrum(vf,fs);
[xq, freqResp]   = get_frqRsp('lpath',lpath, 'fname',fname,'fig_num',1, 'f_vec', f_vec);
%%
freqResp_        = freqResp(1:(length(vf)/2+1));
freqResp_ts      = getTwoSideSpectrum(freqResp_);
amplify          = 10.^(freqResp_ts./10)';

% v_amp            = real(ifft2(vf.*amplify));
% sound(y_amp,fs)

%%
% keyboard;
NTimes = [1,5,10,100];
N = length(NTimes)+1; M = 1;
disp_amp = getSingleSideMagnitudeSpectrum(amplify,fs,1);
figure(5); subplot(N,M,1); semilogx(f_vec,disp_amp); title(['Amplifying spectrum of ' fname]); 
hold on; semilogx(f_vec,ones(1,length(disp_amp)),'--r');  hold off;
figure(6); subplot(N,M,1); plot(t_vec,v); title('Original source, v(t)');
for iN=1:length(NTimes)
    nRep = NTimes(iN);
    yf_amp = vf.*amplify.^(nRep);
    P1_ampN = real(ifft(yf_amp));

    sound(P1_ampN,fs);
    figure(5); subplot(N,M,iN+1); semilogx(f_vec, getSingleSideMagnitudeSpectrum(yf_amp,fs));  title(['amplitude spectrum (after mic ' num2str(nRep) ' times)']); ylabel('|Y(f)|'); axis([0,22300,0,inf]);
    figure(6); subplot(N,M,iN+1); plot(t_vec,P1_ampN); title(['y_{' num2str(iN) '}(t) (after mic ' num2str(nRep) ' times)']);
%     pause(l_y);
%     audiowrite(['result\mic(' fname ')_' num2str(nRep) 'times.wav'],P1_ampN,fs); keyboard;
end
figure(5); xlabel('f(Hz)'); figure(6); xlabel('time (sec)');