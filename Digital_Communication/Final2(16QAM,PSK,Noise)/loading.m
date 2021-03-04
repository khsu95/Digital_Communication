clc,clear

Eb_N0_dB_vec=[-10:1:20];

BPSK=load('BPSK.mat');
QPSK=load('QPSK.mat');
QAM=load('QAM.mat');

BPSK_AWGN_Theo=BPSK.ber_ideal_AWGN;
BPSK_AWGN_Empi=BPSK.BER_Awgn;
BPSK_Ray_Theo=BPSK.ber_ideal_Rayleigh;
BPSK_Ray_Empi=BPSK.BER_Rayleigh;

QPSK_AWGN_Theo=QPSK.ber_ideal_AWGN;
QPSK_AWGN_Empi=QPSK.BER_Awgn;
QPSK_Ray_Theo=QPSK.ber_ideal_rayleigh;
QPSK_Ray_Empi=QPSK.BER_Rayleigh;

QAM_AWGN_Theo=QAM.ber_ideal_AWGN;
QAM_AWGN_Empi=QAM.BER_Awgn;
QAM_Ray_Theo=QAM.ber_ideal_rayleigh;
QAM_Ray_Empi=QAM.BER_Rayleigh;



subplot(1,2,1);
semilogy(Eb_N0_dB_vec,BPSK_AWGN_Theo,'-g');
hold on, grid on;

q1=plot(Eb_N0_dB_vec, BPSK_AWGN_Empi,'o');
set(q1,'markersize',5,'markerEdgeColor','g','MarkerFaceColor','r')

semilogy(Eb_N0_dB_vec,QPSK_AWGN_Theo,'-.y');
q2=plot(Eb_N0_dB_vec, QPSK_AWGN_Empi,'+');
set(q2,'markersize',5,'markerEdgeColor','y','MarkerFaceColor','r')

semilogy(Eb_N0_dB_vec,QAM_AWGN_Theo,'--b');
q3=plot(Eb_N0_dB_vec, QAM_AWGN_Empi,'s');
set(q3,'markersize',5,'markerEdgeColor','b','MarkerFaceColor','r')

axis([-10,20,1e-5,1]);
legend('BPSK AWGN Theoretical','BPSK AWGN Empirical','QPSK AWGN Theoretical','QPSK AWGN Empirical','16QAM AWGN Theoretical','16QAM AWGN Empirical');
xlabel('E_b/N_0(dB)'), ylabel('BER'),title('BER for AWGN')

subplot(1,2,2)
semilogy(Eb_N0_dB_vec,BPSK_Ray_Theo,'-g');
hold on, grid on;
q4=plot(Eb_N0_dB_vec, BPSK_Ray_Empi,'o');
set(q4,'markersize',5,'markerEdgeColor','g','MarkerFaceColor','r')


semilogy(Eb_N0_dB_vec,QPSK_Ray_Theo,'-.y');
q5=plot(Eb_N0_dB_vec, QPSK_Ray_Empi,'+');
set(q5,'markersize',5,'markerEdgeColor','y','MarkerFaceColor','r')

semilogy(Eb_N0_dB_vec,QAM_Ray_Theo,'--b');
q6=plot(Eb_N0_dB_vec, QAM_Ray_Empi,'s');
set(q6,'markersize',5,'markerEdgeColor','b','MarkerFaceColor','r')

legend('BPSK Rayleigh Theoretical','BPSK Rayleigh Empirical','QPSK Rayleigh Theoretical','QPSK Rayleigh Empirical','16QAM Rayleigh Theoretical','16QAM Rayleigh Empirical');
xlabel('E_b/N_0(dB)'), ylabel('BER'), title('BER for Rayleigh')

axis([-10,20,1e-5,1]);