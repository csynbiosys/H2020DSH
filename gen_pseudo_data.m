
function [observables,error_data] = gen_pseudo_data(exps,exps_vec,noise,file)

[inputs,privstruct,INITIALU]=compile('model1');

inputs.exps.n_exp=max(exps_vec);

for iexp=1:inputs.exps.n_exp
   
    if iexp>7
        inputs.exps.exp_type{iexp} = exps.exp_type{iexp};
        inputs.exps.obs_names{iexp}=exps.obs_names{iexp};
        inputs.exps.obs{iexp} =exps.obs{iexp};
        inputs.exps.n_obs{iexp}=exps.n_obs{iexp};
        inputs.exps.t_f{iexp} = exps.t_f{iexp};
        inputs.exps.n_s{iexp} = exps.n_s{iexp};
        inputs.exps.t_s{iexp} = exps.t_s{iexp};
        inputs.exps.exp_data{iexp} = nan(inputs.exps.n_obs{iexp},inputs.exps.n_s{iexp});
        inputs.exps.error_data{iexp} =exps.error_data{iexp};
        inputs.exps.u_interp{iexp}=exps.u_interp{iexp};
        inputs.exps.n_steps{iexp}=exps.n_steps{iexp};
        inputs.exps.t_con{iexp}=exps.t_con{iexp};
        inputs.exps.u{iexp}=exps.u{iexp};
        [IC1,IC2]=compute_steady_state(inputs.model.par,inputs.exps.u{iexp}(1,1),inputs.exps.u{iexp}(2,1));
        inputs.exps.exp_y0{iexp}=[exps.exp_y0{iexp}(1:2) IC1 IC2];
    end
    
end

inputs.model.compile_model=0;

[inputs,privstruct]=AMIGO_Prep(inputs);

feval(inputs.model.mexfunction,'sim_CVODES');




tempInputs=inputs;

MAT=[];

error_data={};
observables= outputs.observables;
for iexp=1:length(outputs.observables)
    
    error_data{iexp}=randn(size(outputs.observables{iexp})).*noise.*outputs.observables{iexp};
    
    if any(exps_vec==iexp)
        
        outputs.observables{iexp}=outputs.observables{iexp}+error_data{iexp};
            
        outputs.observables{iexp}(outputs.observables{iexp}<0)=0;
    else
        outputs.observables{iexp}=inputs.exps.exp_data{iexp};
    end
    
    n_stimuli=inputs.model.n_stimulus;
    time=inputs.exps.t_s{iexp};
    n_obs=inputs.exps.n_obs{iexp};
    
    mat=nan(length(time),2+n_stimuli+2.*n_obs);
    
    mat(:,1)=iexp;
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
    
    
    if any(exps_vec==iexp)
        mat(:,2+n_stimuli+1:2+n_stimuli+n_obs)=outputs.observables{iexp};
        mat(:,2+n_stimuli+n_obs+1:2+n_stimuli+n_obs+n_obs)=noise.*outputs.observables{iexp};
    else
        mat(:,2+n_stimuli+n_obs+1:2+n_stimuli+n_obs+n_obs)=inputs.exps.error_data{iexp};
    end
    
    MAT=[MAT;mat];
    
    if(iexp>7)
        inputs.exps.error_data{iexp}=error_data{iexp};
    end
end

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

T=array2table(MAT,'VariableNames',{'Experiment','Time',stimuli_names{:},obs_names{:},std_names{:}});
writetable(T,file);

end