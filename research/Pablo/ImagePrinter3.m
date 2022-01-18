function [ObjCell,Spotdata,AMeanL,AMaxL]=ImagePrinter3(ObjCell,C,LMaxFinder,S,thresh,JJ,AMeanL,AMaxL)
Spotdata=[];
times = ceil(height(ObjCell)/10);
ha = tight_subplot(times,10,[.001 .001],[.001 .001],[.001 .001]);
for x= 1:height(ObjCell)
    label=string(x);
    im=imcrop(C,ObjCell{x, 2}{1, 6});
    seg=ObjCell{x, 1};
    seg(seg==0)=ObjCell{x, 2}{1, 5};
    ObjCell{x,7}=sum(ObjCell{x, 2}{:, 8});
    vpix=ObjCell{x, 2}{1, 7};
    seg2=seg-(min(seg));
    seg2(seg2<300)=0;
    seg3=nonzeros(seg2);
    AMean = mean(seg2);
    AMedian= median(seg3);
    AMax = max(seg3);
    AMeanL = [AMeanL AMean];
    AMaxL = [AMaxL AMax];
    Inter=100+((300-100)/(6000-1500))*((AMax)-1500);
    if Inter<100
        Inter=100;
    end
    if Inter>300
        Inter=300;
    end
    %{
    AutoT= (AMax/AMedian);
    thresh1=thresh;
    threshQ= thresh*AutoT;
    if AMedian>AMean
        threshQ=threshQ+(thresh*0.5);
    elseif  (AMean*1.10)>AMedian
        threshQ=threshQ+(thresh*0.5);
    end
    if (AMean*2)>AMax
        threshQ=threshQ+(thresh*0.5);
    end
    if threshQ<thresh1*2
        threshQ=thresh1*2;
    end
    %}
    threshQ=Inter;
    [pos,spotdata]=spotdetect_gauss(im,3,LMaxFinder,S,threshQ,x,JJ,vpix);
    [J,~]= size(pos);
    pos2=[];
    if isempty(pos) == 0
        pos2(:,1) = pos(:,1)+ ObjCell{x, 2}{1, 6}(1,1);
        pos2(:,2) = pos(:,2)+ ObjCell{x, 2}{1, 6}(1,2);
        spotdata(:,1)=spotdata(:,1)+ ObjCell{x, 2}{1, 6}(1,1);
        spotdata(:,2)=spotdata(:,2)+ ObjCell{x, 2}{1, 6}(1,2);
        ObjCell{x,3}= J;
        ObjCell{x,5}= pos2;
        ObjCell{x,4}= pos;
        ObjCell{x,6}= spotdata(:,12);
        ObjCell{x,7}= sum(spotdata(:,12));
        ObjCell{x,8}= spotdata;
    else
        pos2=[];
        ObjCell{x,3}= 0;
        ObjCell{x,4}= 0;
        ObjCell{x,5}= 0;
        ObjCell{x,6}= 0;
        ObjCell{x,7}= 0;
        ObjCell{x,8}= 0;
    end
    axes(ha(x));
    imshow(seg,[]);
    hold all %To show each individual cell and its spotcount\
    if isempty(pos)
        text(3,3,label,'Color','r')
        continue
    end
    plot(pos(:,1),pos(:,2),'ro','MarkerSize',5) %To show each individual cell and its spotcount
    text(3,3,label,'Color','r')
    hold off %To show each individual cell and its spotcount
    clear pos J pos2
    Spotdata=vertcat(Spotdata,spotdata);
 end
end