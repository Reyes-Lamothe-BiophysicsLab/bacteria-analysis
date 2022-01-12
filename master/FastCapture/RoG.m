function [track_Di]=RoG(tracks)

data_mean = mean(tracks);
    sumo = 0;
    for i = 1:length(tracks)
        sumo = sumo + (tracks(i,1)-data_mean(1,1))^2 + (tracks(i,2)-data_mean(1,2))^2;
    end
    track_Di = (sumo/i)^0.5;
    end
    