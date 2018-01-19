
lpath = 'mic_response\';
fname = 'audio-technica_AT2010';
[xq, freqResp] = get_frqRsp('lpath',lpath, 'fname',fname,'fig_num',1);

%%
fname = 'audio-technica_AT4060';
[xq, freqResp] = get_frqRsp('lpath',lpath, 'fname',fname,'fig_num',2);


%%
fname = 'audio-technica_ATM33a';
[xq, freqResp] = get_frqRsp('lpath',lpath, 'fname',fname,'fig_num',3);