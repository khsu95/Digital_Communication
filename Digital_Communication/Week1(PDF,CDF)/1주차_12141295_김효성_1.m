%Generate random var
mat2=rand(1,10^2)*(6-4)+4;
mat3=rand(1,10^3)*(6-4)+4;
mat4=rand(1,10^4)*(6-4)+4;

aver1=mean(mat2)
aver2=mean(mat3)
aver3=mean(mat4)

%Generate matrix used to pdf
[M1, X1]=hist(mat2, 10);
[M2, X2]=hist(mat3, 10);
[M3, X3]=hist(mat4, 10);

PDF1=M1./(10^2)./(X1(2)-X1(1));
PDF2=M2./(10^3)./(X2(2)-X2(1));
PDF3=M3./(10^4)./(X3(2)-X3(1));

resol1=X1(2)-X1(1);
resol2=X2(2)-X2(1);
resol3=X3(2)-X3(1);

CDF1=cumsum(PDF1*resol1);
CDF2=cumsum(PDF2*resol2);
CDF3=cumsum(PDF3*resol3);

%Generate Graph

subplot(2,2,1)
bar(X1, PDF1), title('100 for N')
hold on;
plot(X1, CDF1,'y')

subplot(2,2,2)
bar(X2, PDF2), title('1000 for N')
hold on;
plot(X2, CDF2,'y')

subplot(2,2,3)
bar(X3, PDF3), title('10000 for N')
hold on;
plot(X3, CDF3,'y')
