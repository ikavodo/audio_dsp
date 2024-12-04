function original_indices = map_flattened_index_to_3d(i, matrix_shape)
    % Map a flattened index to the original 3D matrix indices.
    % Inputs:
    %   i: Flattened index in 1D array.
    %   matrix_shape: Shape of the original 3D matrix in the form [x, y, z].
    % Output:
    %   original_indices: Original indices (x, y, z) corresponding to the flattened index i.

    x_size = matrix_shape(1);
    y_size = matrix_shape(2);

    z = fix(i / (x_size * y_size)) + 1;
    i = i - (z - 1) * (x_size * y_size);
    y = fix(i / x_size) + 1;
    x = mod(i, x_size) + 1;

    original_indices = [x, y, z];
end