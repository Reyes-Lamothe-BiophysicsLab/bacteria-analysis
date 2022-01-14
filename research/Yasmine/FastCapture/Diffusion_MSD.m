close all; clear; 
DTotal = [];
ATot = [];
LTotal = [];
Rsquared = [];
singlecell = [];
Shape2 = [];
SE = [];
steppin=[];
%% Settings
te=pwd;
te1=split(te,'/');
te2=te1(1:(end-1),1);
te3=join(te2,"/");
user_input_tracks = inputdlg({'What is the Pixel length','Min # of localizations for track','What is aquisition time of each frame','Seperate by cell size?', 'Pick Analysis type' , 'Calculate residence times ','Save Folder'},'Tracks Information',...
    [1 50; 1 50; 1 50; 1 50; 1 50; 1 50; 1 50],{'130','5','0.02, 0.1', '[1 = No , 2 = yes]', '[1 = With Fitting , 2 = No Fitting]', '[1 = No , 2 = yes]','Final_Result'});
Gauss = 2; %GMM models tested
DhistMinSteps = str2double(cell2mat(user_input_tracks(2, 1))); % Minimum number of steps in tracks to calculate D value    
pixel3 = str2double(cell2mat(user_input_tracks(1, 1)));   
time = str2double(cell2mat(user_input_tracks(3, 1)));
meth2 = str2double(cell2mat(user_input_tracks(5, 1))); 
split2 = str2double(cell2mat(user_input_tracks(4, 1)));
res = str2double(cell2mat(user_input_tracks(6, 1)));
pixel = 1;
dT = 1;
thresh = 0.5; 
FileList = dir(fullfile(cd,'*spots*.csv'));
L = size(FileList,1);  
%meth2=2;
    for l = 1:L
   BF_file = strrep(FileList(l).name,'.tif_spots.csv', '.mat');
   BF_file = te3{1} + "/" + BF_file;
   BF = importdata(BF_file);
   len = BF.MajorAxisLength * pixel3;
   wid = BF.MinorAxisLength * pixel3;
   shape = [len wid];
   Shape2 = vertcat(Shape2,shape);
   image = BF.image;
   cell = BF.cell;                                                                       % [GFP,nulPL,Outline,shape] = Bac_mask_SuperSegger(BF_file{l},pixel3); % input the file name of GFP stack image, return the masked GFP image and pixel list
   trackfile2 = track_seg_ss(FileList(l).name); % filter the tracks outside the nucleus area
   try
   [Ltot,Dtot,Adog,rsquared,SingleCell,step,se] = MSD_Bac3_ss(trackfile2,DhistMinSteps,meth2,dT,pixel3);
   catch me
       continue
   end
    DTotal = vertcat(DTotal,Dtot);
    ATot = vertcat(ATot,Adog);
    LTotal = vertcat(LTotal,Ltot);
    Rsquared = vertcat(Rsquared,rsquared);
    SingleCell(:,7)={len};
    SingleCell(:,8)={wid};
    SingleCell(:,9)={cell};
    SingleCell(:,10)={image};
    Singlecelll = [SingleCell];
    Singlecelll = Singlecelll(~cellfun('isempty',Singlecelll(:,1)),:);
    SE = vertcat(SE,se);
    steppin=vertcat(steppin,step);
    singlecell = vertcat(singlecell,Singlecelll);
    end
    mkdir(user_input_tracks{7, 1});
    cd( user_input_tracks{7, 1});
    dtotal=(DTotal > 0.01);
    steppin=steppin(dtotal==1);
    dtotal=DTotal(dtotal==1);
[fy, fx] = ecdf(SE,'function','survivor');
figure, plot(fx,fy)
xlabel('nm')
title('Total Step Size')
%% Regular Analysis
if split2 == 1
file=FileList(1).name;
file=strsplit(file,'_');
file=file{1, 1};
Lo = log(dtotal);
Out = hampel(dtotal);
figure
histogram (Out,'BinWidth',0.1,'Normalization','pdf');
title('Apparent Diffusion Coefficient');
[DataInx,BestModel,bound] = GMM_Diffusion(Lo,Gauss);
saveas(gcf,'MSD_diffusion.pdf')
Result = struct();
settings = struct();
Bound_Fit = struct();
data = struct();
if res == 2
[probs,counts,formula,fitt,opts,res,prop,fx1,fy1,stepin,stepblen]=StepSizeDif(steppin,DataInx,time,bound);
Bound_Fit.Residence_Time=probs;
Bound_Fit.counts = counts;
data.formula = formula;
Bound_Fit.Fit = fitt;
Bound_Fit.Settings = opts;
Bound_Fit.xdata = fx1;
Bound_Fit.ydata = fy1;
Bound_Fit.Proportion=prop;
Bound_Fit.Counts=res;
end
settings.GMM_Models_tested = Gauss;
settings.Minimum_Step_Size = DhistMinSteps;
                                                                            %settings.Algorithm = option                                                                           %settings.Threshold = thresh;

data.Diffusion = DTotal; 
data.Log_Diffusion = Lo;
data.Alpha = ATot;
data.Localization_Error = LTotal;
data.Results = BestModel;
data.R_Squared = Rsquared;
data.cluster = DataInx;


Result.settings = settings;
Result.data = data;
Result.Single_Cell = singlecell;
Results.Bound_Fit=Bound_Fit;
savenameRes = [file, '_MSD_Result.mat'];
save(savenameRes,'Result');
saveas(gcf,'MSD_diffusion_StepSize.pdf')
end
%% Analysis with cell size
if split2 == 2
    a=singlecell{end,10};
    Lo = log(DTotal);
    [DataInx,~,~] = GMM_Diffusion(Lo,Gauss);
    DataInx2=num2cell(DataInx);
    singlecell=[singlecell DataInx2];
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
        if singlecell{p, 7} < length1
            sm=vertcat(sm,singlecell(p,:));
            smD=vertcat(smD,(singlecell{p,2}));
        elseif singlecell{p, 7} >= length1 && singlecell{p, 7} <= length2
            med=vertcat(med,singlecell(p,:));
            medD=vertcat(medD,(singlecell{p,2}));
        elseif singlecell{p, 7} > length2
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
[DataInx1,BestModel1] = GMM_Diffusion_small(SmD,Gauss);
[DataInx2,BestModel2] = GMM_Diffusion_medium(MedD,Gauss);
[DataInx3,BestModel3] = GMM_Diffusion_large(LarD,Gauss);
[DataInx,BestModel,bound] = GMM_Diffusion(Lo,Gauss);
saveas(gcf,'MSD_Cellsize_diffusion.pdf')
Result = struct();
settings = struct();
settings.GMM_Models_tested = Gauss;
settings.Minimum_Step_Size = DhistMinSteps;                                                                              %settings.Algorithm = options;
settings.SmallCell_Thresh = length1;
settings.LargeCell_Thresh = length2;
Bound_Fit = struct();
data = struct();
if res == 2
[probs,counts,formula,fitt,opts,res,prop,fx1,fy1,stepin,stepblen]=StepSizeDif(steppin,DataInx,time,bound);
Bound_Fit.xdata = fx1;
Bound_Fit.ydata = fy1;
Bound_Fit.Fit = fitt;
Bound_Fit.Settings = opts;
Bound_Fit.Residence_Time=probs;
Bound_Fit.Proportion=prop;
Bound_Fit.Counts=res;
Bound_Fit.counts = counts;
data.formula = formula;
end
data.Diffusion = DTotal; 
data.Log_Diffusion = Lo;
data.Alpha = ATot;
data.Localization_Error = LTotal;
data.Results = BestModel;
data.Small_Diffusion = smD;
data.SmallResults = BestModel1;
data.Medium_Diffusion = medD;
data.MediumResults = BestModel2;
data.Large_Diffusion = larD;
data.LargeResults = BestModel3;
data.R_Squared = Rsquared;
data.cluster = DataInx;
Result.settings = settings;
Result.data = data;
Result.Single_Cell = singlecell;
Results.Bound_Fit=Bound_Fit;
savenameRes = [file, 'CellSize_MSD_Result.mat'];
save(savenameRes,'Result');
saveas(gcf,'MSD_CellSize_diffusion_StepSize.pdf')
end