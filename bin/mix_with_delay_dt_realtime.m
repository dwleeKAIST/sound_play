function [mixed_out,t_vec] = mix_with_delay_dt_realtime( x1, fs, x2Bdelay,  delay_ms, doClamp)
assert(delay_ms>0,'delay should be positive')
if nargin<5
    doClamp=0;
end

%%
l_x1 = length(x1);
l_x2 = length(x2Bdelay);
N_delay  = ceil(delay_ms/1000*fs); 
%% 
if l_x1<l_x2+N_delay
    % if
    % (---------x1-------)
    % (delay)(------------x2-------)
    l_out = l_x2+N_delay;
else
    % else
    % (-------------------x1------------)
    % (delay)(------------x2-------)
    l_out = l_x1;
end

mixed_out = zeros(l_out,1);
mixed_out(1:l_x1) = x1(:);
mixed_out(N_delay+1:N_delay+l_x2) = mixed_out(N_delay+1:N_delay+l_x2)+x2Bdelay(:);
t_vec = (1:l_out)*(1/fs);
if doClamp
    mixed_out(mixed_out(:)>1)=1;
    mixed_out(mixed_out(:)<-1)=-1;
end

if (l_x2-l_x1)<l_x1
    [mixed_out, t_vec] = mix_with_delay_dt_realtime(x1,fs, mixed_out, delay_ms);
end



