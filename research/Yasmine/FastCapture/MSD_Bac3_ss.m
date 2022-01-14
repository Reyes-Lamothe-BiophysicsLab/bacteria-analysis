% calculate the diffusion coefficient from track data 
% get the trackinfo first, combine all the useful tracks in a same file,
% then use specific MSD method calculate the D

function [Ltot,Dtot,Adog,rsquared,SingleCell,sns,se] = MSD_Bac3_ss(trackdata,DhistMinSteps,meth,dT,p)
Dtot = [];
Adog = [];
Ltot = [];
rsquared = [];
SingleCell=[];
se=[];
STep=[];
trackinfo_1 = trackdata;
trackinfo = cell(length(trackinfo_1),1);
trackinfo_sum = cell(length(trackinfo_1),1);
    tracks = trackdata;
    for i = 1:length(tracks) %iterate tracks in each cell
        trAcks = tracks{i};
        %trackinfot = trAcks(~all(cellfun('isempty', trAcks(:, 1)), 2), :);
        trackinfo{i} = vertcat(trackinfo{i},trAcks);
    end
    trackinfo_sum(:,1) = trackinfo;
% filter out the short tracks in trackinfo file
trackinfo_sum_fil = trackinfo_sum;
trackinfosize = size(trackinfo_sum);
for t = 1:trackinfosize(1)
    W = trackinfo_sum_fil{t,:};
    w=[];
    if length(W) >= DhistMinSteps
        w = W;
    end
    %W = W(cellfun(@(x) length(x) >= DhistMinSteps, W));
    trackinfo_sum_fil{t,:} = w;
    clear w
end
%%
% Apply MSD to the track file 
nt=trackinfo_sum_fil(~cellfun('isempty',trackinfo_sum_fil));
datasize = size(nt);
for i = 1:datasize(1)
    celltracks = nt{i,:};
    tracks = celltracks;
    [para,~,step] = MSD_cal_LocError(tracks,dT,meth,1);
    step=step*p;
    Dtot = vertcat(Dtot,para(:,1));
    Adog = vertcat(Adog,para(:,2));
    Ltot = vertcat(Ltot,para(:,3));
    rsquared = vertcat(rsquared,para(:,4));
    celly = [{tracks} para(:,1) para(:,2) para(:,3) para(:,4) {step}];
    s{i,1}=step;
    se=vertcat(se,step);
    STep=vertcat(STep,s);
    clear s
    SingleCell = vertcat(SingleCell, celly);
    sns=STep(~cellfun('isempty',STep));
end 
end