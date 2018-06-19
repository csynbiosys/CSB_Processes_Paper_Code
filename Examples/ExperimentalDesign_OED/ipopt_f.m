function f=ipopt_f(x)
global n_fun_eval params 
f= AMIGO_OEDcost(x,params{:});
n_fun_eval=n_fun_eval+1; 
return
