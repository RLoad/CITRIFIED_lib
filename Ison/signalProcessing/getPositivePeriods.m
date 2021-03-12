function [periods]=getPositivePeriods(data)

% Function for computing the positive period of a digital signal
%
% Input: 
%   data:       a vector with 0 and 1 elements
%
% Output:
%   periods:    a nx2 matrix where n correspods to the numper of positive
%               periods. The 1st column contains the onset and the 2nd
%               column contains the offset of the periods


idxs_up = find(data>0.5);

flips = idxs_up(2 : end) - idxs_up(1 : end -1);

flips_idxs = idxs_up(flips > 1);

f_flips_idxs = [flips_idxs; idxs_up(end)];

idxs_down = find(data(idxs_up(1) : end) < 0.5);

flops = idxs_down(2 : end) - idxs_down(1 : end - 1);

flops_idxs = idxs_down(flops>1) + idxs_up(1);

f_flops_idxs = [idxs_up(1); flops_idxs] -1;


periods = [f_flops_idxs, f_flips_idxs];

end



