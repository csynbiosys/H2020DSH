function[inputs,privstruct,res_ssm]=fit_model(inputs,privstruct,isLogicBased,INITIALU)

vguess= inputs.PEsol.global_theta_guess;

inputs.ivpsol.nthread=8;

ICs=[];
for iexp=1:length(inputs.exps.exp_data)
    ICs=[ICs inputs.exps.exp_y0{iexp}];
end

problem.x_0=[vguess ICs];

if isLogicBased
    problem.x_U=[abs(vguess).*2 ones(1,length(ICs))];
    problem.x_L=[zeros(size(vguess)) zeros(1,length(ICs))];
else
    problem.x_U=[abs(vguess).*2 ones(1,length(ICs)).*10000];
    problem.x_L=[zeros(size(vguess)) zeros(1,length(ICs))];
end

problem.f=@davidObj;

inputs.nlpsol.eSS.dim_refset=40;
inputs.nlpsol.eSS.ndiverse=1000;
inputs.nlpsol.eSS.local.n1=8;
inputs.nlpsol.eSS.local.n2=8;
inputs.nlpsol.eSS.maxeval=15000;
inputs.nlpsol.eSS.maxtime=inf;
inputs.nlpsol.eSS.local.solver='fmincon';
inputs.nlpsol.eSS.local.finish=0;

[res_ssm]=ess_kernel(problem,inputs.nlpsol.eSS,inputs,privstruct,INITIALU);

x=res_ssm.xbest;

inputs.model.par(inputs.PEsol.index_global_theta)=x;

end

function [f,g,r]=davidObj(x,inputs,privstruct,INITIALU)

inputs.model.par(inputs.PEsol.index_global_theta)=x(1:length(inputs.PEsol.index_global_theta));

counter=length(inputs.PEsol.index_global_theta)+1;


for iexp=1:length(inputs.exps.exp_data)
    inputs.exps.exp_y0{iexp}=x(counter:(counter-1+length(inputs.exps.exp_y0{iexp})));
    inputs.exps.exp_y0{iexp}(3:4)=compute_steady_state(inputs.model.par,INITIALU{iexp}(1),INITIALU{iexp}(2)) ;
    counter=counter+length(inputs.exps.exp_y0{iexp});
end

feval(inputs.model.mexfunction,'cost_LSQ');

f=outputs.f;
r=outputs.w_res;
%disp(f);
g=[];

if(f==0),f=Inf;end

for iexp=1:length(inputs.exps.exp_data)
   if outputs.sim_stats{iexp}.flag<0
      f=1e10;
   end
end

end
