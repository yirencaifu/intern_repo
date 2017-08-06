function [ ret_minmax ] = return_minmax( portfolio, fixed_return)
%返回马克维茨组合可选的最小、最大收益率，如果小于固定收益产品则
%都设为0

pret = estimatePortReturn(portfolio, portfolio.estimateFrontierLimits);

if ( pret(2) <= fixed_return-1 )
  ret_minmax = [0,0];
else
  ret_minmax = pret;
end

end
