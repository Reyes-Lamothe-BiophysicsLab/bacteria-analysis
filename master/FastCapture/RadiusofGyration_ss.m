function [Dtot,SingleCell] = RadiusofGyration_ss(trackdata,DhistMinSteps,pixel)
SingleCell=[];
Dtot =[];
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
nt=trackinfo_sum_fil(~cellfun('isempty',trackinfo_sum_fil));
datasize = size(nt);
for i = 1:datasize(1)
    celltracks = nt{i,:};
        tracks = celltracks;
        tracks = tracks * pixel;
        [track_D]=RoG(tracks);
        Dtot = vertcat(Dtot,track_D);
        celly =[{tracks} track_D];
        SingleCell = vertcat(SingleCell, celly);
end
end