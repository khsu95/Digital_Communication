clc; clear;

%%%Transmit
%%BPSK
Length =8;
PSK_Order=2;
Data=randi([0 modOrder-1],1,Length);
Symbol_BPSK=pskmod(Data,modOrder,0);

%%IFFT
Tx_OFDM=ifft(Symbol_BPSK)*sqrt(Length);

figure; hold on;box on;
subplot(2,1,1);stem(tx_mod','Linewidth',2);grid on;xlabel('Sample in Freq');ylabel('Value');title('BPSK Symbols');ylim([-2 2]);
subplot(2,1,2);plot(abs(Tx_OFDM'),'r-','Linewidth',2);grid on;xlabel('Sample in Time');ylabel('Value');title('Symols After IFFT(amplitude)');


%%P2S
tx_ofdm=Tx_OFDM';

%%PAPR Check
max_pow=max((abs(tx_ofdm)).^2);
mean_pow=mean((abs(tx_ofdm)).^2);
PAPR=10*log10(max_pow/mean_pow);

%%Receiver

%%S2P
rx_ofdm=tx_ofdm';

%%FFT
rx_fft=fft(rx_ofdm)/sqrt(sample);

figure;hold on;box on;
stem(real(tx_mod'),'o','Linewidth',2)
stem(real(rx_fft'),'--x','Linewidth',2)
xlabel('Sample'),ylabel('Value'),legend('Before IFFT','After FFT')
grid on;

%%P2S
rx_fft=rx_fft';

%%BPSK Demodulation
rx=pskdemod(rx_fft,modOrder,0);

%%Check Symbol;
x=[1:sample];
figure;hold on
stem(x,tx,'o','Linewidth',2);
stem(x,rx,'--x','Linewidth',2);
grid on;
xlabel('Index'),ylabel('Value'),legend('Tx Bits','Rx Bits'),ylim([0 1.5])