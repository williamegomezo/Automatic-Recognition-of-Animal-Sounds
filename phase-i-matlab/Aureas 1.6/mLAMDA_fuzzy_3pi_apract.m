function [gadso,recon,mean_class] = mLAMDA_fuzzy_3pi_apract(it_num,dat_norma1,mean_class, flag)

%flag es para seleccionar sólo las especies que tuevieron entrenamiento, y
%no permitir la creación de nuevas clases (1 crea clases, 0 no crea clases)

%%%%% % mean_class=[NIC; classes]; %sin NIC
[clusters,xx]=size(mean_class);
[num_clases,xx]=size(mean_class);
[num_datos, num_feat] = size(dat_norma1);
%mean_class = [mean(dat_norma1,1); mean_class];
mean_class = [ones(1,num_feat)*0.5; mean_class];
conteo = [zeros(1,1000)]; %hasta 1000 clases 

%%%% winsorizacion prueba
[n,m]=size(dat_norma1);

dat_norma=dat_norma1;
% for j=1:m
%     a=prctile(dat_norma1(:,j),95); % winsorization
%     b=prctile(dat_norma1(:,j),5); % winsorization
%     dat_norma(:,j)=(dat_norma1(:,j)-b)/(a-b);
%     a1=find(dat_norma(:,j)>1);% winsorization
%     b1=find(dat_norma(:,j)<0);% winsorization
%     dat_norma(a1,j)=0;
%     dat_norma(b1,j)=0;
% end
%%%%
if flag == 1
    for t =1:it_num
    
        for j = 1:num_datos
            mads = (mean_class.^(dat_norma(j*ones(size(mean_class,1),1),:))).*((1-mean_class).^(1-dat_norma(j*ones(size(mean_class,1),1),:)));
            gads = prod(mads,2)./(prod(mads,2)+(prod(1-mads,2)));
            [x,i_gad]=max(gads);
            
            
            if i_gad == 1 
                num_clases = num_clases + 1;
                conteo(num_clases)=1;
                mean_class = [mean_class;mean([mean_class(1,:);dat_norma(j,:)])];
            else
                conteo(i_gad)=conteo(i_gad)+1;
                new_mean = mean_class(i_gad,:) + (1/(conteo(i_gad)))*(dat_norma(j,:)-mean_class(i_gad,:)); %(1/(conteo(i_gad)))
                mean_class(i_gad,:) = new_mean;
            end
        end

    end

    gadso = zeros(num_clases,num_datos); %num_clases para retirar la NIC
    for j = 1:num_datos
        mads = (mean_class(2:end,:).^(dat_norma(j*ones(size(mean_class(2:end,:),1),1),:))).*((1-mean_class(2:end,:)).^(1-dat_norma(j*ones(size(mean_class(2:end,:),1),1),:)));
        gadso(:,j) = prod(mads,2)./(prod(mads,2)+(prod(1-mads,2)));
    end
    [x, recon] = max(gadso,[],1);
else
    
    gadso = zeros(num_clases+1,num_datos); %num_clases para retirar la NIC
    for j = 1:num_datos
        mads = (mean_class.^(dat_norma(j*ones(size(mean_class,1),1),:))).*((1-mean_class).^(1-dat_norma(j*ones(size(mean_class,1),1),:)));
        gadso(:,j) = prod(mads,2)./(prod(mads,2)+(prod(1-mads,2)));
       % gadso(1,j)=0.98; %Forzando la NIC
    end
    [x, recon] = max(gadso,[],1);
end


