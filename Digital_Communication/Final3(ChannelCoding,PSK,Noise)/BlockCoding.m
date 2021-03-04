function Source_En=BlockCoding(Source)
    n=7;
    k=4;
    Generate=[1 1 1 1 0 0 0; 1 0 1 0 1 0 0; 0 1 1 0 0 1 0; 1 1 0 0 0 0 1];
    N_sym=length(Source)/k;
    Source_En=zeros(1,N_sym*n);
    for m=1:N_sym
        Block=Source(m*k-3:m*k);
        Codeword=mod(Block*Generate,2);
        Source_En(m*n-6:m*n)=Codeword;
    end
end
        