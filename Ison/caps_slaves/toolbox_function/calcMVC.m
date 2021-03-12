function [mvc]=calcMVC(SubjectData,ClasseIDs)

tmp=[];


for grsp=1:length(ClasseIDs)
    
    for i=1:length(SubjectData.grasp{ClasseIDs(grsp)}.trial)
        
        tmp=[tmp;SubjectData.grasp{ClasseIDs(grsp)}.trial{i}.emg];
           
    end

end

mvc=max(tmp);





end