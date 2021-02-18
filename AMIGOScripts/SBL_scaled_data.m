function [scaled_exps] = SBL_scaled_data(exps,idx_exp)
    scaled_exps = exps;
    
    for iexp=idx_exp
%% Zoltan normalisation
%         scaled_exps.exps.t_s{1,iexp} = scale(exps.exps.t_s{1,iexp});
%         scaled_exps.exps.t_con{1,iexp} = scale(exps.exps.t_con{1,iexp});
%         scaled_exps.exps.u{1,iexp} = scale(exps.exps.u{1,iexp});
%         scaled_exps.exps.exp_data{1,iexp} = scale(exps.exps.exp_data{1,iexp}')';
%         scaled_exps.exps.error_data{1,iexp} = scale(exps.exps.error_data{1,iexp}')';
%         scaled_exps.exps.exp_y0{1,iexp} = scaled_exps.exps.exp_data{1,iexp}(1,:);
%         scaled_exps.exps.t_f{1,iexp} = scaled_exps.exps.t_s{1,iexp}(end);

%%      Unnormalised data
%         scaled_exps.exps.t_s{1,iexp} = scale(exps.exps.t_s{1,iexp});
%         scaled_exps.exps.t_con{1,iexp} = scale(exps.exps.t_con{1,iexp});
%         scaled_exps.exps.u{1,iexp} = scale(exps.exps.u{1,iexp});
%         scaled_exps.exps.exp_data{1,iexp} = scale(exps.exps.exp_data{1,iexp}')';
%         scaled_exps.exps.error_data{1,iexp} = scale(exps.exps.error_data{1,iexp}')';
%         scaled_exps.exps.exp_y0{1,iexp} = scaled_exps.exps.exp_data{1,iexp}(1,:);
%         scaled_exps.exps.t_f{1,iexp} = scaled_exps.exps.t_s{1,iexp}(end);
    end
    
    
end