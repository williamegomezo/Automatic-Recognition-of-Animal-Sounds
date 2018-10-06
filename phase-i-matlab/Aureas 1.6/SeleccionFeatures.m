function [feat,gadso,recon,mean_clas,std_class] = SeleccionFeatures(ex_level,it_num,dat_norma,mad,gad)
    Bar = waitbar(0,'Initializing waitbar...','Name','Selecting features');
    waitbar(0,Bar,sprintf('%d%% completed...',0)); 
    tic
    feat = []; %Frecuencia minima y máxima
    MCV = [];
    MICC = [];
    
    GMCV = [];
    GMICC = [];
    
    maxfeat = size(dat_norma,2);
    
    for j=1:maxfeat
        Metric3 = [];
        Metric4 = [];
        
        
        for k=1:size(dat_norma,2)
%             m3=[];
%             m4=[];
%             for i=1:3
%                 new_index=randperm(size(dat_norma,1));
%                 datos=dat_norma(new_index,:);
            if length(find(k==feat))==0
                [gadso,recon,mean_clas,std_class] =  LAMDA_unsup2(ex_level, it_num, dat_norma(:,[feat,k]), mad,gad); %ex_level,it_num,entre,dat_norma,connective
                
                %mean_clas = dat_norma(:,[feat,k]);
                %[gadso,recon,mean_clas,std_class] =  LAMDA_unsup2_ruidoso(ex_level, it_num, dat_norma(:,[feat,k]), mad,gad, mean(mean_clas)); %ex_level,it_num,entre,dat_norma,connective
                
                mean_clas(1,:)=[];
                std_class(1,:)=[];
                
                Icc = ComputeICC(dat_norma,mean_clas,gadso);
                CV  = ComputeCV(mean_clas,gadso);
                
                Metric3 = [Metric3;Icc];
                Metric4 = [Metric4;CV];
            else
                Icc = 0;
                CV  = 0;
                
                Metric3 = [Metric3;Icc];
                Metric4 = [Metric4;CV];
            end
%                 m3=[m3;Icc];
%                 m4=[m4;CV];
%             end
            
%             Metric3 = [Metric3;mean(m3)];
%             Metric4 = [Metric4;mean(m4)];
            
            
            
        end

        [dummy ind] = max(Metric4);
        MCV = [MCV;dummy];
        MICC = [MICC;Metric3(ind)];
        
        GMCV = [GMCV,Metric4];
        GMICC = [GMICC,Metric3];
        
        feat =  [feat,ind];
        
        Cr = smooth(smooth(MCV));
        Cr = diff(Cr);
        try 
            if sum(Cr(end-10:end)<0)>9
                break;
            end
        end
        

        
        perc = j*100/maxfeat;
        waitbar(perc/100,Bar,sprintf('%d%% completed...',uint8(perc)))
 end
    
[DUMMY IND]=max(MCV)
feat = feat(1:IND)

figure
plot(MCV)
toc
delete(Bar) 
[gadso,recon,mean_clas,std_class] =  LAMDA_unsup(ex_level, 5, dat_norma(:,feat), mad,gad); %ex_level,it_num,entre,dat_norma,connective
%mean_clas=dat_norma(:,feat);
%[gadso,recon,mean_clas,std_class] =  LAMDA_unsup_ruidoso(ex_level, 5, dat_norma(:,feat), mad,gad,mean(mean_clas)); %ex_level,it_num,entre,dat_norma,connective
                 