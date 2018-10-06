function CV = ComputeCV(mean_clas,gadso)
%%CV
    N=size(gadso,2);
    K=size(gadso,1);
    pdis_max=[];
    pdis_min=[];
        for n=1:N  
            w=1;
            for c=1:K
                for z=c+1:K
                    if z~=c
                         pdis_max(w,n)= max(gadso(c,n),gadso(z,n));
                         pdis_min(w,n)= min(gadso(c,n),gadso(z,n));
                         w=w+1;
                    end 
                end
            end
        end


    dprima=1-sum(pdis_min,2)./sum(pdis_max,2); 
    Dmin=min(dprima);
    Dis=[];
    dk=[];
    UMk = max(gadso,[],2);
    for c=1:K
        for n=1:N
            dk(c,n)=UMk(c)-gadso(c,n);
        end
        Dis(c)=1-sum(dk(c,:).*exp(dk(c,:)))./(N*UMk(c)*exp(UMk(c)));
    end
    Dis=sum(Dis);

    CV = (Dis/N)*Dmin*sqrt(K);


