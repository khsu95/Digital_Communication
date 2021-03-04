function [Stream_AWGN, Stream_Ray]=BPSK(Source,EbN0_Decibel)
    order=1;
    N_sym=length(Source)/order;
    Eb_mW=db2pow(EbN0_Decibel);
    N0_mW=db2pow(-EbN0_Decibel);

    Stream_AWGN=zeros(1,length(Source));
    Stream_Ray=zeros(1,length(Source));
    for k=1:N_sym
        Bit=Source(k);
        %BPSK Modulation
        Tx=(Bit*2-1)*sqrt(Eb_mW);

        %%Channel
        %AWGN
        noise=sqrt(N0_mW/2)*randn();
        %Rayleigh Fading
        Rayleigh_noise=sqrt(N0_mW/2)*(randn()+1j*randn());
        h=(randn()+1j*randn())/sqrt(2);
        %Apply
        Rx_Awgn=Tx+noise;
        Rx_Rayleigh=h*Tx+Rayleigh_noise;

        %%%Demodulation
        %%AWGN
        Hat_Awgn_Bit=(Rx_Awgn>0);

        %%Rayleigh
        %Channel Compensation
        h_comp=conj(h)/(abs(h)^2);
        Rx_Rayleigh_Comp=h_comp*Rx_Rayleigh;
        %Demapping
        Hat_Rayleigh_Bit=real(Rx_Rayleigh_Comp>0);
        
        Stream_AWGN(k)=Hat_Awgn_Bit;
        Stream_Ray(k)=Hat_Rayleigh_Bit;

    end
end

