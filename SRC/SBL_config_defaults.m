sbl_config.loop_iter = 2;
sbl_config.fid = 1;
sbl_config.do_struct_id_check = 1;
SBL_workdir;
sbl_config.data_dir_name = fullfile(SBL_work_dir,'Data');
sbl_config.data_file_name = ['experimental_data_loop_' num2str(1) '.csv'];
sbl_config.exp_idx=1;

%% SBL config
sbl_config.display_plots  = 0;
sbl_config.save_results_to_mat = 0;

%% generating different model structures
sbl_config.sparsity_vec = [0.2 2];

sbl_config.parEst.eSS.dim_refset=20;
sbl_config.parEst.eSS.ndiverse=200;
sbl_config.parEst.eSS.local.n1=3;
sbl_config.parEst.eSS.local.n2=3;
sbl_config.parEst.eSS.maxeval=5000;
sbl_config.parEst.eSS.maxtime=inf;
sbl_config.parEst.eSS.local.solver='fmincon';
sbl_config.parEst.eSS.local.finish=0;

sbl_config.modelDiscrimination.eSS.dim_refset=20;
sbl_config.modelDiscrimination.eSS.ndiverse=200;
sbl_config.modelDiscrimination.eSS.local.n1=3;
sbl_config.modelDiscrimination.eSS.local.n2=3;
sbl_config.modelDiscrimination.eSS.maxeval=5000;
sbl_config.modelDiscrimination.eSS.maxtime=inf;
sbl_config.modelDiscrimination.eSS.local.solver='fmincon';
sbl_config.modelDiscrimination.eSS.local.finish=0;
