
function gen_pseudo_data(inputs,privstruct,noise,file)

feval(inputs.model.mexfunction,'sim_CVODES');

MAT=[];

for iexp=1:length(outputs.observables)
    
    outputs.observables{iexp}=outputs.observables{iexp}+...
        randn(size(outputs.observables{iexp})).*noise.*outputs.observables{iexp};
    outputs.observables{iexp}(outputs.observables{iexp}<0)=0;
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
    
    mat(:,2+n_stimuli+1:2+n_stimuli+n_obs)=outputs.observables{iexp};
    mat(:,2+n_stimuli+n_obs+1:2+n_stimuli+n_obs+n_obs)=outputs.observables{iexp}.*noise;
    MAT=[MAT;mat];
    
end
iexp=1;
stimuli_names=cell(1,n_stimuli);

for i=1:n_stimuli
    stimuli_names{i}=['TR_' inputs.model.stimulus_names(i,:)];
end

obs_names=cell(1,n_obs);
for i=1:n_obs
    obs_names{i}=['READOUT_' inputs.exps.obs_names{iexp}(i,:)];
end

std_names=cell(1,n_obs);
for i=1:n_obs
    std_names{i}=['STD_' inputs.exps.obs_names{iexp}(i,:)];
end


T=array2table(MAT,'VariableNames',{'Experiment','Time',stimuli_names{:},obs_names{:},std_names{:}});
writetable(T,file);

end