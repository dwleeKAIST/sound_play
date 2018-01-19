addpath('bin')
%% load sound source
src    = 'source\harvey_gonads.wav';

[x_t, fs] = audioread(src);
x_t = x_t(1:end-1);
ts  = 1/fs;
l_y = size(x_t,1)/fs;
disp(['Sampling rate : ' num2str(fs/1000) 'kHz ( ' num2str(ts*1000) 'ms)'])
t_vec = ts:ts:l_y;

%% choose the mic
lpath = 'mic_response\';
% fname = 'audio-technica_AT2010';
fname = 'audio-technica_ATM33a';
%% P1 : single-sided spectrum 
vf     = fft(x_t);
P1     = getSingleSideMagnitudeSpectrum(vf);
L      = length(vf);
f_min  = 10;
f_max  = 40000;
f_step = 1;
f_vec  = fs*(0:(L/2))/L;
[freqRange, freqResp] = get_frqRsp('lpath',lpath, 'fname',fname,'fig_num',1);
[      y_t,  amplify_ts] = applyFreqResp(x_t, fs, freqResp, freqRange);
% sound(x_t,fs);
% sound(y_t,fs);
%%
NTimes = [1,5,10,100];
amp_ss = getSingleSideMagnitudeSpectrum(amplify_ts,1);
figure(4); plot(f_vec,amp_ss); title(['Amplifying spectrum of ' fname]); hold on; plot(f_vec,ones(1,length(amp_ss)),'--r');  hold off;
N = length(NTimes)+1; M = 1;
figure(5); subplot(N,M,1); plot(t_vec,x_t); title('Original source, v(t)');
figure(6); subplot(N,M,1); plot(f_vec,getSingleSideMagnitudeSpectrum(fft(x_t))); title('Original source, v(f)');
for iN=1:length(NTimes)
    nRep    = NTimes(iN);
    [y_t_ampN,~] = applyFreqResp(x_t, fs, freqResp, freqRange, nRep);

%     sound(y_t_ampN,fs);
    figure(5); subplot(N,M,iN+1); plot(t_vec,y_t_ampN); title(['y_{' num2str(iN) '}(t) (after mic ' num2str(nRep) ' times)']);
    figure(6); subplot(N,M,iN+1); semilogx(f_vec, getSingleSideMagnitudeSpectrum(fft(y_t_ampN),fs));  title(['amplitude spectrum (after mic ' num2str(nRep) ' times)']); ylabel('|Y(f)|'); axis([0,22300,0,inf]);
%     pause(l_y);
%     audiowrite(['result\mic(' fname ')_' num2str(nRep) 'times.wav'],P1_ampN,fs); keyboard;
end
figure(5); xlabel('time (sec)'); figure(6); xlabel('f(Hz)'); 