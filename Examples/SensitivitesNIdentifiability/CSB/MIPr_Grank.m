%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to simulate the MIP model in response to a random stepwise in IPTG
% concentration specified in Run_MIP_in_silico_experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear model exps sim inputs data;

inputs.pathd.results_folder = strcat('MIP_rep',datestr(now,'yyyy-mm-dd-HHMMSS'));
inputs.pathd.short_name     = 'MIP';

% Read the model into the model variable
%M3D_load_model;
MIP_with_scaling_factor;
load('M3DrandomStep.mat');
% Compile the model
inputs.model = model;
clear model;
inputs.pathd.runident       = 'initial_setup';

% Fixed parts of the experiment
duration = 3000*60;     % Duration of the experiment in second
inputs.exps.n_exp=length(data.input);
step=150*60;
sample=5*60;
ITPGmax=10;

for iexp=1:inputs.exps.n_exp
    inputs.exps.n_obs{iexp}=1;                                     % Number of observables per experiment
    inputs.exps.obs_names{iexp}=char('Fluorescence');                 % Name of the observables
    inputs.exps.obs{iexp}=char('Fluorescence=Cit_AU');          % Observation function
    inputs.exps.exp_y0{iexp}=M3D_steady_state2(inputs.model.par, 0);
    
    inputs.exps.t_f{iexp}=duration;                % Experiment duration
    
    inputs.exps.t_s{iexp}=0:sample:duration;
    inputs.exps.n_s{iexp}=length(inputs.exps.t_s{iexp});
    inputs.exps.u_interp{iexp} = 'step';
    inputs.exps.n_steps{iexp}=ceil(duration/step);
    inputs.exps.u{iexp}=data.input{iexp};
    inputs.exps.t_con{iexp} = 0:step:duration;
    
    inputs.exps.data_type = 'pseudo';
    inputs.exps.noise_type = 'homo_var';
    inputs.exps.std_dev{iexp} = 0.05;
end

%============================================
% PARAMETERS TO BE CONSIDERED IN THE ANALYSIS
%============================================

inputs.PEsol.id_global_theta=inputs.model.par_names([true(1,8),false],:);


inputs.PEsol.global_theta_guess=inputs.model.par([true(1,8),false]);
inputs.PEsol.global_theta_max=[0.4950,0.4950,4.9,10,0.23,6.8067,0.2449,0.0217];
inputs.PEsol.global_theta_min=[3.88e-5,3.88e-2,0.5,2,7.7e-3,0.2433,5.98e-5,0.012];


%============================================
% NUMBER OF SAMPLES FOR THE ANALYSIS
%============================================

inputs.rank.gr_samples=10000;                           % Number of parameter values within the bounds
                                                        % Default:10000
input.plotd.plotlevel='min';

%================================
% CALL AMIGO2 from COMMAND LINE
%================================
AMIGO_Prep(inputs);

n=100;
recL=zeros(n,1);
recG=recL;

inputs.plotd.plotlevel='noplot';
for i=1:n
    tic;
    AMIGO_LRank(inputs);
    recL(i)=toc;
    tic;
    AMIGO_GRank(inputs);
    recG(i)=toc;
end
save('rec20182.mat','recL','recG');

return;