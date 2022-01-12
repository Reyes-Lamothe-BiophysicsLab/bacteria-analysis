clear
close all
s=31; % Change to # of images in stack
sigma = 5; %Adjust to get proper Image [between 0.1 and 10]
back = 0.4201; % value of background for mask to remove dirt
fileNames = uigetfile('*.vsi','Multiselect','on','Pick Image Files');% You can change vsi to your image type
File = length(fileNames);    
for a = 1:File
rename = inputdlg('Renaming','Please rename image for use with SuperSegger',[1 80],{' [somebasename]xy[number]c1.tif'});
    rd=bfopen(fileNames{a});
    rd2=rd{1,1};
B = flip(rd2);
    for i = 1:s 
    tf(:,:,i) = B{i,1}; % read stacks
    end
[sizeX,sizeY,sizeZ] = size(tf);
corr = zeros(sizeX,sizeY);
mask = corr;

%% integrate derivative of gaussian along Z axis using trapezoidal rule
w = waitbar(0,'Integrating ...');
intmat = zeros(sizeX,sizeY,sizeZ);
z = 1:sizeZ;
zf = length(z)/2;
for x = 1:sizeX  
    waitbar(x/sizeX) 
    for y = 1:sizeY 
        Iz = double(reshape(tf(x,y,:),[1,sizeZ]));
        int = Iz.*(z-zf).*exp(-(zf-z).^2/(2*sigma^2));
        intmat(x,y,:) = int;
    end
end
close(w);
corr = trapz(intmat,3);
corr1 = corr-min(min(corr));
corr2 = corr1/max(max(corr1));
corr3 = im2uint8(corr2);
% se = strel('disk',3);
% c1= imtophat(corr,se);
corr4=imcomplement(corr2);
corr5=imadjust(corr4);
corr5=double(corr5);
corr6=imbinarize(corr3);
amp = strel('sphere',4);
corr7=imdilate(corr6,amp);
LB=100;
corr8=bwareaopen(corr7,LB);
correct= corr5.*corr8;
correct= imcomplement(correct);
corr9 = double(corr8);
corr9(corr9==0)=back;
corrected = correct.*corr9;
c=imcomplement(corrected);
figure
imshow(c)
imwrite(c,rename{1})
clear corrected rename
end