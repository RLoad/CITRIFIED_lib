function [ BIC ] = BIC_for_GMM( Data, Priors, Mu, Sigma)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%  Data=[pdemos_pos_all_phase(2:4,:);pdemos_force_all_phase(2:4,:)];

        d = size(Sigma,1)/2;%-1
%         d = size(Sigma_F2VImagit_all_phase,1);
        K_GMM=size(Mu,2);
        BIC=0;
        BIC=log(size(Data,2))*(K_GMM*d/2);
        pro=0;L_GMM=0;
        for data_num=1:size(Data,2)
            L_GMM=0;
            for gmm_num=1:K_GMM
                tmp = [Data(:,data_num)] - Mu(:,K_GMM);
                prob = (tmp'*inv(Sigma(:,:,K_GMM)))*tmp;
                Pxi(:,K_GMM) = exp(-0.5*prob) / sqrt((2*pi)^(2*d) * (abs(det(Sigma(:,:,K_GMM)))+realmin));
                likelihood_GMM=(Pxi(:,K_GMM)+realmin)*Priors(K_GMM);
                L_GMM=L_GMM+likelihood_GMM;
            end
            pro=pro+log(L_GMM);
        end
        pro=pro/data_num;
        BIC=BIC-pro*data_num;

end

