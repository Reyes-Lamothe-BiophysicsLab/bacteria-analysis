clear ;close all;
a= uigetfile('*.vsi', 'Pick Fluorescent Image', 'Multiselect', 'on'); % Fluorescent image
LENGTH= length(a);
image = inputdlg('Where you at now?','What Image are we at?',[1 80],{'1'});    
li = str2double(cell2mat(image));
for l=1:LENGTH
    yes=true;
    while yes
    a1=bfopen(a{1,l});
    a2=a1{1,1}{1,1};
    originalImage =a2 ;
     mi=min(originalImage);
    mi=min(mi);
    ma=max(originalImage);
    ma=max(ma);
    [rows, columns, numberOfColorChannels] = size(originalImage);
    subplot(1, 3, 1);
     imshow(originalImage);
    title('Original Image, Draw ROI Here');
    subplot(1, 3, 2);
     imshow(originalImage, []);
    subplot(1, 3, 3);
    imshow(originalImage, []);
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]); % Maximize figure.
    %set(gcf,'name','Workflow','numbertitle','off')
    axis on;
    again = true;
    while again
    promptMessage = ('Draw cell or background?');
    titleBarCaption = 'What are we doing?';
    button = questdlg(promptMessage, titleBarCaption, 'Cell','Background', 'Quit', 'Quit');
    if strcmpi(button, 'Quit')
        break;
    elseif strcmpi(button, 'Cell')
       subplot(1, 3, 1);
       mydialog
       pause
       [CELL, x1, y1] = roipoly();
       subplot(1, 3, 2); % Switch to upper right image axes.
       hold on;
       plot(x1, y1, 'r-', 'LineWidth', 2);
       title('Cell');
    elseif strcmpi(button, 'Background')  
       subplot(1, 3, 1);
       mydialog2
       pause
       [BACK, x2, y2] = roipoly();
       subplot(1, 3, 3); % Switch to upper right image axes.
       hold on;
       plot(x2, y2, 'r-', 'LineWidth', 2);
       title('Background');
    end
    end
    close 
    statsc = regionprops(CELL,a2,'MaxIntensity','MeanIntensity','MinIntensity','PixelValues');
    statsb = regionprops(BACK,a2,'MaxIntensity','MeanIntensity','MinIntensity','PixelValues');
    if statsb.MaxIntensity < statsc.MinIntensity
        a3=a2;
        a3(a3<statsb.MaxIntensity)=0;
    else
        a3=a2;
        a3(a3<statsc.MinIntensity)=0; 
    end
    imshow(a3,[],'InitialMagnification','fit')
     promptMessage = ('Do the Cell look good');
     titleBarCaption = 'Are you happy?';
     button2 = questdlg(promptMessage, titleBarCaption, 'Yes', 'No, Please Restart', 'No, Please Restart');
     if strcmpi(button2, 'Yes')
            break;
      end
  
    end
a4=paint(a3);    
a8.mask_cell=a4;
file=string(a(1,1));
file=strsplit(file,'_');
file=file{1, 1};
ll=string(li);
name=file + "_" + ll + "_seg.mat";
save(name,'a8')
li=li+1;
end