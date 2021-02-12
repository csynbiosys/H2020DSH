function [scaled_Matrix] = scale(Matrix)
    for r=1:size(Matrix,1)
        if std(Matrix(r,:)) ==0
            scaled_Matrix(r,:) = Matrix(r,:);
        else
            scaled_Matrix(r,:) = Matrix(r,:)./std(Matrix(r,:));
        end
    end
end