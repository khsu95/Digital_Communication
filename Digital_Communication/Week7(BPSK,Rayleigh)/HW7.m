clc, clear;
%%%Declare
N_sym=1e5;
Eb_mW=1;
Eb_dB=pow2db(Eb_mW);

Eb_N0_dB_vec=[0:0.1:30];
Eb_N0_mW_vec=db2pow(Eb_N0_dB_vec);
%%%Input

%%%Calculate
%Ideal
 BER_ideal=1/2.*(1-sqrt(Eb_N0_mW_vec./(Eb_N0_mW_vec+1)));
 
%Practical
for N0_dB=[-30:3:0]
    N0_mW=db2pow(N0_dB);
    Eb_N0_dB=Eb_dB-N0_dB;
    Eb_N0_mW=db2pow(Eb_N0_dB);
    parfor i=1:N_sym
        %Generate Binarty Bits
        bits=rand()>0.5;
        
        %BPSK Modulation
        symbol=Eb_mW*(2*bits-1);
        
        %Channel Response
        h_R=randn()/sqrt(2);
        h_I=randn()/sqrt(2);
        h=h_R+1j*h_I;
        
        %Channel Applied
        y_c=symbol*h;
        
        %AWGN Noise
        noise=sqrt(N0_mW/2)*(randn()+1j*randn());
        
        %Received Signal
        y=y_c+noise;
        
        %Channle Compenstation
        h_comp=conj(h)/(abs(h)^2);
        r=h_comp*y;
        
        %Demodulation
        bits_re=real(r>0);
        
        %Count Error Bits
        n_err(1,i)=(bits_re~=bits);
        
        %Constellation
        if bits==1
            coordi_plused(:,i)=[real(r);imag(r)];
        else
            coordi_minused(:,i)=[real(r);imag(r)];
        end
    end
    %BER
    index=(30-Eb_N0_dB)/3+1;
    ber_=mean(n_err,2);
    BER_emph(1,index)=ber_;
end

%%%Output
BER_emph=fliplr(BER_emph);
xaxis=[0:3:30];
semilogy(Eb_N0_dB_vec,BER_ideal),hold on, grid on;
q1=plot(xaxis,BER_emph,'o');set(q1,'markersize',5,'markerEdgeColor','r','MarkerFaceColor','r')
axis([0,30,1e-4,1]), xlabel('E_b/N_0(dB)'), ylabel('BER'), title('BER for BPSK applied Rayleigh Channel')
legend('Theoretical BER','Empirical BER');