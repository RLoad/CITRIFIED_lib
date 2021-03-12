%  this function returns a matrix different random integers from 1 to max  %

function R=random_numbers(max,nb_rows,nb_columns)

%        explaination:
% the algorithm checks if each of the elements of matrix temp exists more
% than once in the matrix. if yes, it changes the number with another one
% that does not exist. 

if max<nb_rows*nb_columns
    error('The maximum number must be greater than the number of elements')
end

temp=randi(max,nb_rows,nb_columns);

for i=1:nb_rows
    for j=nb_columns
        check=temp(i,j);
        temp(i,j)=0;
        if ~isempty(find(temp==check))
            while ~isempty(find(temp==check))
                check=randi(max,1);
            end
        end
        temp(i,j)=check;
        
    end
end

R=temp;

end