function [average,lb,ub,all] = credibleInterval2...
    (data,alpha,numInterval,varargin)
%generate the credible interval (Highest Posterior Density Region)based on
%the given data and alpha value. The last parameter is the name of the
%figure file, if the user want to have a record of this.

mind=min(data);
maxd=max(data);
d=(maxd-mind)/(numInterval);

%count with 1000 intervals
x=linspace(mind,maxd,numInterval+1);
p=ksdensity(data,x,'Bandwidth',d);
p=p/sum(p);

[sorted,map]=sort(p,'descend');
xt=x(map);
all=xt(cumsum(sorted)<=(1-alpha));

%variable 'all' saves all the regions with the frequency larger than Ns.
%e.g. if the region is [0.1,0.2],[0.2,0.3],[0.4,0.5], all would be:
%all=[0.1,0.2,0.4]
Ps=sorted(length(all));
all=sort(all);
lb=all(1);
ub=all(end);
average=mean(data);

%if there is a gap in the region as wide as 5 intervals, send out a warning
if (max(diff(all))>2*d)
    warning('There is at least one gap in the region.');
end

%draw the figure and save it if the user provide a file name.
if ~isempty(varargin)
    figure();
    histogram(data,numInterval);
    hold on;
    plot(x,p*length(data));
    ax=gca;
    plot(ax.XLim,[Ps,Ps],'b-','LineWidth',1);
    plot([average,average],ax.YLim,'r-','LineWidth',2);
    plot([lb,lb],ax.YLim,'m-','LineWidth',1);
    plot([ub,ub],ax.YLim,'m-','LineWidth',1);
    title({'Credible Interval (Highest Posterior Density Region)';
        ['(with Alpha=',num2str(alpha),')']});
    legend('Bootstrapped Results','Frequency Limit',...
        ['Mean = ',num2str(average,'%10.3e')],...
        ['Lower Boundary = ',num2str(lb,'%10.3e')],...
        ['Upper Boundary = ',num2str(ub,'%10.3e')]);
    xlabel('Parameter Values');
    ylabel('Frequency');
    set(ax,'FontSize',14);
    savefig(varargin{1});
    hold off;
end
end