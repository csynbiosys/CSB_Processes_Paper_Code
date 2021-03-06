%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TITLE: Dynamic Flux Balance Analysis of Diauxic Growth in Escherichia
%        coli
%        From:
%        Mahadevan R., Edwards J.S., Doyle FJ III
%        Biophysical J. 83:1331-1340, 2002
%
%        This example considers the Instantaneous Objective function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%======================
% PATHS RELATED DATA
%======================

inputs.pathd.results_folder='DFBA_test';         % Folder to keep results (in Results) for a given problem          
inputs.pathd.short_name='dfba_test';                           % To identify figures and reports for a given problem   

%======================
% MODEL RELATED DATA
%======================

inputs.model.input_model_type='charmodelC';                % Model introduction                                             
inputs.model.n_st=12;                                      % Number of states      
inputs.model.n_par=4;                                      % Number of model parameters 
inputs.model.n_stimulus=4;                                 % Number of inputs, stimuli or control variables   
inputs.model.st_names=char('Glcxt','Ac','O2','XX','time',...
                 'Obj','Const','CGlc','CAc','CO2','CXX','CV');  % Names of the states                                              
inputs.model.par_names=char('kLa','X0','muSC','Km');       % Names of the parameters                     
inputs.model.stimulus_names=char('v1','v2','v3','v4');     % Names of the stimuli, inputs or controls                      
inputs.model.eqns=...                                      % Equations describing system dynamics. Time derivatives are regarded 'd'st_name''
               char('dGlcxt=(-9.46*v2-9.84*v3-19.23*v4)*XX',...
                    'dAc=(-39.43*v1+1.24*v3+12.12*v4)*XX',...
                    'dO2=(-35*v1-12.92*v2-12.73*v3)*XX + kLa*(0.21-O2)',...
                    'dXX=(v1+v2+v3+v4)*XX',...
                    'dtime=1',...
                    'dObj=XX/(X0*exp(muSC*time))',...
                    'dConst=(fmax((9.46*v2+9.84*v3+19.23*v4)-((10.0*Glcxt)/(Km+Glcxt)),0))^2',...
                    'dCGlc=(fmax(-Glcxt,0))^2',...
                    'dCAc=(fmax(-Ac,0))^2',...
                    'dCO2=(fmax(-O2,0))^2',...
                    'dCXX=(fmax(-XX,0))^2',...
                    'dCV=(fmax((35*v1+12.92*v2+12.73*v3)-15,0))^2');
                
kLa=7.5;                
X0=0.001;
muSC=0.007;
Km=0.15;
inputs.model.par=[kLa X0 muSC Km];                       % Nominal value of parameters        

%==========================================
% Dynamic optimization problem formulation
%==========================================
 inputs.DOsol.y0=[10.8 0.4 0.21 0.001 0 1 0 0 0 0 0 0];    %Initial conditions for simulation
 inputs.DOsol.tf_type='fixed';                           % Process duration (fixed or optimized 'od')
 inputs.DOsol.tf_guess=10;                               % Process duration 



 % COST FUNCTION
 
 inputs.DOsol.DOcost_type='max';                         % max/min
 inputs.DOsol.DOcost='Obj';                              % In this case maximize instant biomass production

 % ALGEBRAIC CONSTRAINTS
 
 % END POINT CONSTRAINTS. Note that to define PATH CONSTRAINTS new states have to be added to the system
 % dynamics. This allows to transform Path into final-time constraints.

 inputs.DOsol.n_const_ineq_tf=6;
 inputs.DOsol.const_ineq_tf=char('CGlc','CAc','CO2','CXX','Const','CV');  % c(y,u,tf)<=0
 inputs.DOsol.ineq_const_max_viol=1.0e-5;
  
 
% CVP DETAILS
  
 inputs.DOsol.u_interp='linear';                                      % Stimuli definition 
                                                                     % OPTIONS:u_interp:
                                                                     % 'sustained' |'step'|'stepf'|'linear'(default)|'pulse-up'|'pulse-down' 
 inputs.DOsol.n_linear=2+1;
 inputs.DOsol.u_guess(1,:)=0.15*ones(1,inputs.DOsol.n_linear);       % Initial guess for the input 
 inputs.DOsol.u_min(1,:)=1e-7*ones(1,inputs.DOsol.n_linear);
 inputs.DOsol.u_max(1,:)=0.5*ones(1,inputs.DOsol.n_linear);          % Minimum and maximum value for the input
 
 inputs.DOsol.u_guess(2,:)=0.15*ones(1,inputs.DOsol.n_linear);        % Initial guess for the input 
 inputs.DOsol.u_min(2,:)=1e-7*ones(1,inputs.DOsol.n_linear);
 inputs.DOsol.u_max(2,:)=1.0*ones(1,inputs.DOsol.n_linear);           % Minimum and maximum value for the input
 
 inputs.DOsol.u_guess(3,:)=0.15*ones(1,inputs.DOsol.n_linear);        % Initial guess for the input 
 inputs.DOsol.u_min(3,:)=1e-7*ones(1,inputs.DOsol.n_linear);
 inputs.DOsol.u_max(3,:)=0.5*ones(1,inputs.DOsol.n_linear);           % Minimum and maximum value for the input
 
 inputs.DOsol.u_guess(4,:)=0.15*ones(1,inputs.DOsol.n_linear);        % Initial guess for the input 
 inputs.DOsol.u_min(4,:)=1e-7*ones(1,inputs.DOsol.n_linear);
 inputs.DOsol.u_max(4,:)=0.5*ones(1,inputs.DOsol.n_linear);           % Minimum and maximum value for the input
 
 inputs.DOsol.t_con=linspace(0,inputs.DOsol.tf_guess,inputs.DOsol.n_linear);
 
 
 inputs.DOsol.u_guess=[0.15 0.25 0.4 
                       1.0  0.4  0.1  
                       0.1  0.01 0.3 
                      0.05 0.25 0.4 ];



 %==================================
 % NUMERICAL METHODS RELATED DATA
 %==================================
 %
 % SIMULATION
 
 inputs.ivpsol.rtol=1e-7;
 inputs.ivpsol.atol=1e-7;
  
 % OPTIMIZATION
inputs.nlpsol.nlpsolver='eSS';                         % [] NLP solver: 
                                                       % LOCAL: 'local_fmincon'|'local_fminsearch'|'local_dhc'|
                                                       %        'local_ipopt'|'local_solnp'|'local_nomad'|
                                                       % MULTISTART:'multi_fmincon'|'multi_n2fb'|'multi_dn2fb'|'multi_dhc'|
                                                       %            'multi_ipopt'|'multi_solnp'|'multi_nomad'|
                                                       % GLOBAL: 'de'|'sres'
                                                       % HYBRID: 'hyb_de_fmincon'|'hyb_de_fminsearch'|'hyb_de_dhc'|'hyp_de_ipopt'|
                                                       %         'hyb_de_solnp'|'hyb_de_nomad'
                                                       %         'hyb_sres_fmincon'|'hyb_sres_fminsearch'|'hyb_sres_dhc'|
                                                       %         'hyp_sres_ipopt'|'hyb_sres_solnp'|'hyb_sres_nomad'|
                                                       % METAHEURISTICS:
                                                       % 'ess'(DEFAULT)

                                                       
inputs.nlpsol.eSS.log_var = [1:1:4*inputs.DOsol.n_linear];  % All variables are considered in log-scale
inputs.nlpsol.eSS.maxeval = 500000;                    % Maximum number of function evaluations
inputs.nlpsol.eSS.maxtime = 1200;                      % Maximum computational effort in seconds
inputs.nlpsol.eSS.local.solver =0;                     % Local method- SQP
inputs.nlpsol.eSS.local.finish = 0;                    % Local method- SQP

 