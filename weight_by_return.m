function [weights,buy,sell] = weight_by_return( portfolio, target_return )
%WEIGHT_BY_RETURN 按照指定的target_return返回资产组合比例
%

  [weights,buy,sell] = estimateFrontierByReturn(portfolio, target_return);

end
