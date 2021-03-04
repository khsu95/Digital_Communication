clc, clear;

%%Declare
N_sym=1e5;
Eb_mW=1;
Es_mW=2*Eb_mW;
Normalize_abs=1/sqrt(2);

Eb_N0_dB_vec=[-10:1:20];
Es_N0_dB_vec=Eb_N0_dB_vec+10*log10(2);

%%Input

%%Calculate

ber_ideal_AWGN=berawgn(Eb_N0_dB_vec,'psk',4,'nondiff');
ber_ideal_rayleigh=berfading(Eb_N0_dB_vec,'psk',4,1);

for p=1:length(Eb_N0_dB_vec)
    N0_Sym_dB=-Es_N0_dB_vec(p);
    N0_Sym_mW=db2pow(N0_Sym_dB);
    parfor k=1:N_sym
        %Generate Binary Bits
        bits=rand(2,1)>0.5;

        %QPSK Modulation
        bits_after_encoding=bits*2-1;
        Tx=Normalize_abs*(bits_after_encoding(1)+1j*bits_after_encoding(2)); %Mapping
                
        %AWGN
        noise=sqrt(N0_Sym_mW/2)*(randn()+1j*randn());
        
        %Rayleigh Fading Channel
        noise_Rayleigh=sqrt(N0_Sym_mW/2)*(randn()+1j*randn());
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
        Hat_Rayleigh_Bits=[real(symbol_after_decoding)>0;
                imag(symbol_after_decoding)>0];
        
        %AWGN
        symbol_after_decoding=2*(real(Rx_Awgn)>0)-1+1j*(2*(imag(Rx_Awgn)>0)-1);
        Hat_AWGN_Bits=[real(symbol_after_decoding)>0;
                        imag(symbol_after_decoding)>0];

        %%BER
        %AWGN
        BER_Awgn=sum(bits~=Hat_AWGN_Bits);
        n_BE_Awgn(k)=BER_Awgn;
        %Rayleigh
        BER_Rayleigh=sum(bits~=Hat_Rayleigh_Bits);
        n_BE_Rayleigh(k)=BER_Rayleigh;
        
    end
    BER_Awgn(1,p)=sum(n_BE_Awgn)/(N_sym*2);
    BER_Rayleigh(1,p)=sum(n_BE_Rayleigh)/(N_sym*2);
    
end


%%Output
semilogy(Eb_N0_dB_vec,ber_ideal_AWGN),hold on, grid on;
q1=plot(Eb_N0_dB_vec,BER_Awgn,'o');set(q1,'markersize',5,'markerEdgeColor','r','MarkerFaceColor','r')
axis([-10,20,1e-5,1]), xlabel('E_b/N_0(dB)'), ylabel('BER'), title('BER for QPSK')


semilogy(Eb_N0_dB_vec,ber_ideal_rayleigh),hold on, grid on;
q2=plot(Eb_N0_dB_vec,BER_Rayleigh,'square');set(q2,'markersize',5,'markerEdgeColor','b','MarkerFaceColor','b')