clear
close all
s=31; % Change to # of images in stack
sigma = 1.5; %Adjust to get proper Image [between 0.1 and 10, .8 for 2x]
back = .4201; % value of background for mask to remove dirt
fileNames = uigetfile('*.vsi','Multiselect','on','Pick Image Files');% You can change vsi to your image type
File = length(fileNames);    
for a = 1:File
    rd=bfopen(fileNames{a});
    rd2=rd{1,1};
    Name = split(fileNames{a},".");
    imwrite(rd2{1,1}, string(Name{1})+'.tif')

    
end
