
function [observables,error_data] = add_pseudo_data(MODELS,noise,file_old,file_new,model_name,append)

valid_model=[];

A1=csvread(file_old,1,0);
nExp=max(A1(:,1));

for i=1:length(MODELS)
    if ~isempty(MODELS{i})
        valid_models(i)=1;
    else
        valid_models(i)=0;
    end
end

first_valid_model=find(valid_models);
first_valid_model=first_valid_model(1);

newExp=MODELS{first_valid_model}{1}.exps;

[inputs,privstruct,INITIALU]=compile_example(model_name);

inputs.exps.n_exp=inputs.exps.n_exp+1;

iexp=inputs.exps.n_exp;
inputs.exps.exp_type{iexp} = newExp.exp_type{1};
inputs.exps.obs_names{iexp}=inputs.exps.obs_names{1};
inputs.exps.obs{iexp} =inputs.exps.obs{1};
inputs.exps.n_obs{iexp}=newExp.n_obs{1};
inputs.exps.t_f{iexp} = newExp.t_f{1};
inputs.exps.n_s{iexp} = newExp.n_s{1};
inputs.exps.t_s{iexp} = newExp.t_s{1};
inputs.exps.exp_data{iexp} = nan(inputs.exps.n_obs{1},inputs.exps.n_s{1});
inputs.exps.error_data{iexp} =newExp.error_data{1};
inputs.exps.u_interp{iexp}=newExp.u_interp{1};
inputs.exps.n_steps{iexp}=newExp.n_steps{1};
inputs.exps.t_con{iexp}=newExp.t_con{1};
inputs.exps.u{iexp}=newExp.u{1};
[IC1,IC2]=compute_steady_state(inputs.model.par,newExp.u{1}(1,1),newExp.u{1}(2,1));
inputs.exps.exp_y0{iexp}=[newExp.exp_y0{1}(1:2) IC1 IC2];

inputs.model.compile_model=1;
[inputs,privstruct]=AMIGO_Prep(inputs);

feval(inputs.model.mexfunction,'sim_CVODES');

tempInputs=inputs;

MAT=[];

error_data={};
observables= outputs.observables;

iexp=inputs.exps.n_exp;

error_data{iexp}=randn(size(outputs.observables{iexp})).*noise.*outputs.observables{iexp};
outputs.observables{iexp}=outputs.observables{iexp}+error_data{iexp};
outputs.observables{iexp}(outputs.observables{iexp}<0)=0;


n_stimuli=inputs.model.n_stimulus;
time=inputs.exps.t_s{iexp};
n_obs=inputs.exps.n_obs{iexp};

mat=nan(length(time),2+n_stimuli+2.*n_obs);
mat(:,1)=nExp+1;
mat(:,2)=time;

if length(inputs.exps.t_con{iexp})>1
    
    for tconj=2:length(inputs.exps.t_con{iexp})
        index=find(time<inputs.exps.t_con{iexp}(tconj) & time>=inputs.exps.t_con{iexp}(tconj-1) );
        mat(index,3:(2+n_stimuli))=repmat(inputs.exps.u{iexp}(:,tconj-1),1,length(index))';
    end
    mat(end,3:(2+n_stimuli))=inputs.exps.u{iexp}(:,end);
else
    stop('Check your controls time');
end

mat(:,2+n_stimuli+1:2+n_stimuli+n_obs)=outputs.observables{iexp};
mat(:,2+n_stimuli+n_obs+1:2+n_stimuli+n_obs+n_obs)=noise.*outputs.observables{iexp};

MAT=[MAT;mat];

stimuli_names=cell(1,n_stimuli);

for i=1:n_stimuli
    stimuli_names{i}=['TR_' inputs.model.stimulus_names(i,:)];
end

obs_names=cell(1,n_obs);
for i=1:n_obs
    obs_names{i}=['READOUT_' strrep(inputs.exps.obs_names{1}(i,:),'_o','')];
end

std_names=cell(1,n_obs);
for i=1:n_obs
    std_names{i}=['STD_' strrep(inputs.exps.obs_names{1}(i,:),'_o','')];
end

T=array2table([A1;MAT],'VariableNames',{'Experiment','Time',stimuli_names{:},obs_names{:},std_names{:}});
writetable(T,file_new);

end