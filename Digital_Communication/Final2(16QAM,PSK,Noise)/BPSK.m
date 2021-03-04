clc, clear;

%%Declare
N_sym=1e5;
Eb_mW=1;
Eb_N0_dB_vec=[-10:1:20];
Eb_N0_mW_vec=db2pow(Eb_N0_dB_vec);

%%Calculate
%Ideal BER
ber_ideal_AWGN=berawgn(Eb_N0_dB_vec,'psk',2','nondiff');
ber_ideal_Rayleigh=1/2.*(1-sqrt(Eb_N0_mW_vec./(Eb_N0_mW_vec+1)));

for p=1:length(Eb_N0_dB_vec)
    N0_dB=-Eb_N0_dB_vec(p);
    N0_mW=db2pow(N0_dB);
    for k=1:N_sym
        %Geneerate 2 Binary Bits
        Bit=rand()>0.5;
        
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
        
        %%BER
        %AWGN
        Error_Awgn=(Bit~=Hat_Awgn_Bit);
        n_BE_Awgn(k)=Error_Awgn;
        %Rayleigh
        Error_Rayleigh=(Bit~=Hat_Rayleigh_Bit);
        n_BE_Rayleigh(k)=Error_Rayleigh;
    end
    BER_Awgn(1,p)=sum(n_BE_Awgn)/N_sym;
    BER_Rayleigh(1,p)=sum(n_BE_Rayleigh)/N_sym;
end

%%Output
semilogy(Eb_N0_dB_vec,ber_ideal_AWGN),hold on, grid on;
q1=plot(Eb_N0_dB_vec,BER_Awgn,'o');set(q1,'markersize',5,'markerEdgeColor','r','MarkerFaceColor','r')

semilogy(Eb_N0_dB_vec,ber_ideal_Rayleigh),hold on, grid on;
q2=plot(Eb_N0_dB_vec,BER_Rayleigh,'o');set(q2,'markersize',5,'markerEdgeColor','m','MarkerFaceColor','m')

axis([-10,20,1e-5,1]), xlabel('E_b/N_0(dB)'), ylabel('BER'), title('BER for BPSK'), legend("AWGN Theoretical","AWGN Empirical","Rayleigh Theoretical","Rayleigh Empirical") 

        