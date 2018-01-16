function [xq, vq] = get_frqRsp(png_lpath, png_name, fig_num)
if nargin==1
    png_path = png_lpath;
    png_name = png_path;
else
    png_path = [png_lpath, png_name];
end
if nargin<3
    fig_num=1;
end

if exist([png_path, '.jpg'], 'file')
    mic_img = imread([png_path, '.jpg']);
    figure(fig_num); subplot(222); imagesc(mic_img);
    title(png_name);
end
img = imread([png_path, '.png']);
graph = img(:,:,1)-img(:,:,2);
% play(graph==0)
grid_y = img(:,243,1);
grid_x = img(24,:,2);
% play(grid)
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
freqResp  = freqResp_/sz(1)*40-20;
freqRange = logspace(1,4.603,size(freqResp,2));
%%
figure(fig_num);
% subplot(221); imagesc(img(idx1,idx2,:));  colormap gray; title('orig PNG file')
subplot(221); imagesc(img);  colormap gray; title('orig PNG file')
subplot(223); plot(freqResp); axis([0, sz(2), -20, +20]); title('extracted FreqResp');
%%
% figure(3);
% semilogx(freqRange,freqResp); %axis([-fi, sz(2), -20, +20]);

%% interpolation
xq = 10:1:40000;
vq = interp1(freqRange, freqResp,xq,'linear');
figure(fig_num);
subplot(224); semilogx(freqRange,freqResp,'o',xq,vq,':.'); axis([10,40000,-20,20]); grid on; title('interpolated FreqResp')




