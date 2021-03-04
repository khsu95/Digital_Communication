clc, clear;

%%Declare

N_sym=1e5;
Eb_mW=1;

Eb_N0_dB_vec=[-3:1:10];

%%Input

%%Calculate

ber_ideal=berawgn(Eb_N0_dB_vec,'psk',4,'nondiff');
ser_ideal=1-(1-ber_ideal).^2;
for dB=-10:3
    N0_dB=dB;
    N0_mW=db2pow(N0_dB);
    parfor i=1:N_sym
        %Generate Binary Bits
        bits=rand(2,1)>0.5;

        %QPSK Modulation
        bits_after_encoding=bits*2-1;
        Es_mW=2*Eb_mW;
        symbol=sqrt(Es_mW/2)*(bits_after_encoding(1)+1j*bits_after_encoding(2)); %Mapping
        
        %AWGN
        noise=sqrt(N0_mW/2)*(randn()+1j*randn());
        r_t=symbol+noise;

        %Demodulation
        symbol_after_decoding=2*(real(r_t)>0)-1+1j*(2*(imag(r_t)>0)-1);
        bit_re=[real(symbol_after_decoding)>0;
            imag(symbol_after_decoding)>0];
        
        %SER
        bool_symbol_error=(symbol~=symbol_after_decoding);
        n_SE(i)=bool_symbol_error;
        %BER
        bit_error=sum(bits~=bit_re);
        n_BE(i)=bit_error;
    end
    ser_(1,dB+11)=sum(n_SE)/N_sym;
    ber_(1,dB+11)=sum(n_BE)/N_sym/2;
    
end


%%Output
ber_=fliplr(ber_),ser_=fliplr(ser_);
subplot(1,2,1),semilogy(Eb_N0_dB_vec,ber_ideal),hold on, grid on;
q1=plot(Eb_N0_dB_vec,ber_,'o');set(q1,'markersize',5,'markerEdgeColor','r','MarkerFaceColor','r')
axis([-3,10,1e-5,1]), xlabel('E_b/N_0(dB)'), ylabel('BER'), title('BER for QPSK')

subplot(1,2,2),semilogy(Eb_N0_dB_vec,ser_ideal),hold on, grid on;
q1=plot(Eb_N0_dB_vec,ser_,'o');set(q1,'markersize',5,'markerEdgeColor','r','MarkerFaceColor','r')
axis([-3,10,1e-5,1]), xlabel('E_b/N_0(dB)'), ylabel('SER'), title('SER for QPSK')