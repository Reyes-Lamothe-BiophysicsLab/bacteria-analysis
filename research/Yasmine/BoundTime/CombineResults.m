clear ; close all
FileList = dir(fullfile(cd, '*_Results.mat')); %'**',
t1=FileList(1).folder;
t2=split(t1,'/');
t3=t2(1:(end-2),1);
t4=join(t3,"/");
t5= {FileList.name}.';
t6=split(t5,'_');
a= t5;
    for s=1:size(t6,2)
        s2=str2num(t6{1,s});
        if isempty(s2) == 1
            ss1{s}=t6{1,s};
            continue
        elseif isempty(s2) == 0
            s3=t6(:,s);
            s4=unique(s3);
            ss2=join(ss1,'_');
            ss2=ss2 +"_";
            break
        end
    end
user_input_tracks = inputdlg({'How many channels','Channel 1','Channel 2','Channel 3'},'Results Information',...
    [1 50; 1 50; 1 50; 1 50],{'[2, 3]','STD','Red', 'Green'});
   
image = str2double(cell2mat(user_input_tracks(1, 1))); 
l= length(a);
a1=l/image;
a2=1:image:l;    
l2= length(a2);
for b=1:l2
   try
    n1=(a2(b):a2(b+1)-1);
   catch me
       n1=(a2(b):(a2(b)+image-1));
   end
    t1=[];
    for c= 1:image
        n2=n1(c);
        f=open(a{n2});
        f1{c}=f.Results.Values;
        apple=f1{1,c}(:,4);
        tf = ~any(cellfun(@(x) isequal(x,0),apple),2);
        t1=horzcat(t1,tf);
    end
    t2=sum(t1,2);
    for L=1:length(t2)
        t3=t2(L);
        if t3 == 0
            ObjCell(L,1:12) = f1{1,1}(L,1:12);
            
        elseif t3 == 1
            t4=t1(L,:);
            t5=find(t4 ==1);
            t6=f1{1,t5(1)}(L,1:12);
            n1=string(user_input_tracks{(t5(1)+1), 1});
            t10=f1{1,1}(L,1:12);
            t10(1,2) = {t6{1, 2}};
            t10(1,5:6) = {0};
            t10(1,8:12) = {0};
            t10(1,5)={n1};
            t10(1,4) ={t6{1,4}};
            t10(1,6) = {t10{1, 3}{1, 6}};
            
            ObjCell(L,1:12) = t10;
            
        elseif t3 == 2
            t4=t1(L,:);
            t5=find(t4 ==1);
            t6=f1{1,t5(1)}(L,1:12);
            t7=f1{1,t5(2)}(L,1:12);
            n1=string(user_input_tracks{(t5(1)+1), 1});
            n2=string(user_input_tracks{(t5(2)+1), 1});
            t6a=t6{1,4};
            [x1,~]=size(t6a);
            t6b=repmat(n1,x1,1);
            t7a=t7{1,4};
            [x2,~]=size(t7a);
            t7b=repmat(n2,x2,1);
            t8=vertcat(t6a,t7a);
            t9=vertcat(t6b,t7b);
            t10=f1{1,1}(L,1:12);
            t10(1,5:6) = {0};
            t10(1,8:12) = {0};
            t10(1,2) = {x1+x2};
            t10(1,4) ={t8};
            t10(1,5) = {t9};
            t10(1,6) = {t10{1, 3}{1, 6}};
            ObjCell(L,1:12) = t10;
        elseif t3 == 3
            t4=f1{1,1}(L,1:12);
            t5=f1{1,2}(L,1:12);
            t6=f1{1,3}(L,1:12);
            n1=string(user_input_tracks{2, 1});
            n2=string(user_input_tracks{3, 1});
            n3=string(user_input_tracks{4, 1});
            t4a=t4{1,4};
            t5a=t5{1,4};
            t6a=t6{1,4};
            [x1,~]=size(t4a);
            [x2,~]=size(t5a);
            [x3,~]=size(t6a);
            t4b=repmat(n1,x1,1);
            t5b=repmat(n2,x2,1);
            t6b=repmat(n3,x3,1);
            t8=vertcat(t4a,t5a,t6a);
            t9=vertcat(t4b,t5b,t6b);
            t10=f1{1,1}(L,1:12);
            t10(1,5:6) = {0};
            t10(1,8:12) = {0};
            t10(1,2) = {x1+x2+x3};
            t10(1,4) ={t8};
            t10(1,5) = {t9};
            t10(1,6) = {t10{1, 3}{1, 6}};
            ObjCell(L,1:12) = t10;
        end
    end
    rs.Values=ObjCell;
    
    name= ss2 + "%d_CombinedResults.mat";
    filename=sprintf(name,b);
    save(filename,'rs');
end