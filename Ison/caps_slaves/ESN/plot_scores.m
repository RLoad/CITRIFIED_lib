clear all,
close all,


%%%%% Training on 3 objects sizes and testing on one object size

%%
figure(1),

X = [10:10:100]';

colors = {'r', 'g', 'b', 'k', 'y', 'k', 'c', 'm'};
for i=1:8
    file1 = ['score_train_3_1_sub', num2str(i)];
    file2 = ['score_test_3_1_sub', num2str(i)];
    load(file1);
    load(file2);
    
   subplot(2,1,1),
   plot(X, score_train(:,2),colors{i}); hold on
   plot(X, score_train(:,2),'*k');
   title('training set', 'fontsize', 16);
   xlabel('Signal percentage', 'fontsize', 16);
   ylabel('Classification success rate', 'fontsize', 16);
    
   subplot(2,1,2),
   plot(X, score_validation(:,2),colors{i}), hold on,
   plot(X, score_validation(:,2),'*k');
   title('testing set', 'fontsize', 16);
   xlabel('Signal percentage', 'fontsize', 16);
   ylabel('Classification success rate', 'fontsize', 16);
   
end



%%%%% Training on 2 objects sizes and testing on two object sizes

%%

figure(2),

X = [10:10:100]';

colors = {'r', 'g', 'b', 'k', 'y', 'k', 'c', 'm'};
for i=1:8
    file1 = ['data_subject',num2str(i),'_t2_v2_score'];
    load(file1);
  
    
   subplot(2,1,1),
   plot(X, score_train(:,2),colors{i}); hold on
   plot(X, score_train(:,2),'*k');
   title('training set', 'fontsize', 16);
   xlabel('Signal percentage', 'fontsize', 16);
   ylabel('Classification success rate', 'fontsize', 16);
    
   subplot(2,1,2),
   plot(X, score_validation(:,2),colors{i}), hold on,
   plot(X, score_validation(:,2),'*k');
   title('testing set', 'fontsize', 16);
   xlabel('Signal percentage', 'fontsize', 16);
   ylabel('Classification success rate', 'fontsize', 16);
   
end


%%%%% Training on one object size and testing on three objects sizes