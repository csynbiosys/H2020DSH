function [exps] = load_data(file,exp_idx,column_config)

% default column config
if nargin == 2
    column_config.experiment_id = 'Experiment';
    column_config.experiment_time = 'Time';
    column_config.stimulus_columns = 'TR_';
    column_config.readout_columns = 'READOUT_';
    column_config.readout_std_columns = 'STD_';
    column_config.lookup_mode = 'find';
end



DATA = importdata(file);
% trim whitespaces
DATA.textdata = cellfun(@(a)strtrim(a),DATA.textdata,'Uniformoutput',false);


EXPERIMENT_COL = find_column(DATA.textdata,column_config.experiment_id, file,'find');
TIME_COL = find_column(DATA.textdata,column_config.experiment_time, file,'find');
STIMULI_PRE = find_column(DATA.textdata,column_config.stimulus_pre, file,column_config.lookup_mode);
STIMULI_COLS = find_column(DATA.textdata,column_config.stimulus_columns, file,column_config.lookup_mode);
READOUT_COLS = find_column(DATA.textdata,column_config.readout_columns, file, column_config.lookup_mode);
STD_COLS = find_column(DATA.textdata,column_config.readout_std_columns, file, column_config.lookup_mode);

EXPERIMENTS=unique(sort(DATA.data(:,EXPERIMENT_COL)));
N_EXPERIMENTS=length(EXPERIMENTS);

counter=0;
for iexp=1:N_EXPERIMENTS
    
    if any(exp_idx==iexp)
        
        counter=counter+1;
        index=DATA.data(:,EXPERIMENT_COL)==EXPERIMENTS(iexp);
        TIME=DATA.data(index,TIME_COL);
        exps{counter}.n_obs = length(READOUT_COLS);
        exps{counter}.exp_type = 'fixed';
        
        st_names=regexprep(DATA.textdata(READOUT_COLS),column_config.readout_columns,'');
        obs_names = regexprep(DATA.textdata(READOUT_COLS),column_config.readout_columns,'');
        
        for jobs=1:length(obs_names)
            obs_names{jobs}=[obs_names{jobs} '_o'];
        end
        
        exps{counter}.obs_names=char(obs_names);
        exps{counter}.obs=[];
        
        for jobs=1:exps{counter}.n_obs
            exps{counter}.obs =[exps{counter}.obs; [obs_names{jobs} '=' st_names{jobs}]];
        end

        exps{counter}.t_f = TIME(end);
        exps{counter}.n_s = length(TIME);
        exps{counter}.t_s = TIME';
        exps{counter}.u_interp = 'step';
        exps{counter}.t_con = TIME';
        exps{counter}.n_steps = length(TIME)-1;
        exps{counter}.u_0 = unique(DATA.data(index,STIMULI_PRE));
        exps{counter}.u = DATA.data(index,STIMULI_COLS)';
        exps{counter}.data_type = 'pseudo';
        exps{counter}.noise_type = 'hetero_proportional';
        exps{counter}.exp_data = DATA.data(index,READOUT_COLS);
        exps{counter}.error_data = DATA.data(index,STD_COLS);
        exps{counter}.exp_y0 = exps{counter}.exp_data(1,:); % note: currently set to the initial value in the experiment
    end
    
end

%exps.n_exp=counter;

end

function column_idx = find_column(data,column_name,file,lookup_mode)

if strcmp(lookup_mode,'find')
    column_idx = find(startsWith(data,column_name));
    if isempty(column_idx)
        warning(strcat('Column: ',column_name,' was not found in ', file))
    end
elseif strcmp(lookup_mode,'exact')
    l = cellfun(@(c)strcmp(c,data),column_name,'UniformOutput',false);
    column_idx = cellfun(@(a) find(a),l);
else
    error('Not supported lookup_mode: %s',lookup_mode)
    
end

return
end


