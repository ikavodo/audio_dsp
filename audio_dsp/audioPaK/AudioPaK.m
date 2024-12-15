f = dir('pcm1644m.wav');         
fileSize = f.bytes*8;
% read wav file to uncompressed PCM 16-bit format
fid=fopen('pcm1644m.wav');
data=fread(fid,'int16');
fs=44100;
frameSize = 1152;
% number of frames in signal
framesNum = ceil(length(data)/frameSize);
% keep information about residual chosen to approximate each frame, later
% to be converted into 2 bits
chosenResid = zeros(framesNum,1); 
compressed = '';
% choose random symbols 
stop = '$';
unary = '*';
escape = '\';

for f=1:framesNum
%     per frame
    indices = (f-1)*frameSize + (1:frameSize);
    if indices(end) > length(data)
%         make last frame shorter
        last = find(indices==length(data));
        indices = indices(1:last);
    end
    curFrame = data(indices);
    residsMat = computeResiduals(curFrame);
%     take residual vector with smallest average magnitude
    absMeans = mean(abs(residsMat),1);
    minInd = find(absMeans==min(absMeans));
%     keep information about chosen residual
    chosenResid(f) = minInd(1)-1;
%     code all residual samples with Golomb coding
    coded = golombCode(min(absMeans), residsMat(:,minInd(1)),unary,stop,escape);
%     concatenate to compressed stream
    compressed = strcat(compressed, coded);
end

% convert chosen residual index to 2-bit information- also used for decoding
residsBin = reshape(dec2bin(chosenResid).',1,[]);
% if larger than 1: file has been compressed
compressed_ratio = fileSize/(length(compressed)+length(residsBin));
fprintf("compression ratio of %f\n",compressed_ratio);
C = categorical(chosenResid,[0 1 2 3],{'e_0','e_1','e_2', 'e_3'});
% show histogram of chosen residuals- here mostly e3 was chosen- meaning
% there was very little silent frames. 
h = histogram(C,'BarWidth',0.5);
xlabel('Residuals')
ylabel('Number of frames')
title('Chosen residual count')


function residsMat =computeResiduals (curFrame)
% keep four residual values in matrix for further computation
    residsMat = zeros(length(curFrame),4);
    residsMat(:,1) = curFrame;
%     recursively compute residual of next order
%     equivalent to filter([1,-1],1,x) using no multiplication
    diff = @(x) x - [0; x(1:end-1)];
    residsMat(:,2) = diff(residsMat(:,1));
    residsMat(:,3) = diff(residsMat(:,2));
    residsMat(:,4) = diff(residsMat(:,3));
end

function code = golombCode(expect, residual,unary,stop,escaped)
% Entropy coding- convert each sample in residual signal to Golomb code- 
% which is optimized for exponentially decaying positive integer distributions
    if ~expect
%         silent frame
        code = escaped;
    else
        % M(e[n]) = 2*e[n] if e[n]>=0 else 2*|e[n]|-1, no multiplication!
        mapped = abs(residual+ residual) -(residual<0);
%         estimation of k
        k = ceil(log2(expect));
        binStr = dec2bin(mapped);
%           take k LSBs
        if k>0
            kLSBs = binStr(:,end-k+1:end);
        else
%             use empty string for concatenation
            kLSBs = repmat('',length(binStr),1);
        end
%       unary representation of remaining bits 
        MSBs= repmat(unary,length(binStr),size(binStr,2)-max(0,k));
        stop = repmat(stop,length(binStr),1);
        %             concatenate it all together and flatten
        code = reshape(strcat(kLSBs,MSBs,stop).',1,[]);
    end
end