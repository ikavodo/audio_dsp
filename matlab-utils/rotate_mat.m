function rotation = rotate_mat(degs)
    roty = @(deg) [cos(deg2rad(deg)) 0 sin(deg2rad(deg)); 0 1 0; -sin(deg2rad(deg)) 0 cos(deg2rad(deg))];
    rotx = @(deg) [1 0 0; 0 cos(deg2rad(deg)) -sin(deg2rad(deg)); 0 sin(deg2rad(deg)) cos(deg2rad(deg))];
    rotz = @(deg) [cos(deg2rad(deg)) -sin(deg2rad(deg)) 0; sin(deg2rad(deg)) cos(deg2rad(deg)) 0; 0 0 1];
    rotation = rotz(degs(3))*roty(degs(2))*rotx(degs(1));
end