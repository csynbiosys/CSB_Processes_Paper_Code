%list of the data to analyse
filelist={'Step.mat','Pulse.mat','Random.mat'};
%alpha level
alpha=0.1;

%set up the boundary, only for plotting
%global_theta_max = [0.4950,0.4950,4.9,10,0.23,6.8067,0.2449,0.0217];
%global_theta_min = [3.88e-5,3.88e-2,0.5,2,7.7e-3,0.2433,5.98e-5,0.012];
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
    param.mean=nan(p,1);
    param.min=param.mean;
    param.max=param.mean;
    
    for paramIndex=1:p
            %call the function and save the mean and the min, max, of the
            %region
            [param.mean(paramIndex),param.min(paramIndex),...
                param.max(paramIndex)]...
                =credibleIntervalContinuous(parameters{paramIndex}(:,t),alpha,...
                [file{1}(1:end-4),'-',parNames(paramIndex,:),...
                '(alpha=',num2str(alpha),', HPDI).fig']);
    end
    %save the data
    save([file{1}(1:end-4),'HPDI alpha=',num2str(alpha),'.mat'],'param');
end