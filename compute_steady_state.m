function [IPTGi,aTci ] = compute_steady_state(theta,u_IPTG,u_aTc)

k_iptg = theta(13);
k_aTc = theta(14);

%% Steady state equation
aTci = k_aTc*u_aTc/(0.0165+k_aTc);
IPTGi = k_iptg*u_IPTG/(0.0165+k_iptg);

end
