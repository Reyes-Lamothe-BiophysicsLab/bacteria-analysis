clear
close all
fileNames = uigetfile('*.vsi','Multiselect','on','Pick Image Files');
File = length(fileNames); 
rename = inputdlg('Renaming','Please name image for use with SuperSegger',[1 80],{'[somebasename]'});
rename=rename{1}+"xy%dc1.tif";
foldersave='ss';
mkdir(foldersave);
for a = 1:File
    rd=bfopen(fileNames{a});
    c=uint8(rd{1,1}{1,1});
    rename2=sprintf(rename,a);
    imwrite(c,strcat(foldersave,'/',rename2))
end