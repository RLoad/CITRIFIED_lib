function [ train_set,test_set ] = generate_CV_dataset( MIX_data,input_args,test_train_rate)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
targets = MIX_data(1,:);
        k_fold=10;
        %%%%%%%%%%%%%% Holdout
        for ff = 1:k_fold
            CVO = cvpartition(length(targets),'HoldOut',test_train_rate);
            if (exist ('OCTAVE_VERSION', 'builtin') > 0)
                trIdx = training(CVO,1);
                teIdx = test(CVO,1);
            else
                trIdx = CVO.training(1);
                teIdx = CVO.test(1);
            end
            train_set{ff}=MIX_data(:,trIdx);
            test_set{ff}=MIX_data(:,teIdx);
        end


end

