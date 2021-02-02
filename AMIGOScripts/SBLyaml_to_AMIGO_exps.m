function [data_inputs] = SBLyaml_to_AMIGO_exps(network_name,exps_indexes)
    % Read yaml file with mapping between nomenclature in csv and SBLyaml
    dataset = ReadYaml(sprintf('./Data/NetworkData/%s.yaml',network_name));
    
    column_config.experiment_id = dataset.experiment_id.exp_id;
    column_config.experiment_time = dataset.measurement_time.t;
    % Added stimulus_pre in yaml! Check with Zoltan
    column_config.stimulus_pre = struct2cell(dataset.inputs_pre);
    column_config.stimulus_columns = struct2cell(dataset.inputs)';
    column_config.readout_columns = struct2cell(dataset.states)';
    column_config.readout_std_columns = struct2cell(dataset.measurement_error)';   
    column_config.lookup_mode = 'exact';
    
    data_inputs.exps= load_data(strcat('./Data/NetworkData/',network_name,'.csv'),exps_indexes,column_config);
     
end

