clc, clear

%%Declare

f0=24000;
fs=8000;
rb=56000;
amplitude=1;

Ts=1/fs;
T0=1/f0;
ts=[0:Ts:4.77];
tr=[0:T0:4.77];
ns=length(ts)-2;

%%Input

load('encode_data.mat');

%%Calculate

%Bit Per Symbol
syms bitPersym;
eqForbit=bitPersym*fs;
eqForbit=eqForbit-rb;
bitPersym=solve(eqForbit)
bitPersym=sym2poly(bitPersym);

%stepQ
levelQ=2^(bitPersym);
stepQ=2*amplitude/levelQ;

%Decoding
temp=zeros(ns*bitPersym,1);
temp=(reshape(x_en,bitPersym,ns))';
for i=1:ns
    x_de(i)=stepQ*bin2dec(temp(i,:))+stepQ/2-amplitude;
end

%Reconstruction
yt=zeros(1,length(tr));
for i=1:ns
    yt=yt+sinc((tr-(i-1)*Ts)/Ts)*x_de(i);
end

plot(tr,yt);grid on;title('Sample in Time');axis([0,5,-1,1])
sound(yt,f0)