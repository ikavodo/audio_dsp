fs = 48000;
buffSize = 200;
% f0 will be 48000/200 = 240 Hz
f0 = fs/buffSize;
delay = dsp.Delay(buffSize);
sampSize = 2*fs;

inp = zeros(sampSize,1);
% initial white noise for Karplus strong, and then padded zeros 
noise = rand(buffSize,1);
inp(1:buffSize,:)=noise;

% moving average filter coeffs
windowSize = 3; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;

% initialize length of output
output = zeros(sampSize,1);

% divide into blocks for processing
blocks = sampSize/buffSize;
% feedback value
buffer = zeros(buffSize,1);
for it_block=1:blocks
%     processing
    block_index = (it_block-1)*buffSize + (1:buffSize);
%     feedback component
    delayed = delay(buffer);
    filted = filter(b,a,delayed);
    output(block_index,:) = filted + inp(block_index,:);
%     update buffer value to previous output
    buffer = output(block_index,:);
end
g=0.3;
soundsc(g*output,fs);
figure();
time = 0:1/fs:2-1/fs;
plot(time,output);
xlabel("seconds");
ylabel("magnitude");
title(sprintf("Karplus strong algorithm: windowSize = %d, f0= %d",windowSize,f0));