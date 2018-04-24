%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to simulate the MIP model in response to a random stepwise in IPTG
% concentration specified in Run_MIP_in_silico_experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear model exps sim inputs data;

inputs.pathd.results_folder = strcat('MIP_rep',datestr(now,'yyyy-mm-dd-HHMMSS'));
inputs.pathd.short_name     = 'MIP';

% Read the model into the model variable
M3D_load_model;
load('M3DrandomStep.mat');
% Compile the model
inputs.model = model;
clear model;
inputs.pathd.runident       = 'initial_setup';

% Fixed parts of the experiment
duration = 3000;     % Duration of the experiment in second
inputs.exps.n_exp=5;
step=150;
sample=5;
ITPGmax=10;

for iexp=1:inputs.exps.n_exp
    inputs.exps.n_obs{iexp}=1;                                     % Number of observables per experiment
    inputs.exps.obs_names{iexp}=char('Fluorescence');                 % Name of the observables
    inputs.exps.obs{iexp}=char('Fluorescence=Cit_fluo');          % Observation function
    inputs.exps.exp_y0{iexp}=M3D_steady_state(inputs.model.par, 0);
    
    inputs.exps.t_f{iexp}=duration;                % Experiment duration
    
    inputs.exps.t_s{iexp}=0:sample:duration;
    inputs.exps.n_s{iexp}=length(inputs.exps.t_s{iexp});
    inputs.exps.u_interp{iexp} = 'step';
    inputs.exps.n_steps{iexp}=ceil(duration/step);
    inputs.exps.u{iexp}=data.input{iexp};
    inputs.exps.t_con{iexp} = 0:step:duration;
    
    inputs.exps.data_type = 'pseudo';
    inputs.exps.noise_type = 'hetero';
    inputs.exps.std_dev{iexp} = 0.05;
end


%================================
% CALL AMIGO2 from COMMAND LINE
%================================
AMIGO_Prep(inputs);           % To preprocess the model & generate Fortran, C or MATLAB code
AMIGO_LRank(inputs);          % To perform task LRank

