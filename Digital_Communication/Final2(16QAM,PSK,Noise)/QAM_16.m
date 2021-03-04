clc, clear;

%%Declare
N_sym=1e5;
Eb_mW=1;
Eb_N0_dB_vec=[-10:1:20];
Es_N0_dB_vec=Eb_N0_dB_vec+10*log10(4); %Symbol Energy

Gray_Index=[0 1 3 2];
Mapping_Index=[-3 -1 1 3];
Normalize_abs=1/sqrt(10);

%%Calculate

%Ideal BER
ber_ideal_AWGN=berawgn(Eb_N0_dB_vec,'qam',16,'nondiff');
ber_ideal_rayleigh=berfading(Eb_N0_dB_vec,'qam',16,1);

for p=1:length(Eb_N0_dB_vec)
    N0_Sym_dB=-Es_N0_dB_vec(p);
    N0_Sym_mW=db2pow(N0_Sym_dB);
    parfor k=1:N_sym
        %Generate 4 Binary Bits
        bits=rand(1,4)>0.5;
        
        %%QAM Modulation
        %Real Axis
        Re_Bits=bits(:,[1:2]);
        Re_Dec=sum(Re_Bits.*[2 1]); %Conversion from Binary to Decimal
        Index=(Gray_Index(1,Re_Dec+1));
        Re_Gray=Mapping_Index(1,Index+1);
        %Image Axis
        Im_Bits=bits(:,[3:4]);
        Im_Dec=sum(Im_Bits.*[2 1]);
        Index=(Gray_Index(1,Im_Dec+1));
        Im_Gray=Mapping_Index(1,Index+1);
        %Transmit
        Tx=(Re_Gray+1j*Im_Gray)*Normalize_abs;
        
        %%Channel
        %AWGN
        noise=[randn()+j*randn()].*sqrt(N0_Sym_mW/2);
        %Rayleigh Fading
        noise_Rayleigh=sqrt(N0_Sym_mW/2)*(randn()+1j*randn());
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
        
        %%BER
        %AWGN
        BER_Awgn=sum(bits~=Hat_Awgn_Bits);
        n_BE_Awgn(k)=BER_Awgn;
        %Rayleigh
        BER_Rayleigh=sum(bits~=Hat_Rayleigh_Bits);
        n_BE_Rayleigh(k)=BER_Rayleigh;
    end
    BER_Awgn(1,p)=sum(n_BE_Awgn)/(N_sym*4);
    BER_Rayleigh(1,p)=sum(n_BE_Rayleigh)/(N_sym*4);
end
        
%%Output
semilogy(Eb_N0_dB_vec,ber_ideal_AWGN),hold on, grid on;
q1=plot(Eb_N0_dB_vec,BER_Awgn,'o');set(q1,'markersize',5,'markerEdgeColor','r','MarkerFaceColor','r')

semilogy(Eb_N0_dB_vec,ber_ideal_rayleigh),hold on, grid on;
q2=plot(Eb_N0_dB_vec,BER_Rayleigh,'o');set(q2,'markersize',5,'markerEdgeColor','m','MarkerFaceColor','m')

axis([-10,20,1e-5,1]), xlabel('E_b/N_0(dB)'), ylabel('BER'), title('BER for 16QAM'), legend("AWGN Theoretical","AWGN Empirical","Rayleigh Theoretical","Rayleigh Empirical") 

        

        
        
        