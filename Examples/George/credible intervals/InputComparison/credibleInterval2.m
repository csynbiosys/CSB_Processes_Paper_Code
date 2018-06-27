function [average,lb,ub,drec,all] = credibleInterval2...
    (data,alpha,varargin)
%generate the credible interval (Highest Posterior Density Region)based on
%the given data and alpha value. The last parameter is the name of the
%figure file, if the user want to have a record of this.

mind=min(data);
maxd=max(data);
numInterval=1000;
d2=2*iqr(data)*length(data)^(-1/3);
%d2=(0.75*length(data))^(-1/5);
%count with 1000 intervals
x=linspace(mind,maxd,numInterval+1);
d=x(2)-x(1);
drec=nan(20,1);
for count=1:19
    p=ksdensity(data,x,'Bandwidth',d2,'Kernel','epanechnikov');
    p=p/sum(p);
    pt=[0,p,0];
    M=sum((pt(1:end-2)+pt(3:end)-2*pt(2:end-1)).^2)/d^3;
    drec(count)=d2;
    d2=(3/(sqrt(125)*length(data)*M))^(1/5);
    if abs(drec(count)-d2)<(d/100)
        break;
    end
end
drec(count+1)=d2;
[sorted,map]=sort(p,'descend');
xt=x(map);
all=xt(cumsum(sorted)<=(1-alpha));

%variable 'all' saves all the regions with the frequency larger than Ns.
%e.g. if the region is [0.1,0.2],[0.2,0.3],[0.4,0.5], all would be:
%all=[0.1,0.2,0.4]
Ps=sorted(length(all))*length(data)/d*d2;
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
    histogram(data,ceil((maxd-mind)/d2));
    hold on;
    plot(x,p*length(data)/d*d2);
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