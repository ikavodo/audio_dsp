function coeffs = make_high_pass(rolloff,cutoff,fs)


% Generate finite-length FIR filter with coefficients dependent on 
% rollout factor rolloff, by windowing and truncating an ideal-lowpass and
% converting to highpass
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUT ARGUMENTS
% rolloff         specifies how steep transition between pass and stop is
% cutoff          cutoff frequency 
% fs              sampling rate

% OUTPUT ARGUMENTS
% coeffs         time-domain filter coefficient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    fc = (fs/2-cutoff)/fs;
    N = ceil((4 / rolloff));
    % make odd (unimportant)
    N = N + ~mod(N,2);
    n = 1:N;
    time_shift = @(n) (n - (N - 1) / 2);
    h = sinc(2 * fc * time_shift(n)).* hann(N)';
    % time_shift(n)?
    coeffs = (h / sum(h)).*cos(pi*n);
end

