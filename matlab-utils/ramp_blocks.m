function ramped = ramp_blocks(signal,block_sz,indice_dict)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ramp in blocks of a signal at indices of choice using an overlap add
% INPUT ARGUMENTS
%signal
%block_sz for windowing
%indice_dict: values should be between [1,length(signal)]
% OUTPUT ARGUMENTS
% ramped: only blocks of signal which contain the given indices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    w  = repmat(hann(block_sz),1,size(signal,2));
    overlap = block_sz/2;
    winNum = ceil(length(signal) / overlap);
    ramped = zeros((winNum+1)*overlap,2);
    for i=0:winNum-1
        flag=false;
        curPos = i*overlap;
        range = curPos+1:curPos+block_sz;
        if any(ismember(indice_dict,range))
            % there is index in current window
            flag=true;
        end
        sampls = signal(curPos+1:min(size(signal),range(end)),:);
        if(size(sampls,1) ~= block_sz)
%         pad last window with zeros
            sampls = [sampls;zeros(block_sz-size(sampls,1),size(signal,2))];
        end
        ramped(range,:) = ramped(range,:) + flag*w.*sampls;
    end
end