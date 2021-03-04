clc, clear;

%%Input
%Load Image
loaded_data=load('project1.mat');
%Parameter Setting
Data_=loaded_data.y;
Height_=loaded_data.Height;
Width_=loaded_data.Width;
CH_=loaded_data.CH;
Level_Binary=loaded_data.Level_binary;
Channel=loaded_data.h;

%%%Calculate
%Channel Compenstation
Comp=conj(Channel)./((abs(Channel).^2));
Re_Comp=Comp.*Data_;

%%Demodulation
%BPSK
Data_BPSK=real(Re_Comp>0);

%QPSK
Symbol=2*(real(Re_Comp)>0)-1+1j*(imag(Re_Comp)>0-1);
Data_QPSK=[real(Symbol)>0;imag(Symbol)>0;];

%Stream to Unit8
Image_BPSK=reshape(Data_BPSK,[Height_/2*Width_*CH_,Level_Binary]);
Image_QPSK=reshape(Data_QPSK,[Height_*Width_*CH_,Level_Binary]);

Image_BPSK=bi2de(Image_BPSK);
Image_QPSK=bi2de(Image_QPSK);

Image_BPSK=uint8(reshape(Image_BPSK,[Height_/2,Width_,CH_]));
Image_QPSK=uint8(reshape(Image_QPSK,[Height_,Width_,CH_]));

%%Output
subplot(1,2,1), imshow(Image_BPSK), title("BPSK");
subplot(1,2,2), imshow(Image_QPSK), title("QPSK");