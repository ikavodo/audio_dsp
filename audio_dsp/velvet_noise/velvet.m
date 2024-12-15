[y,fs] = audioread("glass.wav");
% samples in frame of Velvet noise
frameSize = 20;
% how dense do we want the noise, within (0,1) range
density = 0.1;
velNoise = generateVelvet(fs,density, frameSize);
% generate noise envelope
wind = hamming(2*length(velNoise));
envelope = wind(length(wind)/2+1:end);
withEnv = velNoise.*envelope;
% convolve each channel
conved = [conv(y(:,1),withEnv),conv(y(:,2),withEnv)];
% has much more echo then input sound!

function noise=generateVelvet(len, density, frameSize)
% generate sparse Velvet noise. Density is between (0,1), corresponds to
% length of samples with value +/-1 within frame
    noise = zeros(len,1);
%     how many samples in a row do we want to receive non-zero value
    densityLength = ceil(density*frameSize);
    for i=1:round(len/frameSize)
        curFrame = (i-1)*frameSize;
%         sample to start noise at
        noiseStart = curFrame + randi([1 frameSize-1]);
%         sample to end noise at in current frame
        noiseEnd = min([noiseStart + densityLength, curFrame + frameSize-1]);
        noise(noiseStart:noiseEnd,1) = coinToss();
    end
end

function prob = coinToss()
% generate randomly +/-1
    prob = 2*(rand(1) <= 0.5) - 1;
end