clc; clear;
N_sym=1e5;

Eb_N0_dB_vec=[0:1:10];

ber_ideal=berawgn(Eb_N0_dB_vec,'psk',2,'nondiff');

for dB=0:10
    N0_dB=-dB;
    N0_mw=db2pow(N0_dB);
    parfor i=1:N_sym
        %%Transmit
        %Generate Binary Bits
        Length =8;
        PSK_Order=2;
        Data=randi([0 PSK_Order-1],1,Length);
        %BPSK
        Symbol_BPSK=Data*2-1
        %IFFT
        Tx_OFDM=ifft(Symbol_BPSK)*sqrt(Length);

        %%Channel
        %AWGN Noise
        noise=sqrt(N0_mw/2)*(randn(1,8)+1j*randn(1,8));
        Tx_noise=Tx_OFDM+noise;

        %%Receiver
        %FFT
        Rx_OFDM_Demod=fft(Tx_noise)/sqrt(Length);
        %BPSK Demodulation
        Rx_Estimation=real(Rx_OFDM_Demod>0);
        
        %%BER
        Bit_Error=sum(Data~=Rx_Estimation);
        n_BE(i)=Bit_Error;
    end
    ber_(1,dB+1)=sum(n_BE)/N_sym/8;
end

semilogy(Eb_N0_dB_vec,ber_ideal),hold on, grid on;
q1=plot(Eb_N0_dB_vec,ber_,'o');set(q1,'markersize',5,'markerEdgeColor','r','MarkerFaceColor','r')
axis([0,10,1e-5,1]), xlabel('E_b/N_0(dB)'), ylabel('BER'), title('OFDM-BPSK')