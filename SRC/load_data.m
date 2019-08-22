function [exps] = load_data(file,exp_idx)

DATA = importdata(file);

EXPERIMENT_COL=find(startsWith(DATA.textdata,'Experiment'));
TIME_COL=find(startsWith(DATA.textdata,'Time'));
STIMULI_COLS=find(startsWith(DATA.textdata,'TR_'));
READOUT_COLS=find(startsWith(DATA.textdata,'READOUT_'));
STD_COLS=find(startsWith(DATA.textdata,'STD_'));
EXPERIMENTS=unique(sort(DATA.data(:,EXPERIMENT_COL)));
N_EXPERIMENTS=length(EXPERIMENTS);

counter=0;
for iexp=1:N_EXPERIMENTS
    
    if any(exp_idx==iexp)
        
        counter=counter+1;
        index=DATA.data(:,EXPERIMENT_COL)==EXPERIMENTS(iexp);
        TIME=DATA.data(index,TIME_COL);
        exps.n_obs{counter} = length(READOUT_COLS);
        exps.exp_type{counter} = 'fixed';
        
        st_names=regexprep(DATA.textdata(READOUT_COLS),'READOUT_','');
        obs_names = regexprep(DATA.textdata(READOUT_COLS),'READOUT_','');
        
        for jobs=1:length(obs_names)
            obs_names{jobs}=[obs_names{jobs} '_o'];
        end
        
        exps.obs_names{counter}=char(obs_names);
        exps.obs{counter}=[];
        
        for jobs=1:exps.n_obs{counter}
            exps.obs{counter} =[exps.obs{counter}; [obs_names{jobs} '=' st_names{jobs}]];
        end
        
        exps.t_f{counter} = TIME(end);
        exps.n_s{counter} = length(TIME);
        exps.t_s{counter} = TIME';
        exps.u_interp{counter} = 'step';
        exps.t_con{counter} = TIME';
        exps.n_steps{counter} = length(TIME)-1;
        exps.u{counter} = DATA.data(index,STIMULI_COLS)';
        exps.data_type = 'real';
        exps.noise_type = 'homo';
        exps.exp_data{counter} = DATA.data(index,READOUT_COLS);
        exps.error_data{counter} = DATA.data(index,STD_COLS);
        exps.exp_y0{counter} = exps.exp_data{counter}(1,:);
        
    end
    
end

exps.n_exp=counter;

end
