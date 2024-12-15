
[y,fs] = audioread("BachInvention1.mp3");
% take first bar in the piece
y = y(2*fs:6*fs);
% window size corresponds to 40ms of samples- allow some time-error deviation
winSize = fs/25;
%75 percent overlap
hopSize = winSize / 4;
% compute short time fourier transform with Hamming windows of specified
% size and overlap
[s,f,t] = stft(y,fs,Window=hamming(winSize),OverlapLength=winSize-hopSize,FFTLength=fs/2);
figure(1)
stft(y,fs,Window=hamming(winSize),OverlapLength=winSize-hopSize,FFTLength=fs/2);title("stft")

% run algorithms!
SFonsets = SF(s);
% keep differences vector to use in CD
[PDonsets,differences] = PD(s);
[WPDonsets,~] = WPD(s);
[NWPDonsets,~] = NWPD(s);
CDonsets = CD(s,differences);
RCDonsets = RCD(s,differences);
% plot results of onset algorithms
x = 1:size(s,2);

figure(2);
subplot(2,3,1)
plot(x,SFonsets)
xlabel("Frames")
title('Subplot 1: SF')

subplot(2,3,2)
plot(x,PDonsets)
xlabel("Frames")
title('Subplot 2: PD')

subplot(2,3,3)
plot(x,WPDonsets)
xlabel("Frames")
title('Subplot 3: WPD')

subplot(2,3,4)
plot(x,NWPDonsets)
xlabel("Frames")
title('Subplot 4: NWPD')

subplot(2,3,5)
plot(x,CDonsets)
xlabel("Frames")
title('Subplot 5: CD')

subplot(2,3,6)
plot(x,RCDonsets)
xlabel("Frames")
title('Subplot 6: RCD')

% set values for peak-picking algorithm
w=3;
m=3;
alpha=0.9;

% set individual threshold parameters
lambda=300;
SFpeaks=peakPicking(SFonsets,w,m,alpha,lambda);

lambda=0.7;
PDpeaks= peakPicking(PDonsets,w,m,alpha,lambda);

lambda=0.4;
WPDpeaks= peakPicking(WPDonsets,w,m,alpha,lambda);

lambda=0.25;
NWPDpeaks= peakPicking(NWPDonsets,w,m,alpha,lambda);

lambda=5e5;
CDpeaks= peakPicking(CDonsets,w,m,alpha,lambda);

lambda=3e5;
RCDpeaks= peakPicking(RCDonsets,w,m,alpha,lambda);


figure(3);
% plot final result in seconds- notice SF and CD seem to work well!
subplot(2,3,1)
plot(x*hopSize/fs,SFpeaks)
xlabel("seconds")
ylabel("onsets")
title('Subplot 1: SFpeaks')

subplot(2,3,2)
plot(x*hopSize/fs,PDpeaks)
ylabel("onsets")
xlabel("seconds")
title('Subplot 2: PDpeaks')

subplot(2,3,3)
plot(x*hopSize/fs,WPDpeaks)
ylabel("onsets")
xlabel("seconds")
title('Subplot 3: WPDpeaks')

subplot(2,3,4)
plot(x*hopSize/fs,NWPDpeaks)
ylabel("onsets")
xlabel("seconds")
title('Subplot 4: NWPDpeaks')

subplot(2,3,5)
plot(x*hopSize/fs,CDpeaks)
ylabel("onsets")
xlabel("seconds")
title('Subplot 5: CDpeaks')

subplot(2,3,6)
plot(x*hopSize/fs,RCDpeaks)
ylabel("onsets")
xlabel("seconds")
title('Subplot 6: RCDpeaks')

% spectral flux algorithm
function spectFlux= SF(frames)
    spectFlux = zeros(1,size(frames,2));
    for i=2:size(frames,2)
%         take energy difference between consecutive frames
        cur = imag(frames(:,i));
        prev = abs(frames(:,i-1));
%         sum rectified differences for final result
        spectFlux(i) = sum(max(cur-prev,0));
    end
end

% phase deviation algorithm
function [phaseDev, differences]= PD(frames)
    differences = zeros(size(frames));
    phaseDev = zeros(1,size(frames,2));
    for i=2:size(frames,2)
%         compute instantaneous frequency
        differences(:,i) = angle(frames(:,i)) - angle(frames(:,i-1));
    end
    for i=2:size(frames,2)
%         instantaneous frequency differences
        diffDiffs = differences(:,i) - differences(:,i-1);
        phaseDev(i) = mean(abs(diffDiffs));
    end
end

function [phaseDev, diffs] = WPD(frames)
% weighted phase deviation algorithm
    diffs = zeros(size(frames));
    phaseDev = zeros(1,size(frames,2));
    for i=2:size(frames,2)
        diffs(:,i) = angle(frames(:,i)) - angle(frames(:,i-1));
    end
    for i=2:size(frames,2)
        diffDiffs = diffs(:,i) - diffs(:,i-1);
        %         weight by bin energy
        phaseDev(i) = mean(abs(frames(:,i).*diffDiffs));
    end
end

function [phaseDev, diffs]= NWPD(frames)
% normalized weighted phase deviation algorithm
    diffs = zeros(size(frames));
    phaseDev = zeros(1,size(frames,2));
    for i=2:size(frames,2)
        diffs(:,i) = angle(frames(:,i)) - angle(frames(:,i-1));
    end
    for i=2:size(frames,2)
        diffDiffs = diffs(:,i) - diffs(:,i-1);
%         weight by bin magnitude, normalize
        phaseDev(i) = sum(abs(frames(:,i).*diffDiffs))/sum(abs(frames(:,i)));
    end
end

function complexDiffs= CD(frames,diffs)
% complex domain algorithm
    complexDiffs = zeros(1,size(frames,2));
    for i=2:size(frames,2)
%         notice that for i = 2 we get diffs(:,1) = 0
% build expected frame components
        X_T= abs(frames(:,i-1)).*exp(angle(frames(:,i-1)) + diffs(:,i-1));
%         take difference and sum
        complexDiffs(i) = sum(abs(frames(:,i)-X_T));
    end
end

function complexDiffs= RCD(frames,diffs)
% rectified complex domain algorithm

    complexDiffs = zeros(1,size(frames,2));
    for i=2:size(frames,2)
%         notice that for i = 2 we get diffs(:,1) = 0
        X_T= abs(frames(:,i-1)).*exp(angle(frames(:,i-1)) + diffs(:,i-1));
        % take difference only for bins in which current frame has energy increase
%         from previous one

        RCD = abs(frames(:,i)-X_T) .* (abs(frames(:,i)) >= abs(frames(:,i-1)));
        complexDiffs(i) = sum(RCD);
    end
end

function peaks = peakPicking(signal,w,m,alpha,lambda)
% peak picking algorithm
    peaks = zeros(size(signal));
    g_alpha = 0;
    for i= 1+ m*w:size(signal,2)- w 
%         given frame is an onset if fulfills three conditions
        if signal(i) >= signal(i-w:i+w) 
            if signal(i) >= (mean(signal(i-m*w:i+w)) + lambda) 
                if signal(i)>=g_alpha
                    peaks(i) = 1;
                end
            end
        end
        %update g_alpha
        g_alpha = max([signal(i),alpha*g_alpha + (1-alpha)*signal(i)]);
    end
end


