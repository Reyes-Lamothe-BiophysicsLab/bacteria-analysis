function []=beeswarmbox3(ints)
save_name='beeswarmplot_n_spot.pdf';
for l=1:width(ints)
    l2=l-1;
    y=ints{1,l}; 
    x=ones(height(y),1);
    figure
    beeswarm(x,y,'sort_style','up','corral_style','omit');
    
    hold on
    if l<1.1
        ylabel('Intensity')
        xlabel('Counts for all spots')
    else
        ylabel('Intensity')
        xlabel('Counts for '+ string(l-1) + ' spot(s)')
    end
    xlim([0 2])
    ylim([0 20000])
    boxplot(y,'BoxStyle','filled','MedianStyle','target')
    if l2 == 0
        save_names = 'beeswarmplot_all_spot.pdf';
    else
    save_names = strrep(save_name, 'n', num2str(l2));
    end
    saveas(gcf,save_names)
end