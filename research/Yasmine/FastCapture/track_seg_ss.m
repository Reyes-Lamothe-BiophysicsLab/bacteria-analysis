
function Tracks_seg = track_seg_ss(spotsinfo)
num_files = length(spotsinfo);
% tracks_record = num2cell(zeros(num_files,1));
%%
filename = spotsinfo;
data = csvread(spotsinfo);
data2 = sortrows(data,[1,2]);
%%
% data_track_num = csvread('MS162_diameter5_threshold250_linkdis10_gapdis5_gapclose2_Track_Statistics_01.csv',1,2)
track_id = data2(:,1);
spots_x = data2(:,3);
spots_y = data2(:,4);
% track_num = data_track_num(:,1)
track_id = track_id + 1;
tracks = horzcat(spots_x, spots_y, track_id);
total_tracks = max(tracks(:,3));
for i = 1:total_tracks
    track_find = find(tracks(:,3)==i);
    x_coord = round(mean(tracks(track_find,1)));
    y_coord = round(mean(tracks(track_find,2)));
    %Tracks_seg {i,1} = [x_coord,y_coord];
    Tracks_seg{i,1} = [tracks(track_find,1), tracks(track_find,2)];
end
% %%
% for j = 1:length(image_binary) %iterate each mask cell area 
%     Tracks_seg = cell(total_tracks,2); 
%     px_binary = image_binary{j};
%     for i = 1:total_tracks
%     track_find = find(tracks(:,3)==i);
%     x_coord = round(mean(tracks(track_find,1)));
%     y_coord = round(mean(tracks(track_find,2)));
%     row_find = find (px_binary(:,2) == y_coord);
%     
%     if isempty(row_find) ==1
%         continue
%     end
%     if ismember (x_coord, px_binary(row_find,1)) == 1
%          Tracks_seg {i,1} = [x_coord,y_coord];
%          Tracks_seg{i,2} = [tracks(track_find,1), tracks(track_find,2)];
%     else 
%         continue
%     end
%     end
%     Tracks{j} = Tracks_seg;
% end
end

