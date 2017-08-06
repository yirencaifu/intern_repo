function [has_user,user_data] = load_database(username)
%LOAD_DATABASE Summary of this function goes here
%   Detailed explanation goes here

has_user = 0;
user_data = 0;

% 加载用户数据库
if (exist('purchase_record.mat', 'file'))
  load purchase_record
end

% 查看数据库中是否存在用户数据
% 如果不存在为第一次购买，否则为重复购买
if (exist('user_file','var'))
  has_user = user_file.isKey(username);
  if (has_user)
    user_data = user_file(username);
  end
end

end

