function [boundperIter_return] = setGuessAndBounds(params,model_id)

    compName = split(model_id,'_');
    niter = compName{end,:};        % string:iteration of the loop
    nModel = compName{end-1,:};     % string: model identifier
    
    % patch to account for negative parameter values
    params_matrix = [100.*params;0.01.*params];
    for c=1:size(params_matrix,2)
        if params_matrix(1,c)<0
            params_matrix_flipped(:,c) = flip(params_matrix(:,c));
        else
            params_matrix_flipped(:,c) = params_matrix(:,c);
        end
    end
    
    if isfile(".\AMIGOscripts\ParameterEstimation\boundperIter.mat")
        load(".\AMIGOscripts\ParameterEstimation\boundperIter.mat","boundperIter");
        if ~isfield(boundperIter,strcat('Iter',niter))
            boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('max') = params_matrix_flipped(1,:);
            boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('min') = params_matrix_flipped(2,:);
            % guesses computation: note they are latin hypercube sampling
            % over the range, number of samples specified by the user,
            % currently set to 30
            boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('guess') = LHCS(boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('max'),...
                                                                                      boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('min'),...
                                                                                      30);    
        elseif ~isfield(boundperIter.(strcat('Iter',niter)),strcat('Model',nModel))
            boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('max') = params_matrix_flipped(1,:);
            boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('min') = params_matrix_flipped(2,:);
            % guesses computation: note they are latin hypercube sampling
            % over the range, number of samples specified by the user,
            % currently set to 30
            boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('guess') = LHCS(boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('max'),...
                                                                                          boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('min'),...
                                                                                      30);    
        end
    else
        boundperIter = {};
        boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('max') = params_matrix_flipped(1,:);
        boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('min') = params_matrix_flipped(2,:);
        % guesses computation: note they are latin hypercube sampling
        % over the range, number of samples specified by the user,
        % currently set to 30
        boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('guess') = LHCS(boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('max'),...
                                                                                      boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel)).('min'),...
                                                                                      30);   
    end

    save(".\AMIGOscripts\ParameterEstimation\boundperIter.mat","boundperIter");
    boundperIter_return = boundperIter.(strcat('Iter',niter)).(strcat('Model',nModel));
     
    end


