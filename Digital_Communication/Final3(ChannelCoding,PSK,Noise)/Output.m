function Out=Output(BER_Block,BER_Conv)
    ebno=(-10:20);

    
    %BPSK-AWGN
    q1=plot(ebno, BER_Block(1,:,1),'o');
    set(q1,'markersize',5,'markerEdgeColor','g','MarkerFaceColor','r')
    
    hold on, grid on;
    
    %%Block
        %QPSK-AWGN
        q2=plot(ebno, BER_Block(1,:,2),'o');
        set(q2,'markersize',5,'markerEdgeColor','g','MarkerFaceColor','r')

        %QAM-AWGN
        q3=plot(ebno, BER_Block(1,:,3),'o');
        set(q3,'markersize',5,'markerEdgeColor','g','MarkerFaceColor','r')

        %BPSK-Ray
        q4=plot(ebno, BER_Block(2,:,1),'o');
        set(q4,'markersize',5,'markerEdgeColor','g','MarkerFaceColor','r')

        %QPSK-Ray
        q5=plot(ebno, BER_Block(2,:,2),'o');
        set(q5,'markersize',5,'markerEdgeColor','g','MarkerFaceColor','r')

        %QAM-Ray
        q6=plot(ebno, BER_Block(2,:,3),'o');
        set(q6,'markersize',5,'markerEdgeColor','g','MarkerFaceColor','r')
   
    %%Conv
        %BPSK-AWGN
        q1=plot(ebno, BER_Conv(1,:,1),'o');
        set(q1,'markersize',5,'markerEdgeColor','g','MarkerFaceColor','r')
    
        %QPSK-AWGN
        q2=plot(ebno, BER_Conv(1,:,2),'o');
        set(q2,'markersize',5,'markerEdgeColor','g','MarkerFaceColor','r')

        %QAM-AWGN
        q3=plot(ebno, BER_Conv(1,:,3),'o');
        set(q3,'markersize',5,'markerEdgeColor','g','MarkerFaceColor','r')

        %BPSK-Ray
        q4=plot(ebno, BER_Conv(2,:,1),'o');
        set(q4,'markersize',5,'markerEdgeColor','g','MarkerFaceColor','r')

        %QPSK-Ray
        q5=plot(ebno, BER_Conv(2,:,2),'o');
        set(q5,'markersize',5,'markerEdgeColor','g','MarkerFaceColor','r')

        %QAM-Ray
        q6=plot(ebno, BER_Conv(2,:,3),'o');
        set(q6,'markersize',5,'markerEdgeColor','g','MarkerFaceColor','r')
    
    

    axis([-10,20,1e-5,1]);
end