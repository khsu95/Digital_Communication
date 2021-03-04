clc, clear;
%%Declare
%Setting
Eb_mW=1;
Eb_dB=pow2db(Eb_mW);

%%Input
%Load Image
loaded_data=load('hyosung Kim - homework.mat');
%Parameter Setting
Height_=loaded_data.Height_;
Width_=loaded_data.Width_;
CH_=loaded_data.CH_;
Level_binary=loaded_data.Level_binary;
h=loaded_data.h;

y5(:,1)=loaded_data.y1;
y5(:,2)=loaded_data.y2;
y5(:,3)=loaded_data.y3;

for k=1:3

    %Channle Compenstation
    h_comp=conj(h)./((abs(h)).^2);
    r=h_comp.*y5(:,k);
    
    %Demodulation
    bits_re(:,k)=real(r>0);
    
    %%Stream To Uint8
    image_bit_re(:,:,k)=reshape(bits_re(:,k),[Height_*Width_*CH_,Level_binary]);
    image_vec_re(:,:,k)=bi2de(image_bit_re(:,:,k));
    image_re=uint8(reshape(image_vec_re(:,:,k),[Height_,Width_,CH_]));
    
    subplot(1,3,k), imshow(image_re(:,:,k)), title(sprintf("y%d", k));
end
