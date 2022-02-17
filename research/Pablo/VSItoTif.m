clear
close all
fileNames = uigetfile('*.vsi','Multiselect','on','Pick Image Files');% You can change vsi to your image type
File = length(fileNames);    
for a = 1:File
    rd=bfopen(fileNames{a});
    rd2=rd{1,1};
    %rd2{1,1}=adapthisteq(rd2{1,1});
    Name = split(fileNames{a},".");
    imwrite(rd2{1,1}, '4iL_'+string(Name{1})+'.tif')

    
end
