function[inputs,privstruct,res_ssm]=fit_model(inputs,privstruct)

vguess= inputs.PEsol.global_theta_guess;

inputs.ivpsol.nthread=8;

problem.x_0=vguess;
problem.x_U=abs(vguess).*10;
problem.x_L(vguess>0)=0;
problem.x_L(vguess<0)=vguess(vguess<0).*10;
problem.x_L(vguess==0)=0;

problem.f=@davidObj;

inputs.nlpsol.eSS.dim_refset=30;
inputs.nlpsol.eSS.ndiverse=1000;
inputs.nlpsol.eSS.local.n1=3;
inputs.nlpsol.eSS.local.n2=3;
inputs.nlpsol.eSS.maxeval=100000;
inputs.nlpsol.eSS.maxtime=inf;

inputs.nlpsol.eSS.local.solver='fminsearch';

[res_ssm]=ess_kernel(problem,inputs.nlpsol.eSS,inputs,privstruct);

x=res_ssm.xbest;

inputs.model.par(inputs.PEsol.index_global_theta)=x;


end

function [f,g,r]=davidObj(x,inputs,privstruct)

inputs.model.par(inputs.PEsol.index_global_theta)=x;

feval(inputs.model.mexfunction,'cost_LSQ');
f=outputs.f;
r=outputs.w_res;
%disp(f);
g=[];

if(f==0),f=Inf;end

end
