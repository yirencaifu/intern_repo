function [] = save_database( username, low_bound, up_bound, weights )
%SAVE_DATABASE Summary of this function goes here
%   Detailed explanation goes here

user_file = containers.Map;
user_data = containers.Map;
user_data('low_bound') = low_bound;
user_data('up_bound') = up_bound;
user_data('portfolio_weights') = weights;
user_file(username) = user_data;

save purchase_record user_file;


end

