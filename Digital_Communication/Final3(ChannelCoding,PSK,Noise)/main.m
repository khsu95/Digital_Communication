clc,clear

%%Declare
N_bits=1e5;

Generate=[1 1 1 1 0 0 0; 1 0 1 0 1 0 0; 0 1 1 0 0 1 0; 1 1 0 0 0 0 1];

%Generate bits
Source=rand(1,N_bits)>0.5;

%Coding
Source_Block=BlockCoding(Source);

trellis = poly2trellis(3,{'1 + x+x^2','1 + x^2'});
Source_Conv=convenc(Source,trellis);

% Modulation-Demodulation-BER
BER_Block=zeros(2,31,3); %AWGN-Rayleigh/EbN0 Verctor/BPSK-QPSK-QAM
BER_Conv=zeros(2,31,3);

for Eb_N0_Decidel=-10:20
    %BPSK
    [Stream_Block_BPSK(1,:),Stream_Block_BPSK(2,:)]=BPSK(Source_Block,Eb_N0_Decidel);
    %QPSK
    [Stream_Block_QPSK(1,:),Stream_Block_QPSK(2,:)]=QPSK(Source_Block,Eb_N0_Decidel);
    %QAM
    [Stream_Block_QAM(1,:),Stream_Block_QAM(2,:)]=QAM_16(Source_Block,Eb_N0_Decidel);

    %BPSK
    [Stream_Conv_BPSK(1,:),Stream_Conv_BPSK(2,:)]=BPSK(Source_Conv,Eb_N0_Decidel);
    %QPSK
    [Stream_Conv_QPSK(1,:),Stream_Conv_QPSK(2,:)]=QPSK(Source_Conv,Eb_N0_Decidel);
    %QAM
    [Stream_Conv_QAM(1,:),Stream_Conv_QAM(2,:)]=QAM_16(Source_Conv,Eb_N0_Decidel);

    %Decoding
    Stream_deBlock_BPSK(1,:)=decode(Stream_Block_BPSK(1,:),7,4,'linear',Generate);
    Stream_deBlock_BPSK(2,:)=decode(Stream_Block_BPSK(2,:),7,4,'linear',Generate);
    Stream_deBlock_QPSK(1,:)=decode(Stream_Block_QPSK(1,:),7,4,'linear',Generate);
    Stream_deBlock_QPSK(2,:)=decode(Stream_Block_QPSK(2,:),7,4,'linear',Generate);
    Stream_deBlock_QAM(1,:)=decode(Stream_Block_QAM(1,:),7,4,'linear',Generate);
    Stream_deBlock_QAM(2,:)=decode(Stream_Block_QAM(2,:),7,4,'linear',Generate);
    
    Stream_deConv_BPSK(1,:)=vitdec(Stream_Conv_BPSK(1,:),trellis,N_bits,'trunc','hard');
    Stream_deConv_BPSK(2,:)=vitdec(Stream_Conv_BPSK(2,:),trellis,N_bits,'trunc','hard');
    Stream_deConv_QPSK(1,:)=vitdec(Stream_Conv_QPSK(1,:),trellis,N_bits,'trunc','hard');
    Stream_deConv_QPSK(2,:)=vitdec(Stream_Conv_QPSK(2,:),trellis,N_bits,'trunc','hard');
    Stream_deConv_QAM(1,:)=vitdec(Stream_Conv_QAM(1,:),trellis,N_bits,'trunc','hard');
    Stream_deConv_QAM(2,:)=vitdec(Stream_Conv_QAM(2,:),trellis,N_bits,'trunc','hard');
    
    %BER
    BER_Block(:,Eb_N0_Decidel+11,1)=(sum((Source~=Stream_deBlock_BPSK)')')./N_bits;
    BER_Block(:,Eb_N0_Decidel+11,2)=(sum((Source~=Stream_deBlock_QPSK)')')./N_bits
    BER_Block(:,Eb_N0_Decidel+11,3)=(sum((Source~=Stream_deBlock_QAM)')')./N_bits;
    BER_Conv(:,Eb_N0_Decidel+11,1)=(sum((Source~=Stream_deConv_BPSK)')')./N_bits;
    BER_Conv(:,Eb_N0_Decidel+11,2)=(sum((Source~=Stream_deConv_QPSK)')')./N_bits;
    BER_Conv(:,Eb_N0_Decidel+11,3)=(sum((Source~=Stream_deConv_QAM)')')./N_bits;
end
OutputF(BER_Block,BER_Conv);