clc,clear;
%%%QPSK-OFDM Receiver


%%Input
%Load Image
loaded_data=load('project2.mat');
%Parameter Setting
N_ASCII_Bits=loaded_data.N_ASCII_Bits;
N_OFDM_symbols=loaded_data.N_OFDM_symbols;
modOrder=loaded_data.modOrder;
nFFTSize=loaded_data.nFFTSize;
nSampGI=loaded_data.nSampGI;
nSubcarrier=loaded_data.nSubcarrier;
subcarrierIndex=loaded_data.subcarrierIndex;
Data=loaded_data.y.';
Stream=ones(1,1);
Length_OFDM_Symbol=nFFTSize+nSampGI;

for i=0:1:N_OFDM_symbols-1
    %%Calculate
    %Fetch A OFDM Symbol
    A_OFDM_Symbol=Data([1,i*Length_OFDM_Symbol+1:(i+1)*Length_OFDM_Symbol-1]);
    %Remove Cyclic Prefix
    A_OFDM_Symbol=A_OFDM_Symbol(1,[nSampGI+1:Length_OFDM_Symbol]);
    %Serial to Parallel
    A_OFDM_Symbol_Se=A_OFDM_Symbol.';
    %FFT (FFT size)
    QPSK_Symbols_FFT=fft(A_OFDM_Symbol_Se)/sqrt(nFFTSize);
    QPSK_Symbols=QPSK_Symbols_FFT(subcarrierIndex,1);
    %clear A_OFDM_Symbol;
    %Parallel to Serial (# of QPSK symbol)
    QPSK_Symbols=QPSK_Symbols.';
    %QPSK Demodulation
    QPSK_Symbols_De=2*(real(QPSK_Symbols)>0)-1+1j*(2*(imag(QPSK_Symbols)>0)-1);
    Data_QPSK=[real(QPSK_Symbols_De)>0;imag(QPSK_Symbols_De)>0;]; 
    %Bit Stream
    Data_row(i+1,:)=reshape(Data_QPSK,[1,sqrt(modOrder)*nSubcarrier]);
end

Data_row_Se=reshape(Data_row',[length(Data_row(:)),1]);
Data_reshaped=reshape(Data_row_Se,[length(Data_row_Se(:))/N_ASCII_Bits,N_ASCII_Bits]);
Data_ASCII=bi2de(Data_reshaped);
Data=char(Data_ASCII');