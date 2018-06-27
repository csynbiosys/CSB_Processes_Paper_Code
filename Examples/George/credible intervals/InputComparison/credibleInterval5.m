function [average,lb,ub,all] = credibleInterval5...
    (data,alpha,varargin)
%generate the credible interval (Highest Posterior Density Region)based on
%the given data and alpha value. The last parameter is the name of the
%figure file, if the user want to have a record of this.

mind=min(data);
maxd=max(data);
dt=2*iqr(data)*length(data)^(-1/3);
if (maxd-mind)/dt<20
    dt=(maxd-mind)/20;
elseif (maxd-mind)/dt>40
    dt=(maxd-mind)/40;
else
    dt=(maxd-mind)/ceil((maxd-mind)/dt);
end

[p,x] = histcounts(data,linspace(mind,maxd,round((maxd-mind)/dt)));
p=p/length(data);
d=x(2)-x(1);
[sorted,map]=sort(p,'descend');
xt=x(map);
all=xt(cumsum(sorted)<=(1-alpha));

%variable 'all' saves all the regions with the frequency larger than Ns.
%e.g. if the region is [0.1,0.2],[0.2,0.3],[0.4,0.5], all would be:
%all=[0.1,0.2,0.4]
Ps=sorted(length(all))*length(data)/d*dt;
all=sort(all);
lb=all(1);
ub=all(end)+d;
average=mean(data);

%if there is a gap in the region as wide as 5 intervals, send out a warning
if (max(diff(all))>2*d)
    warning(['There is at least one gap in the figure: ',varargin{1}]);
end

%draw the figure and save it if the user provide a file name.
if ~isempty(varargin)
    figure();
    histogram(data,linspace(mind,maxd,round((maxd-mind)/dt)));
    hold on;
    data2=data(arrayfun(@(x) (min((all-(x+d/2)).^2)<=(d/2)^2),data));
    histogram(data2,linspace(mind,maxd,round((maxd-mind)/dt)));
    ax=gca;
    plot(ax.XLim,[Ps,Ps],'b-','LineWidth',1);
    plot([average,average],ax.YLim,'r-','LineWidth',2);
    plot([lb,lb],ax.YLim,'m-','LineWidth',1);
    plot([ub,ub],ax.YLim,'m-','LineWidth',1);
    try
        title({'Credible Interval (Highest Posterior Density Region)';
            ['(with Alpha=',num2str(alpha),')'];varargin{1}(1:11)});
    catch
        title({'Credible Interval (Highest Posterior Density Region)';
            ['(with Alpha=',num2str(alpha),')'];varargin{1}});
    end
    legend('Histrogram','Values in the HPDR',...
        'Frequency Limit',...
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