%%Input
[x0,f0]=audioread('Original.wav');

%%Define
fs=7*10^3;
ts=1/fs;


%%Calculate
%
N=length(x0);
f=(-N/2:N/2-1)*(f0/N);
%FT_x=abs(fftshift(fft(x0)));
% plot(f,10*log10(FT_x))
% subplot(2,2,1);plot(f,10*log10(FT_x));grid on;title('Original');axis([0,2*10^4,0,40])

%Sampling
t0=1/f0;
t=[0:t0:10];
sample_step=floor(ts/t0);
n=0:10/ts;
for i=1:length(n)-1
    t_s(i)=t(i*sample_step);
    x_s(i)=x0(i*sample_step);
end



%Reconstruction
y_t=zeros(1,length(t));
for i=1:length(t_s)
    y_t=y_t+x_s(i)*sinc((t-(i-1)*ts)/ts);
end


x_s2(1)=x0(1);
t_s2(1)=t(1);
x_s2=ones(1,length(x0));
for i=2:length(x0)
    if(mod(i,sample_step)==0)
        x_s2(i)=x0(i);
    end
end
t_s2=t;

%FFT
FT_x=fft(x0);FT_x_s=fft(x_s2);FT_y=fft(y_t);
n1=length(x0);n2=length(x_s2);n3=length(y_t);
ff1=[0:n1-1]*(f0/n1);ff2=[0:n2-1]*(f0/n2);ff3=[0:n3-1]*(f0/n3);

%%Output
%Graph
subplot(2,2,1);plot(f,10*log10(abs(fftshift(FT_x))));grid on;title('Original in Freq');axis([0,2*10^4,0,40])
subplot(2,2,4);plot(t_s,x_s);grid on;title('Sample in Time');axis([0,10,0,0.5])
subplot(2,2,3);plot(ff2,10*log10(abs(FT_x_s)));grid on;title('Sample in Freq');axis([0,2*10^4,0,40]);
subplot(2,2,2);plot(ff3,10*log10(abs(FT_y)));grid on;title('Reconstruction in Freq');axis([0,2*10^4,0,40]);

%File
audiowrite('Reconstruction.wav',y_t,f0);

