%helper for sampling some num of samples from existing channels of signal
function bootstrapped = bootstrap(in_channels, num_samples)
    X = randi(size(in_channels, 2), size(in_channels, 1), num_samples);
    indices = sub2ind(size(in_channels), repmat(1:size(in_channels, 1), num_samples, 1)', X);
    bootstrapped = in_channels(indices);
end