function M=haar(N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generate Haar matrix of size (2^N)x(2^N)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    v = log2(N)-1;
    if v<0
        fprintf('%d must be 2 or larger',N);
        M = nan;
    else
        if floor(v)~=v 
            fprintf('%d is not a power of 2, returning N=%d',N,2^ceil(v+1));
        end
        %   recursive helper
        M=helper(ceil(v));
    end
end

function M=helper(v) 
    if v==0
%         base case
        M=[1 1; 1 -1];
    else
        M = [kron(helper(v-1),[1 1]); kron(2^(v/2)*eye(2^v),[1 -1])];
    end
end