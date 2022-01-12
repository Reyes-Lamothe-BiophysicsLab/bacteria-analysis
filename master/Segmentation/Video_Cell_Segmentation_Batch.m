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
    low=median(LOW);
    med=median(MED);
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
    stats = regionprops(image_label,imageread,'PixelList','PixelIdxList');
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
           sed=double(rd2{i,1});
           s=sed.*single2;
           Pix=regionprops(imresize(single2, 2, 'nearest'),imresize(s, 2, 'nearest'),'PixelList','PixelValues');
           s=imcrop(s,pix.BoundingBox);
           s11=imcrop(single2,pix.BoundingBox);
           s = imresize(s, 2, 'nearest');
           s11 = imresize(s11, 2, 'nearest');
           s10=imrotate(s,-(pix.Orientation),'bilinear','loose');
           s11=imrotate(s11,-(pix.Orientation),'bilinear','loose');
           pix10=regionprops(s11,'PixelList','BoundingBox','MinorAxisLength','MajorAxisLength','Orientation','Centroid');
           s100=imcrop(s10,pix10.BoundingBox);
           s110=imcrop(s11,pix10.BoundingBox);
           pix100=regionprops(s110,'PixelList','BoundingBox','MinorAxisLength','MajorAxisLength','Orientation','Centroid');
           s2=s100;
           [pix2,pix3]=find(s100);
           dime=size(s100);
           for x2=1:dime(1,1)
               for y2=1:dime(1,2)
                   if s2(x2,y2) < (low*1.5)
                    r=((med-(0.12*med)) + ((med+(0.1*med))-(med-(0.12*med)))* rand(1,1));
                    s2(x2,y2)=r;
                   end   
               end
           end
            s3=uint16(s2);
           files= strrep(fileNames{k},'.vsi', ll + '.mat');
           pix.image=k;
           pix.cell=L;
           pix.Centroid2=pix10.Centroid;
           pix.Centroid3=pix100.Centroid;
           pix.PixelList2=Pix.PixelList;
           pix.PixelValues=Pix.PixelValues;
           save(files,'pix')
           filename= strrep(fileNames{k},'.vsi', ll + '.tif');
           imwrite(s3,filename,'WriteMode','append');
           s3=[];
           s=[];
           s2=[];
           ss=[];
        end
    end
    toc
end