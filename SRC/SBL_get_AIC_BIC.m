function [AIC,BIC,Chi2,NDATA,NPARS]=SBL_get_AIC_BIC(MODELS)
        

valid_model=[];

observables={};
w_res={};
for i=1:length(MODELS)
    if ~isempty(MODELS{i})
        valid_models(i)=1;
        inputs=MODELS{i}{1};
        privstruct=MODELS{i}{2};
        feval(inputs.model.mexfunction,'sim_CVODES');
        observables{i}=outputs.observables;
        feval(inputs.model.mexfunction,'cost_LSQ');
        w_res{i}=outputs.w_res;
    else
        valid_models(i)=0;
    end
end

first_valid_model=find(valid_models);
first_valid_model=first_valid_model(1);

n_data=0;
for iexp=1:inputs.exps.n_exp
    n_data=n_data+sum(sum(~isnan(inputs.exps.exp_data{iexp}(2:end,:))));
end

figure;

labels={};
counter=0;

AIC=nan(1,length(MODELS));
BIC=nan(1,length(MODELS));
NPARS=nan(1,length(MODELS));
Chi2=nan(1,length(MODELS));
NDATA=nan(1,length(MODELS));

for i=1:length(MODELS)
    
    if ~isempty(MODELS{i})
        
        NPARS(i)=MODELS{i}{1}.model.n_par;
        Chi2(i)=w_res{i}'*w_res{i};
        AIC(i)=2*NPARS(i)+Chi2(i);
        NDATA(i)=n_data;
        BIC(i)=NPARS(i)*log(NDATA(i))+Chi2(i);
        
    end
    
end


end



