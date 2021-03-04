function Closest=Closest(Symbol)
Mapping_Index=[-3 -1 1 3];
Closest=2*floor(Symbol/2)+1; %After make [0.5 ~ 1.5], After floor [0~1], 2 times, 1 add [1~3]
if Closest>max(Mapping_Index)
    Closest=max(Mapping_Index);
else if Closest<min(Mapping_Index)
        Closest=min(Mapping_Index);
    end
end
