%sample rate
fs = 44100;
%crossover points, used to get a wide-range, leading to a noticeable 
% difference when filtering with different gain values
fLow = 500;
fHigh = 5000;
%file to equalize (not actually- it's to create 'bumps')
[sig,fsig] = audioread('drums.mp3',[1,3*fs]);
sig = resample(sig,fs,fsig);
%compute three different cascade behaviors, depending on gain constraints
%on the two shelve filters
[bLow,aLow] = plotEqualizer(fLow,db2mag(12),fHigh,db2mag(-12),fs,'2-band EQ, GLP=12dB, GHP=-12dB');
[bHigh,aHigh] = plotEqualizer(fLow,db2mag(-12),fHigh,db2mag(12),fs,'2-band EQ, GLP=-12dB, GHP=12dB');
%for this one we don't keep the coefficients because we won't use it to
%filter, only plot its magnitude response
[~,~] = plotEqualizer(fLow,db2mag(-12),fHigh,db2mag(-12),fs,'2-band EQ, GLP=-12dB, GHP= -12dB');

%filter first three secs of a drum sample with the high-pass EQ and the
%low-pass 
filted = filter(bLow,aLow,sig);
audiowrite('drum_Low.wav',rescale(filted,-1,1),fsig);
filted = filter(bHigh,aHigh,sig);
audiowrite('drum_Hi.wav',rescale(filted,-1,1),fsig);


function [b,a] = firstOrderLowShelf(fc,G,fs)
% calculate first-order low shelf coeffs given center frequency,  gain at H(0), sampling rate 
    a = [tan(pi*fc/fs) + sqrt(G), tan(pi*fc/fs) - sqrt(G)];
    b = [G*tan(pi*fc/fs) + sqrt(G), G*tan(pi*fc/fs) - sqrt(G)];
end

function [b,a] = firstOrderHighShelf(fc,G,fs)
% calculate first-order high shelf coeffs given center frequency, gain at H(1), sampling rate 
    a = [sqrt(G)*tan(pi*fc/fs) + 1, sqrt(G)*tan(pi*fc/fs) - 1];
    b = [sqrt(G)*tan(pi*fc/fs) + G, sqrt(G)*tan(pi*fc/fs) - G];
end

function [bCasc,aCasc] = plotEqualizer(fLow,GLow,fHigh,GHigh,fs,plotTitle)
%return coefficients for EQ filter (cascaded shelves), plot the magnitude
%response of both shelves and the EQ
    [bLow,aLow] = firstOrderLowShelf(fLow,GLow,fs);
    [bHigh,aHigh] = firstOrderHighShelf(fHigh,GHigh,fs);
    [hLow,w] = freqz(bLow,aLow);
    dBLow = mag2db(abs(hLow));
    %for plotting
    [hHigh,~] = freqz(bHigh,aHigh);
    dBHigh = mag2db(abs(hHigh));

    %cascaded filter magnitude response is equivalent to multiplying the gains of
    %the two shelf magnitude responses
    hCasc = hLow.*hHigh;
    dBcasc = mag2db(abs(hCasc));
    %compute b,a coefficients for filtering later
    bCasc = conv(bLow,bHigh);
    aCasc = conv(aLow,aHigh);
    figure();
    hold on 
    %plot only until Nyquist
    nyq_ind = find(w*fs/pi >= fs/2, 1 );
    semilogx(w(1:nyq_ind)*fs/pi,dBLow(1:nyq_ind));
    semilogx(w(1:nyq_ind)*fs/pi,dBHigh(1:nyq_ind));
    semilogx(w(1:nyq_ind)*fs/pi,dBcasc(1:nyq_ind));
    xline(fLow,'--',{'Low','Crossover'});
    xline(fHigh,'--',{'High','Crossover'});
    xlabel('Hz');
    ylabel('Magnitude (dB)');
    legend('low first-order shelf', 'high first-order shelf', 'cascaded');
    title(plotTitle);
end