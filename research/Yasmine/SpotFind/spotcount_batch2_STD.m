clear
close all

% Script to segment cells and count spots from a single image
%% Variables that can be changed
LB = 20; % Pixel Lower Boundary
image = inputdlg('Pick Pixel Length','1 = < 100 nm , 2 = > 100 nm',[1 80],{'[1 = < 100 nm , 2 = > 100 nm]'});    
image = str2double(cell2mat(image));
meth = image; %% 1 = MSD, 2 = Radius of Gyration
%% A) Getting the Cell Outline
FileList = dir(fullfile(cd, '**','*.npy'));
    FileList2 = struct('folder', {FileList(1:end).folder});
    FileList2= struct2table(FileList2);
    FileList2=table2array(FileList2);
    BF_file2=natsortfiles(FileList2);
    FileList = struct('name', {FileList(1:end).name});
    FileList= struct2table(FileList);
    FileList=table2array(FileList);
    BF_file=natsortfiles(FileList);
    a=BF_file2 + "/" + BF_file;
aa= uigetfile('*.vsi', 'Pick Fluorescent Image', 'Multiselect', 'on'); % Fluorescent image
INfo=[];
spotT=[];
intT=[];
backT=[];
TintT=[];
TbackT=[];
lenT=[];
spots=[];
oneI = [];
twoI =[];
threeI=[];
fourI =[];
plusI=[];
oneD = [];
twoD =[];
threeD =[];
fourD =[];
plusD =[];
amp = strel('sphere',2);
spots=[];
LENGTH= length(a);
%%
for JJ= 1:LENGTH
    c=readNPY(a{JJ,1});
    c=imbinarize(c);
%c=c.mask_cell;
RD=bfopen(aa{1,JJ});
C=(RD{1,1}{1,1});
C=double(C);
%C=C(1:457,:);
CC = imgaussfilt(C,1);
[si,ze]=size(C);
f =(bwareaopen(c,LB));
f(1,:) = 1;
f(end,:) = 1;
f(:,1) = 1;
f(:,end) = 1;
f = imclearborder(f,8);
ff = bwconncomp(f);

stats = regionprops(ff,'PixelList');
l=length(stats);
for L=1:l
    List = (stats(L).PixelList);
    m=zeros(si,ze);
    p=length(List);
    for P=1:p
        g=List(P,1);
        G=List(P,2);
        m(G,g)=1;
    end
    single=imdilate(m,amp);
    seg=C.*single;
    stats2 = regionprops(single,seg,'MeanIntensity','Area','BoundingBox','PixelList','PixelValues','MajorAxisLength','MinorAxisLength','MinIntensity','Centroid','Orientation');
    %seg(seg==0)=Back; 
    ObjCell{L,1}=seg;
    ObjCell{L,7}=stats2.MeanIntensity;
    ObjCell{L,8}=stats2.Area;
    ObjCell{L,15}=stats2.BoundingBox;
    ObjCell{L,3}= [stats2.MajorAxisLength stats2.MinorAxisLength stats2.MeanIntensity stats2.Area stats2.MinIntensity stats2.BoundingBox {stats2.PixelList} {stats2.PixelValues} {stats2.Centroid} stats2.Orientation ] ;
    clear m pix g G stats2
end
jj=1;
    while jj == 1
    times = ceil(l/5);
    ha = tight_subplot(times,5,[.001 .001],[.001 .001],[.001 .001]);
    for x= 1:l
        label=string(x);
y= ObjCell(x,1);
z=y{1,1};
im =double(z);
ObjCell{x,12}=sum(ObjCell{x, 3}{:, 8});
if meth == 1
    pos=spotdetect_gauss_65(im); %% talk here
    Pixel=0.065;
elseif meth == 2
    pos=spotdetect_gauss_100(im);
    Pixel=0.130;
end
[J,~]= size(pos);
ObjCell{x,2}= J;
ObjCell{x,4}= pos;
XY = ObjCell{x, 3}{1, 6};
X1 = ceil(XY(1,1))-10;
if X1 < 0 
    X1=0;
end
Y1 = ceil(XY(1,2))-10;
if Y1 < 0 
    Y1=0;
end
X2 = (X1 + XY(1,3))+10;
Y2 = (Y1 + XY(1,4))+10;
axes(ha(x));
imagesc(im); %To show each individual cell and its spotcount
hold all %To show each individual cell and its spotcount\
xlim([X1 X2])
ylim([Y1 Y2])
if isempty(pos)
    text(X1+3,Y1+3,label,'Color','r')
    continue
end
plot(pos(:,1),pos(:,2),'ro','MarkerSize',5) %To show each individual cell and its spotcount
text(X1+3,Y1+3,label,'Color','r')
hold off %To show each individual cell and its spotcount
clear pos J
    end 
    set(ha(1:4),'XTickLabel',''); set(ha,'YTickLabel','')
 user_input2 = inputdlg ('Do the cells good?','Cell Processing',[1 50],{'N'});
    if user_input2{1,1} == 'Y' || user_input2 {1,1} == 'y'
        close all
        jj=jj+1;
     elseif user_input2{1,1} == 'N' || user_input2 {1,1} == 'n'
        list=string([1:l]);
        res=listdlg('ListString',list);
        l1=length(res);
        close all
        for l2=1:l1
            l3=res(l2);
            XY = ObjCell{l3, 3}{1, 6};
            X1 = ceil(XY(1,1))-10;
            Y1 = ceil(XY(1,2))-10;
            X2 = (X1 + XY(1,3))+10;
            Y2 = (Y1 + XY(1,4))+10;
            image=ObjCell{l3, 1};
            figure
            imagesc(image)%HM modify magnification
            xlim([X1 X2])
            ylim([Y1 Y2])
            title('click a spot and hold alt key to select multiple spots, push any key when finished')
            datacursormode on
            pause
            dcm_obj = datacursormode(1);
            info_struct = getCursorInfo(dcm_obj);
            close all
            if isempty(info_struct)
               ObjCell{l3,4}= [];
               ObjCell{l3,2}= 0;
               continue
            end
            %Loop over spots chosen and pull out co-ordinates
            for q=1:size(info_struct,2)
                Spot_coords=info_struct(q).Position;
                y_estimate(q,1)=Spot_coords(2);
                x_estimate(q,1)=Spot_coords(1);
            end
           
            poss=[x_estimate y_estimate];
            ObjCell{l3,4}= poss;
            [JJJ,~]= size(poss);
            ObjCell{l3,2}= JJJ;
            clear poss JJJ info_struct x_estimate y_estimate
        end
        jj=jj+1;
    end 
    end
    Spotdata=[];
    for x= 1:l
        J = ObjCell{x,2};
         if J==0
            ObjCell{x,4}=0;
            ObjCell{x,5}=0;
            ObjCell{x,6}=0;
            
        elseif J>0 
            pos2=[];
            E=[];
            R2=[];
            %[t,p]=min(z);
            pos = ObjCell{x,4};
            [xx,yy]= size(pos);
            vec=round(pos);
            add2=zeros(xx,1);
            for d=1:xx
            r = zeros(si,ze);
            xall = vec(d,1);
            yall = vec(d,2);
            x0 = xall -3;
            x1 = xall +3;
            xrange = [x0:x1];
            xrange = [xrange xrange xrange xrange xrange xrange xrange];
            xrange = xrange';
%             y0 = yall -5;
%             y1 = yall -4;
            y2 = yall -3;
            y3 = yall -2;
            y4 = yall -1;
            y6 = yall +1;
            y7 = yall +2;
            y8 = yall +3;
%             y9 = yall +4;
%             y10 = yall +5;
%             y0 = repmat(y0, 1, 11);
%             y1 = repmat(y1, 1, 11);
            y2 = repmat(y2, 1, 7);
            y3 = repmat(y3, 1, 7);
            y4 = repmat(y4, 1, 7);
            y5 = repmat(yall, 1, 7);
            y6 = repmat(y6, 1, 7);
            y7 = repmat(y7, 1, 7);
            y8 = repmat(y8, 1, 7);
%             y9 = repmat(y9, 1, 11);
%             y10 = repmat(y10, 1, 11);
            yrange = [ y2 y3 y4 y5 y6 y7 y8 ];
            yrange = yrange';
            ga = length(xrange);
            for GA=1:ga
                Pa=xrange(GA);
                PPa=yrange(GA);
                r(PPa,Pa)=1;
            end          
            seg2=C.*r;
            Back=ObjCell{x, 3}{1, 5};
            seg2(seg2==0)=Back; 
            try
            [res]=GaussianSurf(seg2); %talk here 
            catch ME
            ObjCell{x,4}=0;
            ObjCell{x,5}=0;
            ObjCell{x,6}=0;
            continue
            end
            dif=res.a/res.b;
            xz=round(res.y0);
            yz=round(res.x0);
            ml=2;
            subim = C([xz-ml:xz+ml],[yz-ml:yz+ml]);
            add=sum(subim,'all');
            add2(d)=add;
            spotdata=[res.x0 res.y0 res.a res.b dif res.sigma res.sse res.r2 x d JJ {C} X1 X2 Y1 Y2 add]; % x_coor, y_coor, intensity, background, dif, sigma,sum of squared error for the fitted Gaussian, R^2 proportion of variance 
            Spotdata=vertcat(Spotdata,spotdata);
            spots= vertcat(spots,spotdata);
            res.info= a{JJ,1};
            res.info2= x;
            res.info2= xx;
            INfo=vertcat(INfo,res);
            Pos2=[res.x0 res.y0];
            pos2=vertcat(pos2,Pos2);
            r2 = res.a;
            R2=vertcat(R2,r2);
            rr1=ObjCell{x, 3}{1, 10};
            rr2=(ObjCell{x, 3}{1, 9})';
            R=[cosd(rr1) +sind(rr1); -sind(rr1), cosd(rr1)];
            r3=(R*(Pos2'-rr2)+rr2);
            e1 =(r3(1) - rr2(1));
            e2= (ObjCell{x, 3}{1, 1}/2);
            e = [e1 e2];
            E= vertcat(E,e);
            clear e seg2
            end
            add3=sum(add2);
            ObjCell{x,4}= pos2;
            ObjCell{x,5}= R2;
            K=sum(R2);
            ObjCell{x,6}= K;
            ObjCell{x,9}= (K/ObjCell{L,7})*ObjCell{L,8};
            ObjCell{x,10}= add2;
            ObjCell{x,11}= add3;
            if J == 1
                oneI = vertcat(oneI,add2);
                oneD = vertcat(oneD,E);
            elseif J == 2
                twoI = vertcat(twoI,add2);
                twoD = vertcat(twoD,E);
            elseif J == 3
                threeI = vertcat(threeI,add2);
                threeD = vertcat(threeD,E);
            elseif J == 4
                fourI = vertcat(fourI,add2);
                fourD = vertcat(fourD,E);
            elseif J >4 
                plusI = vertcat(plusI,add2);
                plusD = vertcat(plusD,E);
            end
            clear pos2 R2 K R spotdata
         end
    end
    Tback= [ObjCell{:,12}].';
    TBacA= mean(Tback);
    TBacA(:,2)=std(Tback);
    back = ObjCell{:,7};
    back(back==0)=[];
    BacA= mean(back);
    BacA(:,2)=std(back);
    Int = ObjCell(:,6);
    int =cell2mat(Int);
    int(int==0)=[];
    IntA= mean(int);
    IntA(:,2)=std(int);
    Tint=[ObjCell{:,11}].';
    TIntA= mean(Tint);
    TIntA(:,2)=std(Tint);
    zz=ObjCell(:,2);
    zzz=cell2mat(zz);
    Average= mean(zzz);
    Average(:,2)=std(zzz);
    tbl = tabulate(zzz);
    tbl = num2cell(tbl);
    Average = num2cell(Average);
    IntA = num2cell(IntA);
    BacA = num2cell(BacA);
    TIntA = num2cell(IntA);
    TBacA = num2cell(BacA);
    %% D) Saving the results
    save_name_outline = strrep(a{JJ,1}, '.vsi', '_outline.tif');
    Results=struct('Values',{ObjCell},'Counts',{tbl},'Average',{Average},'TotalBackground',{Tback},'TotalBackgroundAverage',{TBacA},'PixelBackground',{back},'PixelBackgroundAverage',{BacA},'Intensities',{Int},'IntensityAverage',{IntA},'TotalSpotIntensities',{Tint},'TotalSpotIntensityAverage',{TIntA},'spotdata',{Spotdata});
    save_name_spots = strrep(aa{1,JJ}, '.vsi', '_Results.mat');
    save (save_name_spots, 'Results')
    SpotData(JJ)={Spotdata};
    spotT= vertcat(spotT,zzz);
    intT= vertcat(intT,int);
    backT=vertcat(backT,back);
    TintT= vertcat(TintT,Tint);
    TbackT=vertcat(TbackT,Tback);
    clear ObjCell Spotdata
    close all
end
D=[];
D=vertcat(D,oneD);
D=vertcat(D,twoD);
D=vertcat(D,threeD);
D=vertcat(D,fourD);
D=vertcat(D,plusD);
D=D*Pixel;
D2=D(:,end)*2;
figure

scatter(D2,D(:,1))
hold on
line(D2,D(:,2),'Color','k')
line(D2,(-D(:,2)),'Color','k')
hold off
saveas(gcf,'SpotLocation.pdf')
I=[];
I=vertcat(I,oneI);
I=vertcat(I,twoI);
I=vertcat(I,threeI);
I=vertcat(I,fourI);
I=vertcat(I,plusI);
figure
histogram(I,'BinWidth',1000)
saveas(gcf,'AllIntensity.pdf')
figure
histogram(oneI','BinWidth',1000)
hold on
histogram(twoI,'BinWidth',1000)
histogram(threeI,'BinWidth',1000)
hold off

backAT = mean(backT);
backAT(:,2)=std(backT);
backAT = num2cell(backAT);
IntAT= mean(intT);
IntAT(:,2)=std(intT);
IntAT = num2cell(IntAT);
TbackAT = mean(TbackT);
TbackAT(:,2)=std(TbackT);
TbackAT = num2cell(TbackAT);
TIntAT= mean(TintT);
TIntAT(:,2)=std(TintT);
TIntAT = num2cell(TIntAT);
tblT = tabulate(spotT);
tblT2 = num2cell(tblT);
AverageT= mean(spotT);
AverageT(:,2)=std(spotT);
AverageT = num2cell(AverageT);
intT = num2cell(intT);
figure
bar(tblT(:,1),tblT(:,3))
Spot_inf=struct('One_Spot_Intensity',{oneI},'Two_Spot_Intensity',{twoI},'Three_Spot_Intensity',{threeI},'Four_Spot_Intensity',{fourI},'FiveP_Spot_Intensity',{plusI},'One_Spot_Location',{oneD},'Two_Spot_Location',{twoD},'Three_Spot_Location',{threeD},'Four_Spot_Location',{fourD},'FiveP_Spot_Location',{plusD});
ResultsT=struct('TotalCounts',{tblT2},'TotalAverage',{AverageT},'TotalBackground',{TbackT},'TotalBackgroundAverage',{TbackAT},'TotalIntensities',{TintT},'TotalIntensityAverage',{TIntAT},'TotalPixelBackground',{backT},'TotalPixelBackgroundAverage',{backAT},'TotalPixelIntensities',{intT},'TotalPixelIntensityAverage',{IntAT},'spotdata',{SpotData},'totalspotdata',{spots},'SpotInfo',{Spot_inf});
save_name_spotsT = strrep(aa{1,1}, '.vsi', '_TotalResults.mat');
save (save_name_spotsT, 'ResultsT','-v7.3')
