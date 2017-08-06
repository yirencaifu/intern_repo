% -------------- 进入基本参数设置、数据导入 ----------------------
% 固定收益率
% 出于演示目的，最近不能高于1.025，否则全买固定收益
fixed_return = 1.02;
fixed_name = '宜定赢6月期';
% 选取125天作为时间窗口(滞后期)
num_dates = 125;

% 股票名称，这里需和下面 Y 的顺序一致，第一列是什么，第二列是什么……
% 下面返回的 weights buy sell 顺序和这里一致
% 例如，buy 若为 0 0 1，意味着买入 0% 沪深300、中证500；100% 固收
AssetName = {'沪深300','中证500', fixed_name};

% 导入数据
% FixMe: 生产环境需要封装成函数，这里为了看着明白、
% 改着方便就没封装
% 目前excel文件名里不要有中文，容易出现字符编码错误问题
% 一定要 xlsx 格式，xls 格式Matlab不能读取
[~,txt_3] = xlsread('000961.xlsx');
[~,txt_5] = xlsread('000962.xlsx');
% price_3 沪深300
price_3 = cellfun(@str2num,txt_3(2:end,2));
% price_5 中证500
price_5 = cellfun(@str2num,txt_5(2:end,2));
% 一定注意这里数据和 AssetName 顺序一致
Y = [price_3 price_5];
Y = Y(1:num_dates,:);
Y = [Y linspace(1,fixed_return,num_dates)'];

% -------------- 进入用户相关部分 ----------------------
% 用户输入用户名
username = '测试';

% 加载数据库，并返回是否已经有用户数据
% 查看数据库中是否存在用户数据
% 如果不存在，用户为第一次购买，否则为重复购买
% FixMe: 生产环境需要修改
[ has_user, user_data ] = load_database(username);

% 止损、止盈
low_bound = 0.01; % 止损比例 实际上计算资产组合时没用到
up_bound = 0.02; % 止盈比例

% 开始交易日期:
% 选取距离今天之前多少天进行交易
% 如果start_date = 0 则在今天交易
% 如果start_date = 1 则在昨天交易
% 默认为 0，即在今天交易
start_date = 0;

% -------------- 参数设置结束，开始计算 ----------------------

% 初始化资产组合
if ( has_user )
  p = init_portfolio(Y,AssetName,num_dates,user_data('portfolio_weights'));
else
  p = init_portfolio(Y,AssetName,num_dates);
end

% 获取最小、最大收益，如果最大收益小于固定收益，则为0
minmax_ret = return_minmax(p,fixed_return);

if ( minmax_ret(2) == 0 )
  display('指数最大收益小于固定收益，请全部购买固定收益产品')
  return
  % FixMe: 生产环境需要修改
  % 真正生产环境下需要用exit不能用 return
  % 但是return 会退出matlab不方便展示
  % exit(0);
end

if (up_bound<minmax_ret(2))
  % 获取止盈线所需的资产组合比重
  [weights,buy,sell] = weight_by_return(p,up_bound);
else
  display('止盈线超出所能获得的最高盈利率，止盈无效，请重新输入')
  return
  % FixMe: 生产环境需要修改
  % 真正生产环境下需要用exit不能用 return
  % 但是return 会退出matlab不方便展示
  % exit(0);
end

display(sprintf('        %s      %s      %s', AssetName{:}))
display(sprintf('买入:    %d      %d      %d', buy(:)))
display(sprintf('卖出:    %d      %d      %d', sell(:)))

% -------------- 写入数据库 ----------------------
save_database( username, low_bound, up_bound, weights )
