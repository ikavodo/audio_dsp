% do some analysis on a non-rescaled sample
function play_no_rescale(filename,resamp_factor)
    [samp,fs] = audioread(sprintf("%s.wav",filename));
    ramp_pos = find(~sum(abs(samp),2),2);
    range = (ramp_pos(1)+1):(ramp_pos(2)-1);
    resampled = resample(samp(range,:),resamp_factor,1);
    scale = [-max(abs(samp),[],"all"),max(abs(samp),[],"all")];
    soundsc(resampled,fs,scale);
end