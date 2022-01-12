function [out]=STD_ma(ima)
len=length(ima);
[r,c]=size(ima(:,:,1));
a1=zeros(r,c,len);
for l=1:len
    po=double(ima(:,:,l));
    a1(:,:,l)=po;
end
out=std(a1,0,[3]);
end