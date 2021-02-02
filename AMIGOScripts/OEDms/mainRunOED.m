
function [oedRes] = mainRunOED(oed_res, oed_dat, flag, tmpth, j)


    oed_res.inputs.DOsol.u_guess=tmpth;
    
    oedRes = AMIGO_DO(oed_res.inputs);

    save(strjoin([".\Results\OED_", oed_dat.system, "_GenIter", oed_dat.iter, "_", flag, "\Run_", j, ".mat"], ""), "oedRes")




end
