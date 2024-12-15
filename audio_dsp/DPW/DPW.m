F = 400;
fs = 44100;
t = 0:1/fs:1-1/fs;
x = sawtooth(2*pi*50*t);
% x is a pure sawtooth wave, has aliasing effects (because has infinite
% harmonic content-> requires infinite sampling rate) 
% make listening to it bearable
g=0.5;
% soundsc(x*g,fs);

% show frequency spectrum representation of signal
[f, P1] = freqSpect(x,fs);
figure(1)
plot(f,P1) 
title("Geometric sawtooth frequency spectrum")
xlabel("f (Hz)")
ylabel("Magnitude")

% lowpass, pretend signal was sampled with "infinite" sample rate, take
% Nyquist as passband 
lowPassed = lowpass(x,fs/2,intmax);
[f, P2] = freqSpect(lowPassed,fs);
% doesn't sound so convincing
% soundsc(lowPassed*g,fs);

figure(2)
plot(f,P2) 
title("lowpassed sawtooth frequency spectrum")
xlabel("f (Hz)")
ylabel("Magnitude")

% find residual 
r = P1-P2;

fprintf("%.1f percent of signal's energy lies in harmonic components " + ...
    "above Nyquist",100*sum(r)/sum(P1));

% DPW
dpw = DPW(x);
[f, P3] = freqSpect(dpw,fs);
% sounds much better than lowpass!
% soundsc(dpw*g,fs);

figure(3)
plot(f,P3) 
% looks very very similar to original sawtooth!

title("DPW frequency spectrum")
xlabel("f (Hz)")
ylabel("Magnitude")

function [f, P1]= freqSpect(x, fs)
% frequency spectrum representation of signal
    L= length(x);
    Y = fft(x);
    P2 = abs(Y/L);
    % one sided spectrum
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = fs*(0:(L/2))/L;
end

function diff = DPW(x)
% DPW anti-aliasing algorithm
    diff = zeros(1,length(x));
    parab = x.^2;
%     numerical differentiation approximation
    for i=2:length(x)
        diff(i) = parab(i)-parab(i-1);
    end
end