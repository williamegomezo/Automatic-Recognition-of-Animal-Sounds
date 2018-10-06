function [ Sim_index ] = IndiceSimilitud( gadso )
    N=size(gadso,2);
    K=size(gadso,1);
    pdis_max=[];
    pdis_min=[];
    for n=1:N 
        for c=1:K
            for z=1:K
                     pdis_max(c,z,n)= max(gadso(c,n),gadso(z,n));
                     pdis_min(c,z,n)= min(gadso(c,n),gadso(z,n));
            end
        end
    end

    
    Sim_index = sum(pdis_min,3)./sum(pdis_max,3);
    
end

