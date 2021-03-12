
function [oedRes] = mainRunOED(oed_res, label,network_name,tmpth, j,niter)

    oed_res.inputs.DOsol.u_guess=tmpth;
    
    oedRes = AMIGO_DO(oed_res.inputs);

    save(strjoin([".\Results\OED_", network_name, "_Iter", niter, "_", label,"\Run_", j, ".mat"], ""), "oedRes")


end
