function [ParFull] = LHCS(theta_max, theta_min,numGuesses)


    M_norm = lhsdesign(numGuesses,length(theta_min));
    M = zeros(size(M_norm));
    for c=1:size(M_norm,2)
        for r=1:size(M_norm,1)
            M(r,c) = M_norm(r,c)*(theta_max(1,c)-theta_min(1,c))+theta_min(1,c); 
        end
    end 

    % %check the location of the parameters that are fixed
    ParFull = M;  


end
