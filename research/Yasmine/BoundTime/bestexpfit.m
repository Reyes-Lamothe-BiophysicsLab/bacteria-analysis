 function [c,d,r] = bestexpfit(fx,fy)
% options=fitoptions('exp1');
% options.Robust='Bisquare';
% options.MaxFunEvals=600;
% options.MaxIter=400;

[f1,dat1] = fit(fx, fy,'exp1');%options
[f2,dat2] = fit(fx, fy,'exp2');
a=dat1.adjrsquare;
b=dat2.adjrsquare;
% t1 = dat1.rsquare/dat1.rmse;
% t2 = dat2.rsquare/dat2.rmse;
%tstat=
rss1=dat1.sse;
rss2=dat2.sse;
p1=2;
p2=4;
% F=((rss1-rss2)/(p2-p1))/(rss2/(n-p2));
% ci1=confint(f1);
% ci1=ci1(1,1);
% ci2=confint(f2);
% ci2=ci2(1,[1,3]);
% cm1= sum(ci1 < 0);
% cm2= sum(ci2 < 0);

if rss1 < rss2 && b < a
    c=f1;
    d=dat1;
     xmax=max(fx)+0.5;
    xmin=min(fx)-0.5;
    ymax=max(fy)+0.05;
    ymin=min(fy)-0.05;
    figure
    plot(fx,fy,'o')
    hold on
    plot(c,'predobs')
    figure
    ylim([ymin ymax]);
    xlim([xmin xmax]);
    hold on
    plot(c,fx,fy)
    xlabel('Dwell Time(s)')
    ylabel('Frequency')
    f1a=string(c.a);
    f1b=-1/c.b;
    props = f1b;
    f1b=string(f1b);
    f1b= f1b + ' seconds';
%     form1=f1a + 'exp('+ f1b + 'x)';
    legend('Data',f1b)
    hold off
      CI=confint(c);
    CI=CI(:,2);
    CI=-1./CI;
    r(1,1)= props(1);
    r(1,2)= CI(1,1);
    r(1,3)= CI(2,1);
elseif rss2 < rss1  && b > a
    c=f2;
    d=dat2;
    xmax=max(fx)+0.5;
    xmin=min(fx)-0.5;
    ymax=max(fy)+0.05;
    ymin=min(fy)-0.05;
    figure
    plot(fx,fy,'o')
    hold on
    plot(c,'predobs')
    figure
    ylim([ymin ymax]);
    xlim([xmin xmax]);
    hold on
    plot(c,fx,fy)
    fplot(@(x) c.a*exp(c.b*x))%[c.a-0.1,max(fx)]
    fplot(@(x) c.c*exp(c.d*x))%,[0,c.a+0.1]
    xlabel('Dwell Time(s)')
    ylabel('Frequency')
    f1a=string(c.a);
    f1b=-1/c.b;
    f2a=string(c.c);
    f2b=string(c.d);
    f2b=-1/c.d;
    props = [f1b f2b];
    f1b=string(f1b);
    f1b= f1b + ' seconds';
    f2b=string(f2b);
    f2b= f2b + ' seconds';
%     form1=f1a + 'exp('+ f1b + 'x)';
%     form2=f2a + 'exp('+ f2b + 'x)';
    legend('Data', 'Two Exponential Fit',f1b,f2b)
    CI=confint(c);
    CI=CI(:,[2 4]);
    CI=-1./CI;
    r(1,1)= props(1);
    r(1,2)= CI(1,1);
    r(1,3)= CI(2,1);
    r(2,1)= props(2);
    r(2,2)= CI(1,2);
    r(2,3)= CI(2,2);
else
    [~,~] = createFits(fx, fy);
    image2 = inputdlg('Which Figure Represents Data Best','1 = Exp1 , 2 = Exp2',[1 35],{'[1 = Exp1 , 2 = Exp2]'});    
    meth2 = str2double(cell2mat(image2)); 
    if meth2 == 1
         c=f1;
    d=dat1;
     xmax=max(fx)+0.5;
    xmin=min(fx)-0.5;
    ymax=max(fy)+0.05;
    ymin=min(fy)-0.05;
    figure
    plot(fx,fy,'o')
    plot(c,'predobs')
    figure
    ylim([ymin ymax]);
    xlim([xmin xmax]);
    hold on
    plot(c,fx,fy)
    xlabel('Dwell Time(s)')
    ylabel('Frequency')
    f1a=string(c.a);
    f1b=-1/c.b;
    props = f1b;
    f1b=string(f1b);
    f1b= f1b + ' seconds';
%     form1=f1a + 'exp('+ f1b + 'x)';
    legend('Data',f1b)
    hold off
    CI=confint(c);
    CI=CI(:,[2 4]);
    CI=-1./CI;
    r(1,1)= props(1);
    r(1,2)= CI(1,1);
    r(1,3)= CI(2,1);
    elseif meth2 == 2
       c=f2;
    d=dat2;
    xmax=max(fx)+0.5;
    xmin=min(fx)-0.5;
    ymax=max(fy)+0.05;
    ymin=min(fy)-0.05;
    figure
    plot(fx,fy,'o')
    plot(c,'predobs')
    figure
    ylim([ymin ymax]);
    xlim([xmin xmax]);
    hold on
    plot(c,fx,fy)
    fplot(@(x) c.a*exp(c.b*x))%[c.a-0.1,max(fx)]
    fplot(@(x) c.c*exp(c.d*x))%,[0,c.a+0.1]
    xlabel('Dwell Time(s)')
    ylabel('Frequency')
    f1a=string(c.a);
    f1b=-1/c.b;
    f2a=string(c.c);
    f2b=string(c.d);
    f2b=-1/c.d;
    props = [f1b f2b];
    f1b=string(f1b);
    f1b= f1b + ' seconds';
    f2b=string(f2b);
    f2b= f2b + ' seconds';
%     form1=f1a + 'exp('+ f1b + 'x)';
%     form2=f2a + 'exp('+ f2b + 'x)';
    legend('Data', 'Two Exponential Fit',f1b,f2b)
     CI=confint(c);
    CI=CI(:,[2 4]);
    CI=-1./CI;
    r(1,1)= props(1);
    r(1,2)= CI(1,1);
    r(1,3)= CI(2,1);
    r(2,1)= props(2);
    r(2,2)= CI(1,2);
    r(2,3)= CI(2,2);
   
    end
end
end