function [ out_min,out_max ] = find_max_min_of_cell( A )
%FIND_MAX_MIN_OF_CELL �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

out_min=cellfun(@(x) min(cell2mat(x)),A);
out_max=cellfun(@(x) max(cell2mat(x)),A);
% out_min=cellfun(@(x) mean(cell2mat(x)),A)

end

