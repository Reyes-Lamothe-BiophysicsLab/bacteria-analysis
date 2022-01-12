function [im]=paint(im)
%[x,y]=size(im);
warning off
imshow(im,[])
promptMessage = ('Clean up Crew');
titleBarCaption = 'How think the paint?';
button = questdlg(promptMessage, titleBarCaption, 'Small','Medium','Large','Large');
if strcmpi(button, 'Medium')
    W=1;
elseif strcmpi(button, 'Large')
    W=2;
elseif strcmpi(button, 'Small')
W=0;
end
he= true;
while he
im2=im;
again = true;
while again
    w=W;
    imshowpair(im2,im)
    promptMessage = ('Seperate Cells?');
    titleBarCaption = 'What are we doing?';
    button = questdlg(promptMessage, titleBarCaption, 'Draw', 'Quit', 'Quit');
    if strcmpi(button, 'Quit')
        break;
    end
    im3=im2;
    imshowpair(im3,im2)   
    h = drawfreehand;
    pix=unique(round(h.Position),'rows');
    [b,~]=size(pix);
    for l2=1:b   
    p1= pix(l2,:);
    im3([p1(2)-w:p1(2)+w],[p1(1)-w:p1(1)+w])=0;
    end
    imshowpair(im3,im2)
    promptMessage = ('Did you make a mistake?');
    titleBarCaption = 'Seperate Cells?';
    button2 = questdlg(promptMessage, titleBarCaption, 'No', 'Yes', 'yes');
    if strcmpi(button2, 'No')
        im2=im3;
    end
end
now = true;
   im=im2;
while now
    imshow(im,[],'InitialMagnification','fit')
    promptMessage = ('Clean up Background?');
    titleBarCaption = 'What are we doing?';
    button = questdlg(promptMessage, titleBarCaption, 'Draw', 'Quit', 'Quit');
    if strcmpi(button, 'Quit')
        break;
    end
    im2=im;
    imshow(im2,[],'InitialMagnification','fit')    
    h = drawfreehand;
    pix=unique(round(h.Position),'rows');
    [b,~]=size(pix);
    w=2;
    for l2=1:b   
    p1= pix(l2,:);
    try
    im2([p1(2)-w:p1(2)+w],[p1(1)-w:p1(1)+w])=0;
    catch ME 
        continue
    end
    end
    imshow(im2,[],'InitialMagnification','fit')
    promptMessage = ('Did you make a mistake?');
    titleBarCaption = 'Clean up Background?';
    button2 = questdlg(promptMessage, titleBarCaption, 'No', 'Yes', 'yes');
    if strcmpi(button2, 'No')
        im=im2;
    end
end  
close all
a5=imbinarize(im);
a6=bwareafilt(a5,[50 20000]);
a7=imclearborder(a6);
 imshow(a7,[],'InitialMagnification','fit')
 promptMessage = ('Do the Cell look good');
 titleBarCaption = 'Are you happy?';
 button2 = questdlg(promptMessage, titleBarCaption, 'Yes', 'No', 'No');
 if strcmpi(button2, 'Yes')
        break;
  end
end
im=a7;
end