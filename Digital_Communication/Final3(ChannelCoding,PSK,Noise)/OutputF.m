function Out=Output(BER_Block,BER_Conv)
    ebno=(-10:20);

    
    %BPSK-AWGN
    plot(ebno, BER_Block(1,:,1),'b');
    
    hold on, grid on;
    
    %%Block
        %QPSK-AWGN
        plot(ebno, BER_Block(1,:,2),'g');

        %QAM-AWGN
        plot(ebno, BER_Block(1,:,3),'r');

        %BPSK-Ray
        plot(ebno, BER_Block(2,:,1),'c');

        %QPSK-Ray
        plot(ebno, BER_Block(2,:,2),'m');

        %QAM-Ray
        plot(ebno, BER_Block(2,:,3),'y');
   
    %%Conv
        %BPSK-AWGN
        plot(ebno, BER_Conv(1,:,1),'-.b');
    
        %QPSK-AWGN
        plot(ebno, BER_Conv(1,:,2),'-.g');

        %QAM-AWGN
        plot(ebno, BER_Conv(1,:,3),'-.r');

        %BPSK-Ray
        plot(ebno, BER_Conv(2,:,1),'-.c');

        %QPSK-Ray
        plot(ebno, BER_Conv(2,:,2),'-.m');

        %QAM-Ray
        plot(ebno, BER_Conv(2,:,3),'-.y');
    
    
    legend('Block-AWGN-BPSK','Block-AWGN-QPSK','Block-AWGN-QAM','Block-Ray-BPSK','Block-Ray-QPSK','Block-Ray-QAM','Conv-AWGN-BPSK','Conv-AWGN-QPSK','Conv-AWGN-QAM','Conv-Ray-BPSK','Conv-Ray-QPSK','Conv-Ray-QAM');
    axis([-10,20,1e-5,1]);
end