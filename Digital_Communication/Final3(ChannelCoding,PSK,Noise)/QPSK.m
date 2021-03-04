function [Stream_AWGN, Stream_Ray]=QPSK(Source,EbN0_Decibel)
order=2;
N_sym=length(Source)/order;
Es_N0_dB=EbN0_Decibel+10*log10(2);
N0_Sym_dB=-Es_N0_dB;
N0_Sym_mW=db2pow(N0_Sym_dB);

%%Input

%%Calculate
Stream_AWGN=zeros(1,length(Source));
Stream_Ray=zeros(1,length(Source));
for k=1:N_sym
    %Generate Binary Bits
    bits=Source(2*k-1:2*k);
    
    %QPSK Modulation
    bits_after_encoding=bits*2-1;
    Tx=sqrt(1/2)*(bits_after_encoding(1)+1j*bits_after_encoding(2)); %Mapping
    
    %AWGN
    noise=sqrt(N0_Sym_mW)*(randn()+1j*randn());
    
    %Rayleigh Fading Channel
    noise_Rayleigh=sqrt(N0_Sym_mW)*(randn()+1j*randn());
    h=(randn()+1j*randn())/sqrt(2);
    
    %Channel Applied
    Rx_Awgn=Tx+noise;
    Rx_Rayleigh=Tx*h+noise_Rayleigh;
    
    %Channle Compenstation
    h_comp=conj(h)/(abs(h)^2);
    rayleigh_=h_comp*Rx_Rayleigh;
    
    %Demodulation
    %Rayleigh
    symbol_after_decoding=2*(real(rayleigh_)>0)-1+1j*(2*(imag(rayleigh_)>0)-1);
    Hat_Rayleigh_Bits=[real(symbol_after_decoding)>0,
        imag(symbol_after_decoding)>0];
    
    %AWGN
    symbol_after_decoding=2*(real(Rx_Awgn)>0)-1+1j*(2*(imag(Rx_Awgn)>0)-1);
    Hat_AWGN_Bits=[real(symbol_after_decoding)>0;
        imag(symbol_after_decoding)>0];
    
    Stream_AWGN(2*k-1:2*k)=Hat_AWGN_Bits;
    Stream_Ray(2*k-1:2*k)=Hat_Rayleigh_Bits;
    
end

