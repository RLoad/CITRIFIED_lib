function SynMatrix = TimeSyn2Data(Data1, Data2)
% Data1: N Rows & 1 Column;   Data2: M Rows & 1 Column
% Assume: N >= M & Data1(1) <= Data2(1) & Data1(end) >= Data2(end)
k1 = 1;    k2 = size(Data2,1);    k3 = 2;
if Data2(1,1) < Data1(1,1)
    while Data2(k1,1) < Data1(1,1)
        k1 = k1 + 1;
        Index1 = k1;
    end
else
    Index1 = 1;
end
if Data2(end,1) > Data1(end,1)
    while Data2(k2,1) > Data1(end,1)
        k2 = k2 - 1;
        Index2 = k2;
    end
else
    Index2 = size(Data2,1);
end
N = size(Data1, 1);
M = Index2 - Index1 + 1;
SynMatrix = zeros(1, 4);
for i = 1 : Index2 - Index1 + 1
    Index3 = i + Index1 - 1;
    if Data2(Index3,1) == Data1(1,1)
        SynMatrix(i,:) = [1, Index3, Data1(1,1), Data2(Index3,1)];
    elseif Data2(Index3,1) == Data1(end,1)
        SynMatrix(i,:) = [N, Index3, Data1(N,1), Data2(Index3,1)];
    else
        for j = k3 : N -1
            vec1 = abs(Data2(Index3,1) - Data1(j-1,1));
            vec2 = abs(Data2(Index3,1) - Data1(j,1));
            vec3 = abs(Data2(Index3,1) - Data1(j+1,1));
            if vec2 <= vec1 && vec2 <= vec3
                SynMatrix(i,:) = [j, Index3, Data1(j,1), Data2(Index3,1)];
            end
        end
    end
end


end
