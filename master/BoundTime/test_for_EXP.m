FileList = dir(fullfile(cd,'Trackmate_On_time_bound_single.mat'));
data=open(append(FileList.folder,'/',FileList.name));
[fy,fx]=ecdf(data.On_time_bound_single  ,'function','survivor');
[c,d,r] = bestexpfit(fx,fy);