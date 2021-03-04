function Gray=Demapping(Coor)
Demapping_Index=[0 1 3 2];
Index=floor((Coor+4)/2+1); %[-3.-1.1.3.] -> [1,2,3,4]
Dec=Demapping_Index(1,Index);
Bin=dec2bin(Dec,2);
Gray(1,:)=[Bin(1)=='1' Bin(2)=='1'];
