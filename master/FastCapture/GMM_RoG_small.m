
function [DataInx,BestModel] = GMM_RoG_small(data,GMM_models_tested)
options = statset('Display','off','MaxIter',10000,'UseParallel',true);
BIC = zeros(1,GMM_models_tested);
GMModels = cell(1,GMM_models_tested);
for k = 1:GMM_models_tested
    GMModels{k} = fitgmdist(data,k,'Options',options,'Replicates',15,'SharedCovariance', true);
    BIC(k)= GMModels{k}.BIC;
end

[~,numComponents_BIC] = min(BIC);


BestModel = GMModels{numComponents_BIC};
c=BestModel.ComponentProportion.';
cc= [BestModel.mu c];
cc=sortrows(cc);
cc=cc(1,2);
ccc= cc(1)*100;
ccc= string(ccc);
bbb= "Bound Proportion = ";
aaa = bbb + ccc + " %";
% return the index of the tracks 
[idx,~] = cluster(BestModel,data);
DataInx = [data,idx];
figure 
histogram (data,'BinWidth',0.5,'Normalization','pdf','BinLimits',[-10,4])
hold on
%ylim([0 0.5])
x= [min(data):0.1:max(data)];
x = x(:);
y = pdf(BestModel, x);
plot(x, y)
title('GMM Fit of Log of Apparent Radius of Gyration of Small Cells')
legend(aaa,'Location','northwest')
hold off;
end