clear
files='/Users/nicolassoubry/Analysis/Matlab/Masks';
fileNames = uigetfile('*.vsi','Multiselect','on','Pick Image Files');
FileList = dir(fullfile(cd, '**','*.npy'));
FileList2 = struct('folder', {FileList(1:end).folder});
FileList2= struct2table(FileList2);
FileList2=table2array(FileList2);
BF_file2=natsortfiles(FileList2);
FileList = struct('name', {FileList(1:end).name});
FileList= struct2table(FileList);
FileList=table2array(FileList);
BF_file=natsortfiles(FileList);
BF_File=BF_file2 + "/" + BF_file;
number_of_files=length(fileNames);
for k=1:number_of_files
    tic
    rd=bfopen(fileNames{1,k});
    rd2=rd{1,1};
    LOW=zeros(length(rd2(:,1)),1);
    MED=zeros(length(rd2(:,1)),1);
    for i=1:length(rd2(:,1))
        LOW(i)=min(rd2{i,1},[],'all');
        MED(i)=median(rd2{i,1},'all');
    end
    imageread=readNPY(BF_File{k,1});
    imageread=imbinarize(imageread);
    imageread=bwareaopen(imageread,20);
    imageread(1,:) = 1;
    imageread(end,:) = 1;
    imageread(:,1) = 1;
    imageread(:,end) = 1;
    imageread=imclearborder(imageread);
    se = strel('sphere', 1);
    [x,y]=size(imageread);
    image_label = bwlabel(imageread,8);
    stats = regionprops(image_label,imageread,'PixelList','PixelIdxList','BoundingBox');
    l=length(stats);
    for L=1:l
        List = (stats(L).PixelList);
        ll='_'+string(L);
        m=zeros(x,y);
        p=length(List);
        for P=1:p
            g=List(P,1);
            G=List(P,2);
            m(G,g)=1;
        end
        single=imdilate(m,se);
        test=isinf(single);
        if sum(test,'all') == 0
           single=single;
        else
            single=m;
        end
        pix=regionprops(single,'PixelList','BoundingBox','MinorAxisLength','MajorAxisLength','Orientation','Centroid');
        single2=single;
        for i=1:length(rd2(:,1))
           s=double(rd2{i,1});
           s=imcrop(s,pix.BoundingBox);
           s3=uint16(s);
           files= strrep(fileNames{k},'.vsi', ll + '.mat');
           pix.image=k;
           pix.cell=L;
           save(files,'pix')
           filename= strrep(fileNames{k},'.vsi', ll + '.tif');
           imwrite(s3,filename,'WriteMode','append');
           s3=[];
           s=[];
        end
    end
    toc
end