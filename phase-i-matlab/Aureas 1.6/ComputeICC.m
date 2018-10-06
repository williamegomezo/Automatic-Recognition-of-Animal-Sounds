function Icc = ComputeICC(trainingSet,mean_clas,gadso)
    K=size(gadso,1);
    N=size(trainingSet,1);
    sbe=[];
    mke =  zeros(size(gadso,1),size(trainingSet,2));
    for c=1:K
        pre_mke = zeros(size(trainingSet));
        for n=1:N
            pre_mke(n,:)=repmat(gadso(c,n),[1 size(trainingSet,2)]).*trainingSet(n,:);
        end
        mke(c,:) = sum(pre_mke)/sum(gadso(c,:));
    end

    m=sum(trainingSet)/N;
    for c=1:K
        for n=1:N
            pre_sbe(n)=gadso(c,n).*(mke(c,:)-m)*(mke(c,:)-m)';
        end
        sbe(c) = sum(pre_sbe);
    end

    sbe = sum(sbe);
    Dmin=min(pdist(mean_clas));

    Icc = (sbe/N)*Dmin*sqrt(K);


