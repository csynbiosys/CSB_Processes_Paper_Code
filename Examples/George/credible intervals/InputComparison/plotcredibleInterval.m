%list of the data to analyze
filelist={'Step.mat','Pulse.mat','Random.mat'};
%alpha level
alpha=0.1;

%set up the boundary, only for plotting
global_theta_max = [0.4950,0.4950,4.9,10,0.23,6.8067,0.2449,0.0217];
global_theta_min = [3.88e-5,3.88e-2,0.5,2,7.7e-3,0.2433,5.98e-5,0.012];
% clear global_theta_max global_theta_min %uncomment to disable the boundary

% load the parameter names and the true values
InduciblePromoter_load_model_optimised;
parNames=model.par_names;
trueValues=model.par;
clear model;

for file=filelist
    %load the file
    load(file{1});
    
    %number of PE for each trial
    t=size(fullPEresults,2);
    %number of parameters
    p=length(parameters);
    
    %set the default values to NaN matrices as pre-allocation, and any
    %errors in the data could be clearly seen (comparing to overwriting or
    %initializing as zeros).
    param.mean=nan(t,p);
    param.min=param.mean;
    param.max=param.mean;
    
    for paramIndex=1:p
        for time=1:t
            %call the function and save the mean and the min, max, of the
            %region
            [param.mean(time,paramIndex),param.min(time,paramIndex),...
                param.max(time,paramIndex)]...
                =credibleInterval(parameters{paramIndex}(:,time),alpha);
        end
        figure();
        %High Density Interval
        fill([1:t,t:-1:1],...
            [param.min(:,paramIndex)',fliplr(param.max(:,paramIndex)')],...
            [0.9,0.9,0.9]);
        hold on;
        plot(param.mean(:,paramIndex),'k-o');
        plot(param.min(:,paramIndex),'m-*');
        plot(param.max(:,paramIndex),'m-+');
        %true value
        ax=gca;
        plot(ax.XLim,[trueValues(paramIndex),trueValues(paramIndex)],'r-');
        legend('90% High Density Interval','Mean Trajectory',...
            'Lower Boundary','Upper Boundary','True Value');
        %rescale of the boundaries of the parameters are given.
        %and save the figure.
        if (exist('global_theta_min','var')*exist('global_theta_max','var')==1)
            ax.YLim=[global_theta_min(paramIndex),global_theta_max(paramIndex)];
            title({'Credible Interval (Highest Posterior Density Region)';
                [file{1}(1:end-4),'-',parNames(paramIndex,:),', alpha=',...
                num2str(alpha),'), fixed scale']});
            savefig([file{1}(1:end-4),'-',parNames(paramIndex,:),...
            '(alpha=',num2str(alpha),', fixed scale).fig']);
        else
            title({'Credible Interval (Highest Posterior Density Region)';
                [file{1}(1:end-4),'-',parNames(paramIndex,:),' (alpha=',...
                num2str(alpha),'), auto scale']});
            savefig([file{1}(1:end-4),'-',parNames(paramIndex,:),...
            '(alpha=',num2str(alpha),', auto scale).fig']);
        end        
    end
    %save the data
    save([file{1}(1:end-4),'CIdata alpha=',num2str(alpha),'.mat'],'param');
end