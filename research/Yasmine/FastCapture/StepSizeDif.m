function [probs,counts,fomula,c,d,tt,t2,fx1,fy1,stepin,stepblen]=StepSizeDif(step,data,times,fit)
stepin=[];
stepout=[];
stepinl=[];
stepins=[];
stepoutl=[];
stepouts=[];
stepdlen=[];
stepblen=[];
prop1=[];
prop2=[];
StepSize= 10;
Manage=[];
boun=[];

for t=1:length(step)
    if data(t,2) == 1
        prop1 = vertcat(prop1,data(t,1));
    end
    if data(t,2) == 2
        prop2 = vertcat(prop2,data(t,1));
    end
end
prop11=mean(prop1);
prop22=mean(prop2);
if prop11 < prop22
    in = 1;
    out = 2;
    prop=max(prop1);
else
     in = 2;
    out = 1;
    prop=max(prop2);
end

for s=1:length(step)
    if data(s,2) == out
        stte=step{s,1}(:,1);
        steo=length(stte)+1;
        ssto=sum(stte)/steo;
        ssteo=[ssto steo];
        stepdlen=vertcat(stepdlen,ssteo);
        stepout=vertcat(stepout,step{s,1}(:,1));
        
        if steo < StepSize
           stepouts=vertcat(stepouts,step{s,1}(:,1)); 
        end
        if steo >= StepSize
           stepoutl=vertcat(stepoutl,step{s,1}(:,1)); 
        end
    end
    if data(s,2) == in
        manage={step{s,1}};
        Manage=vertcat(Manage,manage);
        stte=step{s,1}(:,1);
        stei=length(stte)+1;
        ssti=sum(stte)/stei;
        sstei=[ssti stei];
        stepblen=vertcat(stepblen,sstei);
        stepin=vertcat(stepin,step{s,1}(:,1));
        if stei < StepSize
           stepins=vertcat(stepins,step{s,1}(:,1)); 
        end
        if stei >= StepSize
           stepinl=vertcat(stepinl,step{s,1}(:,1)); 
        end
    end    
end


[fy1, fx1] = ecdf(stepin,'function','survivor');
figure, plot(fx1,fy1)
xlabel('nm')
title('Step Size for Bound')
pixel3 = inputdlg('1= YES, 2= NO','Is this the Step Size control',[1 80],{'1= YES, 2= NO'});    
pixel3 = str2double(cell2mat(pixel3));
if pixel3 == 1
pixel4 = inputdlg('[~0.01]','What % of survival plot to measure Step Size for Bound',[1 80],{'[~0.01]'});    
pixel4 = str2double(cell2mat(pixel4));   
[row,~]=find(fy1 < (pixel4+0.001) & fy1 > pixel4,1,'last');
med=fx1(row,1);
end
if pixel3 == 2
% pixel4 = inputdlg('[~200]','What this the Step Size of bound',[1 80],{'[~200]'});    
% pixel4 = str2double(cell2mat(pixel4));
pixel4=209;
med=pixel4;
end
med3=med/1000;
propx=exp(prop);
x=[0:1:30];
f= @(x)((1-exp(-(med3.^2/(4*propx*times)))).^x);
med2=string(med);
propw=string(propx);
tim=string(times);
fomula = ('(1-exp(-(' + med2 + '.^2/(4*' + propw + '*' + tim + ')))).^x'); 
ra=f(x);
[ro,~]=find(ra < (0.01),1,'first');
rmin=x(1,ro);

for y=1:length(step)
    l=step{y,1};
    l2= l <= med;
    if l2 == 1
        bo=length(l2)+1;
        boun=vertcat(boun,bo);
        clear bo
    elseif l2 == 0
        continue
    else
    l3 = [0 l2.' 0];
    D = diff([false,diff(l3)==0,false]);
    d = arrayfun(@(a,b)l3(a:b),find(D>0),find(D<0),'uni',0);
    for yy = 1: length(d)
        li= d{1,yy}(1,:);
        if li == 1 
            bo=length(li)+1;
            boun=vertcat(boun,bo);
            clear bo
        end
    end
    clear D
    end  
end
time2=times*boun;
counts = tabulate(time2);
[t,tt]=ecdf(time2,'function','survivor');
t2=t*fit;
%figure, plot(tt,t2)
[c,d,probs] = bestexpfit(tt,t2);
% [fy1s, fx1s] = ecdf(stepins,'function','survivor');
% figure, plot(fx1s,fy1s)
% xlabel('Pixel')
% title('Step Size for Bound Short Tracks')
% [fy1l, fx1l] = ecdf(stepinl,'function','survivor');
% figure, plot(fx1l,fy1l)
% xlabel('Pixel')
% title('Step Size for Bound Long Tracks')
%[c,d] = bestexpfit(fx1,fy1);
%figure, plot(c,fx1,fy1);
% title('Best fit for Bound Step Size')
% figure, histogram (stepblen(:,1), 'BinMethod','fd')
% title('Step Size Average for Bound molecules')
% figure, scatter(stepblen(:,2),stepblen(:,1))
% title('Step Size Average for Bound molecules')
end
% F = @(x,xdata)x(1)*exp(-x(2)*xdata) + x(3)*exp(-x(4)*xdata);
% F2 = @(x,xdata)x(1)*exp(x(2)*xdata);
% x1 = [300 0.005 1 0] ;
% x2 = [1, 0];
% xunc = lsqcurvefit(F, x1, fx1, fy1);
% xunc2 = lsqcurvefit(F2, x2, fx1, fy1);
% tlist = linspace(min(fx1), max(fx1));   % Plot Finer Resolution
% figure(1)
% plot(fx1,fy1,'-k', 'LineWidth', 2)
% title('Data points')
% hold on
% plot(tlist, F(xunc,tlist), '-b', 'LineWidth', 1)
% plot(tlist, F2(xunc2,tlist), '-r', 'LineWidth', 1)
% hold off
% figure, histogram (stepin, 'BinMethod','fd')
% xlabel('Pixel')

% figure, histogram (stepins, 'BinMethod','fd')
% xlabel('Pixel')

% figure, histogram (stepinl, 'BinMethod','fd')
% xlabel('Pixel')

% figure, histogram (stepout, 'BinMethod','fd')
% xlabel('Pixel')
% [fy2, fx2] = ecdf(stepout);
% figure, plot(fx2,fy2)
% xlabel('Pixel')
% title('Step Size for Diffusing')
% % figure, histogram (stepouts, 'BinMethod','fd')
% % xlabel('Pixel')
% [fy2s, fx2s] = ecdf(stepouts);
% figure, plot(fx2s,fy2s)
% xlabel('Pixel')
% title('Step Size for Diffusing Short Tracks')
% % figure, histogram (stepoutl, 'BinMethod','fd')
% % xlabel('Pixel')
% [fy2l, fx2l] = ecdf(stepoutl);
% figure, plot(fx2l,fy2l)
% xlabel('Pixel')
% title('Step Size for Diffusing Long Tracks')
% figure, histogram (stepdlen(:,1), 'BinMethod','fd')
% title('Step Size Average for Diffusing molecules')
% figure, scatter(stepdlen(:,2),stepdlen(:,1))
% title('Step Size Average for Diffusing molecules')
%   %l3= l2 == 1;
%     if l2 == 1
%         bo=length(l)+1;
%         boun=vertcat(boun,bo);
%         clear bo
%     else
%         p=find(diff(l2)==1);
%         if p(1,1) > rmin
%          bo = p(1,1)+1;  
%          boun=vertcat(boun,bo);
%          clear bo
%         end
%         for yy=2:length(p)
%             b= p(1,yy)-p(1,yy-1);
%             if b > rmin
%                bo = b+1; 
%                boun=vertcat(boun,bo);
%                clear bo
%             end
%         end
%     end