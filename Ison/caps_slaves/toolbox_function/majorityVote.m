function [winner,confidence]=majorityVote(Arr)





% tempWinner=Arr(1);
% appearences=1;
% 
% for i=2:length(Arr)
%     
%     if tempWinner==Arr(i)
%         appearences=appearences+1;
%     else
%         appearences=appearences-1;
%         if appearences==0
%             tempWinner=Arr(i);
%         end
%     end  
%     
%     
% end

[a,b]=hist(Arr,unique(Arr));

[~,id]=max(a);

winner=b(id);

if length(a)>1
    sa=sort(a);
    confidence=(sa(end)-sa(end-1))/length(Arr);
else
    confidence=1;
end




end