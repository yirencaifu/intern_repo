function p = init_portfolio(Y,AssetName,num_dates,initPort)
%INIT_PORTFOLIO
  AssetMean = mean(Y)'; % 平均资产价格回报率
  AssetCovar = corrcoef(Y); % 资产价格协方差矩阵
  if (nargin ==3)
    p = Portfolio('Name', '资产价格', ...
                  'AssetList', AssetName);
  else
    p = Portfolio('Name', '资产价格', ...
                  'AssetList', AssetName, 'InitPort', initPort);
  end

  p = setDefaultConstraints(p);
  p = setAssetMoments(p, AssetMean/num_dates, AssetCovar/num_dates);
  p = estimateAssetMoments(p, Y, 'DataFormat', 'Prices');

  p.AssetMean = num_dates*p.AssetMean;
  p.AssetCovar = num_dates*p.AssetCovar;

end

