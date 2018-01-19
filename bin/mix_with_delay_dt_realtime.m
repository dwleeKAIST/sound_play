function [t_vec_out, mixed_out] = mix_with_delay_dt_realtime( varargin )
ai      = 1; params  = {}; values  = {};
while ai <= length(varargin)
    params{end + 1}     = varargin{ai}; ai = ai + 1;
    values{end + 1}     = varargin{ai}; ai = ai + 1;
end
%% default
p.x1       = [];
p.fs       = 11127;
p.x2Bdelay = [];
p.delay_ms = 10;
p.doClamp  = 0;
p.freqRange = [];
p.freqResp  = [];
p.doNorm    = 0;
for i = 1:length(params)
    switch params{i}
        case 'x1'; p.x1 = values{i};
        case 'x2Bdelay'; p.x2Bdelay = values{i};
        case 'fs';   p.fs    = values{i};
        case 'delay_ms';   p.delay_ms    = values{i};
            assert(p.delay_ms>0,'delay should be positive')
        case 'doClamp'; p.doClamp  = values{i};
        case 'freqResp'; p.freqResp = values{i};
        case 'freqRange'; p.freqRange = values{i};
        case 'doNorm'; p.doNorm = values{i};
        case 'params'; p = values{i};
    end
end
%%
l_x1 = length(p.x1);
l_x2 = length(p.x2Bdelay);
N_delay  = ceil(p.delay_ms/1000*p.fs); 
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

%%

mixed_out = zeros(l_out,1);
mixed_out(1:l_x1) = p.x1(:);
[y_t,~] = applyFreqResp(p.x2Bdelay, p.fs, p.freqResp, p.freqRange);
mixed_out(N_delay+1:N_delay+l_x2) = mixed_out(N_delay+1:N_delay+l_x2)+y_t(:);

t_vec_out = (1:l_out)*(1/p.fs);
if p.doClamp
    mixed_out(mixed_out(:)>1)=1;
    mixed_out(mixed_out(:)<-1)=-1;
end


if (l_x2-l_x1)<l_x1
    p.x2Bdelay = mixed_out;
    [t_vec_out, mixed_out ] = mix_with_delay_dt_realtime('params',p);
end

if p.doNorm
    keyboard;
    scale = sqrt(sum(abs(p.x2Bdelay(:)).^2)/sum(abs(mixed_out(:)).^2));
    mixed_out   = mixed_out.*scale;
end


