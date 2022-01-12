function []=beeswarmPythonData()
    [file,folder]= uigetfile('*.csv', 'Pick Fluorescent Image', 'Multiselect', 'on');
    rename = inputdlg('Figure Name','Input name to save figure',[1 80],{'[somebasename].pdf'});
    rename=append(folder,rename{1,1});
    data=readmatrix(append(folder,file));
    y=data(2:end,2);
    x=ones(height(y),1);
    beeswarm(x,y,'sort_style','up','corral_style','omit');
    hold on
    boxplot(y,'BoxStyle','filled','MedianStyle','target');
    saveas(gcf,rename)
end