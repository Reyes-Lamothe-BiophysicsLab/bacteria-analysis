% MSD method
function [track_D,opt,displace_3] = MSD_cal_LocError(data,dT,meth,pixel)
%input trajectories 
if meth == 1 % MSD 
data = data * pixel;
    max_tau = round(length(data));
msd = zeros(max_tau,1);

%%
for i = 1:max_tau
    msd_sing = 0;
    for j = 1:length(data)-i
        msd_sing = msd_sing + diSt(data(j,1),data(j,2),data(j+i,1),data(j+i,2)).^2;
        x_displace=data(j+1,1)-data(j,1);
        y_displace=data(j+1,2)-data(j,2);
        r_displace=sqrt(x_displace^2 + y_displace^2);
        displace_3(j,1)=r_displace;
    end
    if j == []
        continue 
    elseif j > 0
        if msd_sing ==0
        msd(i) = msd_sing;
        w(i) = j;
        continue
        else
        msd(i) = msd_sing/j;
        w(i) = j;
        end
    end
end
%%
w2= sum(w);
w=w/w2;
%msd(msd==0) = [];
tau = [1:max_tau]';
tau = tau * dT;
tau(end)=[];
msd(end)=[];
%%
x0 = [1,0.5,0.03];
lb=[0,0,0];
ub=[15,2,0.5];
myfittype = fittype(@(d,a,sig,tau) (4.*d.*tau.^a+4.*sig.^2),'coefficients',{'d','a','sig'},'independent','tau','dependent','msd');
opt = fitoptions(myfittype);
%opt.Algorithm = 'Gauss-Newton';
opt.MaxIter = 1000;
opt.MaxFunEvals = 1000;
opt.Lower = lb;
opt.Upper = ub;
opt.StartPoint = x0;
opt.Weights = w;
[x,y]=fit(tau,msd,myfittype,opt);
track_d = y.rsquare;
track_d1 = coeffvalues(x);
track_D = [track_d1 track_d];
clear w
end
if meth == 2
   data = data * pixel;
    max_tau = round(length(data));
msd = zeros(max_tau,1);

%%
for i = 1:max_tau
    msd_sing = 0;
    for j = 1:length(data)-i
        msd_sing = msd_sing + diSt(data(j,1),data(j,2),data(j+i,1),data(j+i,2)).^2;
        x_displace=data(j+1,1)-data(j,1);
        y_displace=data(j+1,2)-data(j,2);
        r_displace=sqrt(x_displace^2 + y_displace^2);
        displace_3(j,1)=r_displace;
    end
    if j == []
        continue 
    elseif j > 0
        if msd_sing ==0
        msd(i) = msd_sing;
        w(i) = j;
        continue
        else
        msd(i) = msd_sing/j;
        w(i) = j;
        end
    end
end
%%
w2= sum(w);
w=w/w2;
%msd(msd==0) = [];
tau = [1:max_tau]';
tau = tau * dT;
tau(end)=[];
msd(end)=[];
sig= repmat(0.03,length(tau),1);
%%
x0 = [1,0.5];
lb=[0,0];
ub=[15,2];
myfittype = fittype(@(d,a,sig,tau) (4.*d.*tau.^a+4.*sig.^2),'coefficients',{'d','a'},'independent',{'sig','tau'},'dependent','msd');
opt = fitoptions(myfittype);
%opt.Algorithm = 'Gauss-Newton';
opt.MaxIter = 1000;
opt.MaxFunEvals = 1000;
opt.Lower = lb;
opt.Upper = ub;
opt.StartPoint = x0;
opt.Weights = w;
[x,y]=fit([sig,tau],msd,myfittype,opt);
track_d = y.rsquare;
track_d1 = coeffvalues(x);
track_D = [track_d1 sig(1) track_d];
clear w
end
end
