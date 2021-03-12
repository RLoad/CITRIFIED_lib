 function time_window = S_stat()

subjects = {'data_subject1_new','data_subject2_new','data_subject3_new','data_subject4_new','data_subject5_new','data_subject6_new','data_subject7_new','data_subject8_new'}; 

length_sample = [];
for i=1:8
    load (subjects{i});
    for j=1:length(test_data_cell)
        length_sample = [length_sample; length(test_data_cell{j})];
    end
    
    for j=1:length(train_data_cell)
        length_sample = [length_sample; length(train_data_cell{j})];
    end
end
    
av_sample = mean(length_sample)   
std_sample = std(length_sample)
min_sample = min(length_sample)

time_window = floor(min_sample/5);