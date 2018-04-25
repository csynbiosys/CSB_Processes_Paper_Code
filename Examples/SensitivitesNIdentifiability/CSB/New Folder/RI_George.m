results_folder = ['InduciblePromoter',datestr(now,'yyyy-mm-dd-HHMMSS')];
short_name     = 'IndProm';

inputs.pathd.results_folder = results_folder;
inputs.pathd.short_name     = short_name;
inputs.pathd.runident       = 'Identifiability analysis';

%============================
% MODEL RELATED DATA
%============================
inputs.model=Model_ForStellingData_Lucia_George();

%==================================
% EXPERIMENTAL DATA
%==================================
inputs=loadExperimentSettings_Lucia_George(inputs);

  
%==================================
% RI RELATED DATA
%==================================
inputs=loadRISettings_Lucia_George(inputs);
 
 

AMIGO_Prep(inputs)  % Calls the task for pre-processing      

AMIGO_RIdent(inputs)  