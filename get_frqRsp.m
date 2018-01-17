function [xq, vq] = get_frqRsp(varargin)
ai      = 1; params  = {}; values  = {};
while ai <= length(varargin)
    params{end + 1}     = varargin{ai}; ai = ai + 1;
    values{end + 1}     = varargin{ai}; ai = ai + 1;
end
%% default
lpath  = 'mic_response\';
fname  =  'unknown';
fig_num   = 1;
f_min = 10;
f_max = 40000;
f_step = 1;
for i = 1:length(params)
    switch params{i}
        case 'lpath';   lpath    = values{i};
        case 'fname';   fname    = values{i};
        case 'fig_num'; fig_num  = values{i};
        case 'f_vec';   f_vec       = values{i};
            f_min = min(f_min, f_vec(1));
            f_max = max(f_max, f_vec(end));
            f_step = f_vec(end)-f_vec(end-1);
    end
end
%%
png_path = [lpath, fname];

if exist([png_path, '.jpg'], 'file')
    mic_img = imread([png_path, '.jpg']);
    figure(fig_num); subplot(222); imagesc(mic_img);
    title(fname);
end
img = imread([png_path, '.png']);
graph = img(:,:,1)-img(:,:,2);
%%
grid_y = img(:,243,1);
grid_x = img(24,:,2);
min_max = find(grid_y(:)==0);
min_max_x = find(grid_x(:)<255);
idx1 = min_max(1):min_max(end);
idx2 = min_max_x(1):min_max_x(end);
%%
graph_  = graph(idx1,idx2);
graph_mask = (graph_>0);
%%
sz = size(graph_);
[~,Y ] = meshgrid(1:sz(2),1:sz(1));
freqResp_ = sz(1) - sum(Y.*graph_mask,1)./sum(graph_mask,1);
% freqResp_(isnan(freqResp_(:)))=0;
freqResp  = freqResp_/sz(1)*40-20;
freqRange = logspace(1,4.603,size(freqResp,2));
%%
figure(fig_num);
% subplot(221); imagesc(img(idx1,idx2,:));  colormap gray; title('orig PNG file')
subplot(221); imagesc(img);  colormap gray; title('orig PNG file')
subplot(223); plot(freqResp); axis([0, sz(2), -20, +20]); title('extracted FreqResp');


%% interpolation
xq = f_min:f_step:f_max;
vq = interp1(freqRange, freqResp,xq,'linear');
vq(isnan(vq(:)))=-20;
% vq(isnan(vq(:)))=0;
figure(fig_num);
subplot(224); semilogx(freqRange,freqResp,'o',xq,vq,':.'); grid on; title('interpolated FreqResp'); axis([f_min,f_max,-20,20]); 




