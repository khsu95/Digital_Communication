function [Stream_AWGN, Stream_Ray]=QAM_16(Source,EbN0_Decibel)
order=4;
N_sym=length(Source)/order;
Eb_mW=db2pow(EbN0_Decibel);
N0_mW=db2pow(-EbN0_Decibel);

Gray_Index=[0 1 3 2];
Mapping_Index=[-3 -1 1 3];
Normalize_abs=1/sqrt(10);

%%Calculate
Stream_AWGN=zeros(1,length(Source));
Stream_Ray=zeros(1,length(Source));
for k=1:N_sym
    %Generate 4 Binary Bits
    bits=Source(4*k-3:4*k);
    
    %%QAM Modulation
    %Real Axis
    Re_Bits=bits(1:2);
    Re_Dec=sum(Re_Bits.*[2 1]); %Conversion from Binary to Decimal
    Index=(Gray_Index(1,Re_Dec+1));
    Re_Gray=Mapping_Index(1,Index+1);
    %Image Axis
    Im_Bits=bits(3:4);
    Im_Dec=sum(Im_Bits.*[2 1]);
    Index=(Gray_Index(1,Im_Dec+1));
    Im_Gray=Mapping_Index(1,Index+1);
    %Transmit
    Tx=(Re_Gray+1j*Im_Gray)*Normalize_abs;
    
    %%Channel
    %AWGN
    noise=[randn()+j*randn()].*sqrt(order*N0_mW/2);
    %Rayleigh Fading
    noise_Rayleigh=sqrt(order*N0_mW/2)*(randn()+1j*randn());
    h=(randn()+1j*randn())/sqrt(2);
    %Apply
    Rx_Awgn=Tx+noise;
    Rx_Rayleigh=h*Tx+noise_Rayleigh;
    
    %%%Demodulation
    %%AWGN
    %Seperate
    Rx_Awgn_Re=real(Rx_Awgn)/Normalize_abs;
    Rx_Awgn_Im=imag(Rx_Awgn)/Normalize_abs;
    %Constellation
    Hat_Awgn_Re=Closest(Rx_Awgn_Re);
    Hat_Awgn_Im=Closest(Rx_Awgn_Im);
    %Demapping
    Hat_Awgn_Bits_Re=Demapping(Hat_Awgn_Re);
    Hat_Awgn_Bits_Im=Demapping(Hat_Awgn_Im);
    Hat_Awgn_Bits=[Hat_Awgn_Bits_Re,Hat_Awgn_Bits_Im];
    
    %%Rayleigh
    %Channel Compensation
    h_comp=conj(h)/(abs(h)^2);
    Rx_Rayleigh_Comp=h_comp*Rx_Rayleigh;
    %Seperate
    Rx_Rayleigh_Re=real(Rx_Rayleigh_Comp)/Normalize_abs;
    Rx_Rayleigh_Im=imag(Rx_Rayleigh_Comp)/Normalize_abs;
    %Constellation
    Hat_Rayleigh_Re=Closest(Rx_Rayleigh_Re);
    Hat_Rayleigh_Im=Closest(Rx_Rayleigh_Im);
    %Demapping
    Hat_Rayleigh_Bits_Re=Demapping(Hat_Rayleigh_Re);
    Hat_Rayleigh_Bits_Im=Demapping(Hat_Rayleigh_Im);
    Hat_Rayleigh_Bits=[Hat_Rayleigh_Bits_Re,Hat_Rayleigh_Bits_Im];
    
    Stream_AWGN(4*k-3:4*k)=Hat_Awgn_Bits;
    Stream_Ray(4*k-3:4*k)=Hat_Rayleigh_Bits;
end
        

        
        
        