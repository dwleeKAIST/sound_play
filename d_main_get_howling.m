addpath('bin')
%% load sound source
src    = 'source\harvey_gonads.wav';

lpath = 'mic_response\';
fname = 'audio-technica_AT2010';
% fname = 'audio-technica_ATM33a';

[x_t, fs] = audioread(src);
l_source_ms = 2000;
x_t = x_t(1:ceil(l_source_ms/1000*fs));
ts  = 1/fs;
l_y = size(x_t,1)/fs;
disp(['Sampling rate : ' num2str(fs/1000) 'kHz ( ' num2str(ts*1000) 'ms)'])
t_vec = ts:ts:l_y;
sound(x_t,fs);
%% choose the mic

%% 
[freqRange, freqResp] = get_frqRsp('lpath',lpath, 'fname',fname,'fig_num',1);

delay_ms = 200;
[t_vec_mixed, y_t_mixed ] = mix_with_delay_dt_realtime('x1', x_t, 'fs', fs, 'x2Bdelay', x_t, 'delay_ms', delay_ms, 'freqRange', freqRange, 'freqResp', freqResp); 

% sound(x_t,fs);
sound(y_t_mixed,fs);
audiowrite(['result\howl_mic(' fname ')_delay' num2str(delay_ms) 'ms.wav'],y_t_mixed,fs)
%%
% subplot(222); plot(t_vec1,mixed1); title(['v(t)+v(t-' num2str(delay_ms) ')']);axis([-inf,inf,-2,2])
% sound(mixed1,fs); 
% pause;