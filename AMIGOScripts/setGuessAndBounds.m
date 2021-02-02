function [boundperIter] = setGuessAndBounds(params,model_id)

    if isfile(".\ParameterEstimation\boundperIter.mat")
        load(".\ParameterEstimation\boundperIter.mat","boundperIter");
    else

        compName = split(model_id,'_');
        niter = compName{end,:};        %string:iteration of the loop
        nModel = compName{end-1,:};     

        boundperIter = {};
        boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('max') = 100.*(params);
        boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('min') = 0.01.*(params);
        % guesses computation: note they are latin hypercube sampling
        % over the range, number of samples specified by the user,
        % currently set to 30
        boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('guess') = LHCS(boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('max'),...
                                                                                      boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('min'),...
                                                                                      30);    

        save(".\ParameterEstimation\boundperIter.mat","boundperIter")
    end
            

            
    end


