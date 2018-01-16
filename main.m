addpath('bin')
%%
src    = 'source\harvey_gonads.wav';
%src    = 'source\eastwood_lawyers.wav';
[y, fs] = audioread(src);
ts  = 1/fs;
l_y = size(y,1)/fs;
disp(['Sampling rate : ' num2str(fs/1000) 'kHz ( ' num2str(ts*1000) 'ms)'])
t_vec = ts:ts:l_y;

%% v(t)
figure(1); 
subplot(221); plot(t_vec,y); title('v(t)'); axis([-inf,inf,-2,2])
sound(y,fs);
pause;

%% simulation for v(t) + v(t+dt)
delay_ms = 10;
[mixed1,t_vec1] = mix_with_delay_dt( y, fs, y, delay_ms ); 
subplot(222); plot(t_vec1,mixed1); title(['v(t)+v(t-' num2str(delay_ms) ')']);axis([-inf,inf,-2,2])
sound(mixed1,fs); 
pause;

%%  v(t) + v'(t+dt)
[mixed2,t_vec2] = mix_with_delay_dt( y, fs, -y, delay_ms ); 
subplot(223); plot(t_vec2,mixed2); title(['v(t)-v(t-' num2str(delay_ms) ')']);axis([-inf,inf,-2,2])
sound(mixed2,fs); 
pause;

%% this is the simulation for v(t) + v'(t_dt) + v(t-dt2)
delay1 = 5;
delay2 = 10;
[mixed3,t_vec3] = mix_with_delay_dt( y, fs, y, delay1 );
[mixed4,t_vec4] = mix_with_delay_dt( mixed3, fs, -y, delay2,1 );
subplot(224); plot(t_vec4,mixed4); title(['v(t)+v(t-' num2str(delay1) ')-v(t-' num2str(delay2) ')']);axis([-inf,inf,-2,2])
sound(mixed2,fs); 

%% 
if ~exist('result')
    mkdir('result')
end
audiowrite(['result/mix_' num2str(delay1) 'ms_' num2str(delay2) 'ms.wav'],mixed4,fs)
