function [feat,gadso,recon,mean_clas,std_class] = AlgortimoGenetico(ex_level,it_num,dat_norma,mad,gad)
    Bar = waitbar(0,'Initializing waitbar...','Name','Selecting features');
    waitbar(0,Bar,sprintf('%d%% completed...',0)); 

    Poblacion = 20;
    num_feat  =  size(dat_norma,2);
    Featsize  =  round(size(dat_norma,2)*rand(Poblacion,1));
    Featsize(Featsize<5)=5;

    Feats = zeros(Poblacion,num_feat);
    
    Feats(:,1:2) = 1;
    for i=1:size(Featsize,1)
        Feats(i,randperm(num_feat,Featsize(i)-2)) = 1;
        Featsize(i) = length(find(Feats(i,:)));
    end

    num_generaciones=200;
    Genmetric3 = {};
    Genmetric4 = {};

    Numvivos = 5;
    Numcruces = 5;
    Nummutados = 5;
    Nummutados2 = 5;

    for h=1:num_generaciones

        if h==1
            inicio = 1;
            Metric3= [];
            Metric4= [];
        else
            inicio = Numvivos+1;
        end

        for k=inicio:size(Featsize,1)
            feat = find(Feats(k,:));
            [gadso,recon,mean_clas,std_class] =  LAMDA_unsup2(ex_level, it_num, dat_norma(:,[feat,k]), mad,gad); %ex_level,it_num,entre,dat_norma,connective
                
            [gadso,recon,mean_clas,std_class] =  LAMDA_unsup2_ruidoso(ex_level, it_num, dat_norma(:,[feat,k]), mad,gad, mean(mean_clas)); %ex_level,it_num,entre,dat_norma,connective
                
            Icc = ComputeICC(dat_norma,mean_clas,gadso);
            CV  = ComputeCV(mean_clas,gadso);

            Metric3 = [Metric3;Icc];
            Metric4 = [Metric4;CV];
        end
        
        

        [A ind]= sort(Metric4,'descend');

        Metric3 = Metric3(ind(1:Numvivos));
        Metric4 = Metric4(ind(1:Numvivos));

        %%Guardar lo mejor de cada generación

        Genmetric3{h} = Metric3;
        Genmetric4{h} = Metric4;
        MCV(h) = Genmetric4{h}(1);
        
        try 
            Cr = diff(MCV);
            if sum(Cr(end-30:end)==0)>29
                break;
            end
        end

        %%fin - Comienzo cruce y mut

        Featsize = Featsize(ind(1:Numvivos));
        Feats = Feats(ind(1:Numvivos),:);


        %Cruce
        for i=1:Numcruces
            for j=i+1:Numcruces
                Sumfeat = Featsize(i)+Featsize(j);
                Numi = round(Featsize(i)*Featsize(i)/Sumfeat);
                Numj = round(Featsize(j)*Featsize(j)/Sumfeat);
                % Featsize = [Featsize;Numi+Numj];
                Indi= find(Feats(i,:));
                Indj= find(Feats(j,:));
                indauxi = randperm(Featsize(i),Numi);
                indauxj = randperm(Featsize(j),Numj);
                Feats(end+1,union(Indi(indauxi),Indj(indauxj)))=1;

                Featsize = [Featsize;length(find(Feats(end,:)))];
            end
        end

        %Mutacion 1 - Se remueve muestra
        Feats=[Feats;Feats(1:Nummutados,:)];
        Featsize=[Featsize;Featsize(1:Nummutados)];
        for i=1:Nummutados
            Indi= find(Feats(i,:));
            nummut = randperm(5,1); %Numero de mutaciones en el vector - 20% del tamaño
            indauxi = randperm(Featsize(i),nummut);
            Feats(end-Nummutados+i,Indi(indauxi))=0;
            Featsize(end-Nummutados+i)=Featsize(end-Nummutados+i)-nummut;
        end

        %Mutacion 2 - Se agrega una muestra
        Feats=[Feats;Feats(1:Nummutados2,:)];
        Featsize=[Featsize;Featsize(1:Nummutados2)];
        for i=1:Nummutados2
            Indi= find(~Feats(i,:)); %Features que no estaban
            nummut = randperm(5,1);
            indauxi = randperm(length(Indi),nummut); %Se busca entre las que no hay
            Feats(end-Nummutados2+i,Indi(indauxi))=1;
            Featsize(end-Nummutados2+i)=Featsize(end-Nummutados2+i)+nummut;
        end
        
        
        perc = h*100/num_generaciones;
        waitbar(perc/100,Bar,sprintf('%d%% completed...',uint8(perc)))
    end
 

    
figure 
plot(MCV)

delete(Bar) 
feat = find(Feats(1,:))


[gadso,recon,mean_clas,std_class] =  LAMDA_unsup(ex_level, 5, dat_norma(:,feat), mad,gad); %ex_level,it_num,entre,dat_norma,connective

[gadso,recon,mean_clas,std_class] =  LAMDA_unsup_ruidoso(ex_level, 5, dat_norma(:,feat), mad,gad,mean(mean_clas)); %ex_level,it_num,entre,dat_norma,connective
   