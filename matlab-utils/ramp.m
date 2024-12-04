function ramped = ramp(signal,block_sz,start,stop)

%ramp beginning and end of a signal
    w  = hann(block_sz);
    ramped = signal;
    ramp_ind_start = start:start+block_sz/2-1;
    ramp_ind_end = stop-block_sz/2+1:stop;
    ramped(ramp_ind_start,:) = ramped(ramp_ind_start,:).*w(1:block_sz/2);
    ramped(ramp_ind_end,:) = ramped(ramp_ind_end,:).*w(block_sz/2+1:end);
end