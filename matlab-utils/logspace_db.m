function xx = logspace_db(a,b,n,gain)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% implementation of logspace in decibels

% INPUT ARGUMENTS
%a: The starting point of the range in decibels.
%b: The ending point of the range in decibels.
%n: The number of points in the logarithmically spaced sequence.
%gain: A gain value (in dB) added to the starting point, affecting the initial value of the sequence.

% OUTPUT ARGUMENTS
% xx: sequence of n log-increasing values in decibels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    xx = zeros(1,n);
    xx(1) = 10^((a+gain)/20);
    for i=2:n
        xx(i) = xx(i-1)*(10^((((b-a)/20))/(n-1))); %// Change 
    end
end