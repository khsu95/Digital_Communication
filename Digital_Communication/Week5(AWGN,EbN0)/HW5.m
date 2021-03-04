clc, clear;

%%Declare

syms Eb t Tb f

N_sym=1e5;

f=1/Tb;
Eb=db2pow(0);
%N0=db2pow(-10);
basis_f=sqrt(2/Tb)*cos(2*pi*f*t);

coordi_=zeros(2,N_sym);
N_error=zeros(1,N_sym);

%%Input

%%Calculate

%Reference Signal
ref1_sig=sqrt(Eb)*basis_f;
cor1=int(ref1_sig*basis_f,t,[0,Tb]);
ref0_sig=-sqrt(Eb)*basis_f;
cor0=int(ref0_sig*basis_f,t,[0,Tb]);
coordinates_=[cor0, cor1]

for j=-10:3
    %N0=db2pow(j)
    N0=j;
    parfor i=1:N_sym
        %Generate Binary Bits
        bits=rand()>0.5;

        %BPSK Modulation

        if bits==1
            sn_t=sqrt(Eb);%*basis_f;
        else
            sn_t=-sqrt(Eb);%*basis_f;
        end

        %AWGN
        AWGN=sqrt(db2pow(N0)/2)*randn();%*basis_f;
        r_t=sn_t+AWGN;

        %Demodulation
        %Correlator
        %z_t=vpa(int(r_t*basis_f,t,[0,Tb]));
        z_t=r_t;

        %Decider
        if z_t>0
            b_est=1;
        else
            b_est=0;
        end

        N_error(i)=(b_est~=bits);
        corrdi(1,i)=z_t;
        coordi(2,i)=b_est;
        i
    end
    %BER
    EbN0_db=pow2db(Eb)-N0;
    EbN0=10.^(EbN0_db/10);
    ber_(1,j+11)=sum(N_error)/N_sym;
    ber_(2,j+11)=1/2.*erfc(sqrt(EbN0));
end


%%Output
ber_=fliplr(ber_);
x_axis=[-3:1:10];
semilogy(x_axis,ber_(2,:));
hold on, grid on
q1=plot(x_axis,ber_(1,:),'o');set(q1,'markersize',5,'markerEdgeColor','r','MarkerFaceColor','r')
axis([-3,10,1e-5,1]), xlabel('E_b/N_0(dB)'), ylabel('BER'), title('Bit Error Rate for Binary Phase-Shift Keying')
legend('Theoretical BER','Empirical BER')