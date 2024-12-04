function coeffs = make_low_pass(rolloff,cutoff,fs)

% Generate finite-length FIR filter with coefficients dependent on 
% rollout factor rolloff, by windowing and truncating an ideal-lowpass
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUT ARGUMENTS
% rolloff         specifies how steep transition between pass and stop is
% cutoff          cutoff frequency 
% fs              sampling rate

% OUTPUT ARGUMENTS
% coeffs         time-domain filter coefficient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fc = cutoff/fs;
    N = ceil((4 / rolloff));
    % make odd
    N = N + ~mod(N,2);
    n = 1:N;
    time_shift = @(n) (n - (N - 1) / 2);
    h = sinc(2 * fc * time_shift(n)).* hann(N)';
    coeffs = (h / sum(h));
end