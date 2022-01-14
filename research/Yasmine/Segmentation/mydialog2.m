
function mydialog2
    d = dialog('Position',[300 300 350 150],'Name','Move the Image');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 310 40],...
               'String','If in a bunch of cells move the zoom to where there isn''t cells, you don''t need much background... Click the close button when you''re done.');

    btn = uicontrol('Parent',d,...
               'Position',[140 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');
           pause
end