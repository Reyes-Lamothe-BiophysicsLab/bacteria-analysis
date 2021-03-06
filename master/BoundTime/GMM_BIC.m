
function [BestModel, numComponents_BIC] = GMM_BIC (data, GMM_models_tested)
options = statset('Display','off','MaxIter',10000,'UseParallel',true);
% gm = fitgmdist(intensities_final,2,'Options',options);
%GMM_models_tested = 5;
BIC = zeros(1,GMM_models_tested);
GMModels = cell(1,GMM_models_tested);
for k = 1:GMM_models_tested
    GMModels{k} = fitgmdist(data,k,'Options',options,'Replicates',15,'SharedCovariance', true);
    BIC(k)= GMModels{k}.BIC;
end

[minBIC,numComponents_BIC] = min(BIC);


BestModel = GMModels{numComponents_BIC};
% figure, 
% histogram (data,'BinMethod','fd', 'normalization', 'pdf');
% hold on
% x= [0:0.1:max(data)];
% x = x(:);
% y = pdf(BestModel, x);
% 
% plot(x, y)
% hold off;
end
 
