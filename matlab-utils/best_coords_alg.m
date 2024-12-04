function [best_coords,metric] = best_coords_alg(num_coords,num_iters, ...
    num_trials,score_func)

% Given initial random coordinates- converge to some best coordinates using
% a binary-search type optimization method and a dictionary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% INPUT ARGUMENTS
% num_coords      number of 3D points necessary for loss function
% num_iters       iterations of algorithm
% num_trials      trial per iteration
% score_func      takes matrix of size (num_coords,3)

% OUTPUT ARGUMENTS
% best_coords     coordinates which got best score
% metric          score of best coords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %use loss values as key
    dict_vals = containers.Map('KeyType','double','ValueType','any');
    % starting vals
    cur_range = 180;
    cur_mat = eye(3);
    coords = rand(num_coords,3);
    for i=1:num_iters
        % binary search idea
        rot_degs = rescale(rand(num_trials,3),-cur_range,cur_range); 
        for j = 1:num_trials
            cur_score = 0;
            % sample a rotation
            rotated_mat = rotate_mat(rot_degs(j,:))*cur_mat;
            rotated_coords = coords*rotated_mat;
            cur_score = cur_score + score_func(rotated_coords);
            dict_vals(cur_score) = rotated_mat;
        end
        % set best coords in this iteration as starting point for next
        key = max(cell2mat(keys(dict_vals)));
        cur_mat = dict_vals(key);
        cur_range = cur_range/2;
    end
    metric = key;
    fprintf("score %.3f\n",metric);
    best_coords = cur_mat;
end
