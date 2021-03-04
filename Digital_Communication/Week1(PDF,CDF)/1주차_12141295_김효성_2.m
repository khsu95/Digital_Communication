%Generate G random var

g_mat=randn(1,50000)*sqrt(2)+2;

mean(g_mat)
var(g_mat)

%G_RV PDF

[M,X]=hist(g_mat,100);

resol=X(2)-X(1);
PDF=M./50000./resol;
CDF=cumsum(PDF*resol);

%Plot Gaussian
syms x sigma mu
gaussian=1/(sigma*sqrt(2*pi))*exp(-1/2*((x-mu)/sigma)^2);
x_axis=1:0.01:1;

pdf_Gau=subs(gaussian,{sigma, mu}, {sqrt(2), 2});
pdf_Gau=subs(pdf_Gau,'x',X);

bar(X, PDF)
title('HW1-2');
hold on
plot(X, CDF,'y')
plot(X,pdf_Gau,'r')
legend('Random variable PDF','CDF','Gaussian RV PDF');
hold off
grid
