function[res]=OED4SBLdiscrimination(MODELS,sbl_config)


valid_model=[];


for i=1:length(MODELS)
    if ~isempty(MODELS{i})
        valid_models(i)=1;
        inputs=MODELS{i}{1};
        privstruct=MODELS{i}{2};
        [inputs,privstruct]=generate_template4OED(inputs,120,10,5);
        MODELS{i}={inputs,privstruct};
    else
        valid_models(i)=0;
    end
end

first_valid_model=find(valid_models);
first_valid_model=first_valid_model(1);


inputs=MODELS{first_valid_model}{1};
privstruct=MODELS{first_valid_model}{2};

problem.x_0=inputs.exps.u{1};
problem.x_U=inputs.exps.u{1};
problem.x_L=inputs.exps.u{1};

for i=1:size(inputs.exps.u{1},1)
    problem.x_U(i,:)=inputs.exps.u_max{1}(i);
    problem.x_L(i,:)=inputs.exps.u_min{1}(i);
end

problem.x_U=problem.x_U(:);
problem.x_L=problem.x_L(:);
problem.x_0=problem.x_0(:);

problem.f=@SBL_discriminationFobj;

[res_ssm]=ess_kernel(problem,sbl_config.modelDiscrimination.eSS,MODELS);

x=res_ssm.xbest;

res={};

for i=1:length(MODELS)
    if ~isempty(MODELS{i})
        inputs=MODELS{i}{1};
        privstruct=MODELS{i}{2};
        inputs.exps.u{1}=reshape(x,size(inputs.exps.u{1},1),size(inputs.exps.u{1},2));
        privstruct.u{1}=reshape(x,size(inputs.exps.u{1},1),size(inputs.exps.u{1},2));
        res{i}{1}=inputs;
        res{i}{2}=privstruct;
    else
        res{i}=[];
    end
    
end

end


function [f,g,r]=SBL_discriminationFobj(x,MODELS)

simulation={};
counter=0;
for i=1:length(MODELS)
    if ~isempty(MODELS{i})
        counter=counter+1;
        inputs=MODELS{i}{1};
        privstruct=MODELS{i}{2};
        inputs.exps.u{1}=reshape(x,size(inputs.exps.u{1},1),size(inputs.exps.u{1},2));
        privstruct.u{1}=reshape(x,size(inputs.exps.u{1},1),size(inputs.exps.u{1},2));
        feval(inputs.model.mexfunction,'sim_CVODES');
        simulation{counter}=outputs.simulation{1};
        
        if outputs.sim_stats{1}.flag~=0
            f=1e10;
            r=outputs.simulation{1};
            r(:)=1e10;
            return;
        end
        
    end
    
end


counter=0;
vec=[];
for i=1:length(simulation)
    
    for j=1:length(simulation)
        
        if(i>j)
            counter=counter+1;
            vec=[vec;simulation{i}-simulation{j}];
        end
        
    end
    
end

r=vec(:);
f=-sum(r.^2);

g=[];

if(f==0),f=Inf;end



end
