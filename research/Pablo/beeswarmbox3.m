function []=beeswarmbox3(ints)
save_name='beeswarmplot_n_spot.pdf';
for l=1:width(ints)
    l2=l-1;
    y=ints{1,l}; 
    x=ones(height(y),1);
    figure
    beeswarm(x,y,'sort_style','up','corral_style','omit');
    
    hold on
    if l2 == 0
        ylabel('Intensity')
        xlabel('Counts for all spots')
    elseif l2>0 && l2<4.9
        ylabel('Intensity')
        xlabel('Counts for '+ string(l-1) + ' spot(s)')
    elseif l2 == 5
        ylabel('Mean Intensity Cell')
        xlabel('Counts')
    end
    if l2 ==5
        xlim([0 2])
        ylim([0 3000])
    else
        xlim([0 2])
        ylim([0 20000])
    end
    boxplot(y,'BoxStyle','filled','MedianStyle','target')
    
    if l2 == 0
        save_names = 'beeswarmplot_all_spot.pdf';
    elseif l2>0 && l2<4.9
        save_names = strrep(save_name, 'n', num2str(l2));
    elseif l2 == 5
        save_names = 'beeswarmplot_MeanCellInt.pdf';
    end
    saveas(gcf,save_names)
end