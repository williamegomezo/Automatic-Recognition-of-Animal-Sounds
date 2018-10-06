function [gadso,recon,mean_clas,std_clas] = LAMDA_unsup2(ex_level,it_num,dat_norma,mad,gad)

[num_datos, num_feat] = size(dat_norma);

num_clases = 1;
mean_clas = mean(dat_norma,1);
%mean_clas = ones(1,num_feat)*0.5;
std_clas = ones(1,num_feat)*0.25;
conteo = [];


for t =1:it_num

    for j = 1:num_datos
        switch mad
             case 'binomial'
             mads = (mean_clas.^(dat_norma(j*ones(size(mean_clas,1),1),:))).*((1-mean_clas).^(1-dat_norma(j*ones(size(mean_clas,1),1),:)));
             case 'gauss'
             mads = exp((-(dat_norma(j*ones(size(mean_clas,1),1),:)-mean_clas).^2)./(2*std_clas.^2));   
             otherwise
             disp('incorrect GAD')    
        end
        switch gad
            case '3pi'
            gads = prod(mads,2)./(prod(mads,2)+(prod(1-mads,2)));
            case 'minmax'
            gads = ex_level.*min(mads,[],2)+(1-ex_level).*max(mads,[],2); 
            case 'sumprob'
            for k = 1:num_clases
            gads(k) = mads(k,1);
            for m = 2 : num_feat
                gads(k) = ex_level*(gads(k)*mads(k,m))+(1-ex_level)*((gads(k)+mads(k,m))-gads(k)*mads(k,m));
            end
            end
            gads = mean(mads');    
            otherwise
            disp('incorrect MAD')
        end
        [x,i_gad]=max(gads);
        if i_gad == 1 
            num_clases = num_clases + 1;
            conteo(num_clases)=1;
            mean_clas = [mean_clas;mean([mean_clas(1,:);dat_norma(j,:)])]; 
            std_clas = [std_clas;mov_std(mean_clas(1,:),mean([mean_clas(1,:);dat_norma(j,:)]),2,std_clas(1,:))];
        else
            conteo(i_gad)=conteo(i_gad)+1;
            new_mean = mean_clas(i_gad,:) + (1/(conteo(i_gad)))*(dat_norma(j,:)-mean_clas(i_gad,:)); 
            std_clas(i_gad,:) = mov_std(mean_clas(i_gad,:),new_mean,conteo(i_gad),std_clas(i_gad,:));
            mean_clas(i_gad,:) = new_mean;
        end
    end
    
end

gadso = zeros(num_clases-1,num_datos);
for j = 1:num_datos
    switch mad
             case 'binomial'
             mads = (mean_clas(2:end,:).^(dat_norma(j*ones(size(mean_clas(2:end,:),1),1),:))).*((1-mean_clas(2:end,:)).^(1-dat_norma(j*ones(size(mean_clas(2:end,:),1),1),:)));
             case 'gauss'
             mads = exp((-(dat_norma(j*ones(size(mean_clas(2:end,:),1),1),:)-mean_clas(2:end,:)).^2)./(2*std_clas(2:end,:).^2));
             otherwise
             disp('incorrect GAD') 
    end
    switch gad
            case '3pi'
            gadso(:,j) = prod(mads,2)./(prod(mads,2)+(prod(1-mads,2)));
            case 'minmax'
            gadso(:,j) = ex_level.*min(mads,[],2)+(1-ex_level).*max(mads,[],2);    
            case 'sumprob' 
            for k = 1:num_clases-1
            gadso(k,j) = mads(k,1);
            for m = 2 : num_feat
            gadso(k,j) = ex_level*(gadso(k,j)*mads(k,m))+(1-ex_level)*((gadso(k,j)+mads(k,m))-gadso(k,j)*mads(k,m));
            end
            end    
            otherwise
            disp('incorrect MAD')
    end
    
end

[x, recon] = max(gadso,[],1);



