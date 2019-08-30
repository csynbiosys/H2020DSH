function  SBL_plotDiscriminationResult(MODELS)


valid_model=[];

observables={};
for i=1:length(MODELS)
    if ~isempty(MODELS{i})
        inputs=MODELS{i}{1};
        privstruct=MODELS{i}{2};
        feval(inputs.model.mexfunction,'sim_CVODES');
        observables{i}=outputs.observables{1};
    else
        valid_models(i)=0;
    end
end


iexp=1;
total_plots=1+inputs.exps.n_obs{iexp}+inputs.model.n_stimulus;
ncols=floor(sqrt(total_plots))+1;
nrows=floor(sqrt(total_plots))+1;

counter=0;

figure;
labels={};
counter=0;
for i=1:inputs.model.n_stimulus
    
    counter=counter+1;
    subplot(nrows,ncols,counter);
    
    try
        stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(i,:)])
    catch
        stairs(inputs.exps.t_con{iexp},[inputs.exps.u{iexp}(i,:) inputs.exps.u{iexp}(i,end)])
    end
    title(inputs.model.stimulus_names(i,:));
    
end


for i=1:inputs.model.n_st
    counter=counter+1;
    labels={};
    counter2=0;
    
    for j=1:length(MODELS)
        
        if ~isempty(MODELS{j})
            counter2=counter2+1;
            subplot(nrows,ncols,counter);
            title(inputs.model.st_names(i,:));
            
            plot(inputs.exps.t_s{iexp},observables{j}(:,i),'LineWidth',1)
            hold on;
            labels{counter2}=['MODEL' num2str(j)];
            
        end
    end
    legend(labels);
    
end



