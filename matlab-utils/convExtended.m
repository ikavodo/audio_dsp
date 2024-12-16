%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%wrapper function to for convolution of matrix (columns) with vector. 
% Same function arguments as in original conv 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = convExtended(A,B, arg)
    if (size(A,2) == 1 && size(B,2) == 1) || (size(A,1) == 1 && size(B,1) == 1)
        result = conv(A,B,arg);
    else 
        s = size(A,1)+size(B,1)-1; 
        result = real(ifft(fft(A,s,1).*fft(B,s,1)));
        if arg=="same"
            middle = 1 + ceil((size(result,1)-size(A,1))/2);
            result = result(middle:middle+ size(A,1)-1,:);
        end
    end
end