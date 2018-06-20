function [average,lb,ub,all] = credibleInterval(data,alpha,varargin)
%generate the credible interval (Highest Posterior Density Region)based on
%the given data and alpha value. The last parameter is the name of the
%figure file, if the user want to have a record of this.

%number of bootstrap samples to acquire a smooth curve with 1000 intervals,
%I choose 1e5 samples
bsCount=1e5;

%bootstrap sampling, using the parallel pool if it is already activated
bsOptions.UseParllel=true;
bsresult=bootstrp(bsCount,@mean,data,'Options',bsOptions);

%count with 1000 intervals
[N,edges] = histcounts(bsresult,1e3);

%find the frequency (Ns) coreeponds to the given alpha value.
sorted=sort(N,'descend');
Ns=sorted([false,diff(cumsum(sorted)>=bsCount*(1-alpha))==1]);

%variable 'all' saves all the regions with the frequency larger than Ns.
%e.g. if the region is [0.1,0.2],[0.2,0.3],[0.4,0.5], all would be:
%all=[0.1,0.2,0.4]
di=edges(2)-edges(1);
all=edges(N>Ns);
lb=min(all);
ub=max(all+di);
average=mean(data);

%if there is a gap in the region as wide as 5 intervals, send out a warning
if (max(diff(all))/di>5)
    warning('There is at least one significant gap in the region.');
end

%draw the figure and save it if the user provide a file name.
if ~isempty(varargin)
    figure();
    histogram(bsresult,1e3);
    hold on;
    ax=gca;
    plot(ax.XLim,[Ns,Ns],'b-','LineWidth',1);
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