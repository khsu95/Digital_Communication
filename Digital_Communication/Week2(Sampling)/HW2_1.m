fm_1=4;
fm_2=5/2;
A_1=2;
A_2=1;

T0=0.01;
t=[0:T0:2];
f0=1/T0;

x=A_1*cos(2*pi*fm_1*t)+cos(2*pi*fm_2*t);

fs=5;
Ts=round(1/fs,2);
sample_step=floor(Ts/T0);
n=0:2/Ts;
t_s(1)=t(1);
x_s(1)=x(1);
for i1=1:length(n)-1
    t_s(i1+1)=t(1+i1*sample_step);
    x_s(i1+1)=x(1+i1*sample_step);
end

y_t=zeros(length(t_s),length(t));
for i1=1:length(t_s)
    y_t(i1,:)=x_s(i1)*sinc((t-(i1-1)*Ts)/Ts);
end
y=sum(y_t);


% subplot(2,1,1);plot(t(1:length(x)),[x]);hold on;plot(t_s,[x_s]);legend("Original","Sampling");
% subplot(2,1,2);plot(t(1:length(x)),[x]);hold on;plot(t,[y]);legend("Original","Reconstruction");

x_s2(1)=x(1);
t_s2(1)=t(1);
x_s2=zeros(1,length(x));
for i1=2:length(t)
    if(mod(i1,sample_step)==0)
        x_s2(i1)=x(i1);
    end
end
t_s2=t;

FT_x=fft(x);FT_x_s=fft(x_s2);FT_y=fft(y);
ff1=[0:length(FT_x)-1];
ff2=[0:length(FT_x_s)-1];
ff3=[0:length(FT_y)-1];
subplot(3,1,1);stem(ff1,(abs(FT_x)));xlim([0,10]);grid on;legend("Original");
subplot(3,1,2);stem(ff2,(abs(FT_x_s)));xlim([0,10]);grid on;legend("Sampling");
subplot(3,1,3);stem(ff3,(abs(FT_y)));xlim([0,10]);grid on;legend("Reconstruction");

