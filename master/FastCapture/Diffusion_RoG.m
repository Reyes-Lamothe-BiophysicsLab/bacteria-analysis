close all; clear; 
DTotal = [];
singlecell = [];
Shape2 = [];
SE = [];
steppin=[];
%% Settings
user_input_tracks = inputdlg({'What is the Pixel length','Min # of localizations for track','What is aquisition time of each frame','Seperate by cell size?','Save Folder'},'Tracks Information',...
    [1 50; 1 50; 1 50; 1 50; 1 50],{'130','5','0.02, 0.1', '[1 = No , 2 = yes]','Final_Result'});

Gauss = 2; %GMM models tested
DhistMinSteps = str2double(cell2mat(user_input_tracks(2, 1)));    
pixel3 = str2double(cell2mat(user_input_tracks(1, 1)));    
time = str2double(cell2mat(user_input_tracks(3, 1)));
pixel = 1;
dT = 1;  
split = str2double(cell2mat(user_input_tracks(4, 1)));
%% Calculate relations between nucleus area and bound spots
trackfile = uigetfile('*spots*.csv', 'Multiselect', 'on','Pick your track mate data');
L = length(trackfile);
for l = 1:L
    BF_file = strrep(trackfile{l},'.tif_spots.csv', '.mat');
     BF = importdata(BF_file);
    len = BF.MajorAxisLength * pixel3;
    wid = BF.MinorAxisLength * pixel3;
    shape = [len wid];
    Shape2 = vertcat(Shape2,shape);
    image = BF.image;
    cell = BF.cell;
    trackfile2 = track_seg_ss(trackfile{l}); % filter the tracks outside the nucleus area
    [Dtot,SingleCell] = RadiusofGyration_ss(trackfile2,DhistMinSteps,pixel);
    DTotal = vertcat(DTotal,Dtot);
    if isempty(SingleCell) == 1
        continue
    else
    SingleCell(:,3)={len};
    SingleCell(:,4)={wid};
    SingleCell(:,5)={cell};
    SingleCell(:,6)={image};
    Singlecelll = [SingleCell];
    Singlecelll = Singlecelll(~cellfun('isempty',Singlecelll(:,1)));
    singlecell = vertcat(singlecell,SingleCell);
    end
end
Lo = log(DTotal);
    mkdir(user_input_tracks{5, 1});
    cd( user_input_tracks{5, 1});
%% Regular Analysis
if split == 1 
figure
histogram (DTotal,'BinWidth',0.1,'Normalization','pdf');
title('Apparent Radius of Gyration');
figure
histogram (Lo,'BinWidth',0.5,'Normalization','pdf');
title('Log of Apparent Radius of Gyration');
[DataInx,BestModel] = GMM_RoG(Lo,Gauss);
Result = struct();
settings = struct();
settings.GMM_Models_tested = Gauss;
settings.Minimum_Step_Size = DhistMinSteps;
data = struct();
data.Diffusion = DTotal; 
data.Log_Diffusion = Lo;
data.Results = BestModel;
data.cluster = DataInx;
Result.settings = settings;
Result.data = data;
Result.Single_Cell = singlecell;
file=string(trackfile(1,1));
file=strsplit(file,'_');
file=file{1, 1};
savenameRes = [file, 'CellSize_RoG_Result.mat'];
save(savenameRes,'Result');
saveas(gcf,'RoG_diffusion.pdf')
end
%% Analysis with Cell Size
if split == 2
    figure, histogram(Shape2(:,1))
%     length1 =inputdlg('Look at Histogram','Lower Length',[1 80],{'3000'});
%     length1 = str2double(cell2mat(length1));
%     length2 =inputdlg('Look at Histogram','Upper Length',[1 80],{'5000'});
%     length2 = str2double(cell2mat(length2));
    ce = length(singlecell);
    sm=[];
    smD=[];
    med=[];
    medD=[];
    lar=[];
    larD=[];
     le=Shape2(:,1);
    le=sort(le);
    Le=round((length(le)/3));
    length1=le(Le);
    length2=le(Le*2);
    for p = 1:ce
        if singlecell{p, 3} < length1
            sm=vertcat(sm,singlecell(p,:));
            smD=vertcat(smD,(singlecell{p,2}));
        elseif singlecell{p, 3} >= length1 && singlecell{p, 3} <= length2
            med=vertcat(med,singlecell(p,:));
            medD=vertcat(medD,(singlecell{p,2}));
        elseif singlecell{p, 3} > length2
            lar=vertcat(lar,singlecell(p,:));
            larD=vertcat(larD,(singlecell{p,2}));
        end
    end
file=string(trackfile(1,1));
file=strsplit(file,'_');
file=file{1, 1};
SmD= log(smD);
MedD = log(medD);
LarD = log(larD);
Lo = log(DTotal);
[DataInx1,BestModel1] = GMM_RoG_small(SmD,Gauss);
[DataInx2,BestModel2] = GMM_RoG_medium(MedD,Gauss);
[DataInx3,BestModel3] = GMM_RoG_large(LarD,Gauss);
[DataInx,BestModel] = GMM_RoG(Lo,Gauss);
Result = struct();
settings = struct();
settings.GMM_Models_tested = Gauss;
settings.Minimum_Step_Size = DhistMinSteps;
settings.SmallCell_Thresh = length1;
settings.LargeCell_Thresh = length2;
data = struct();
data.Diffusion = DTotal; 
data.Log_Diffusion = Lo;
data.Results = BestModel;
data.Small_Diffusion = smD;
data.SmallResults = BestModel1;
data.Medium_Diffusion = medD;
data.MediumResults = BestModel2;
data.Large_Diffusion = larD;
data.LargeResults = BestModel3;
data.cluster = DataInx;
Result.settings = settings;
Result.data = data;
Result.Single_Cell = singlecell;
savenameRes = [file, 'CellSize_RoG_Result.mat'];
save(savenameRes,'Result');
saveas(gcf,'RoG_CellSize_diffusion.pdf')
end