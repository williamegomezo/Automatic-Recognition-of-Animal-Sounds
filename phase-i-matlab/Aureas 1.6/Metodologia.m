function [table datos_clasifi mean_clas InfoZC gadso repre Dispersion frecuencia]=Metodologia(ruta, banda, canal ,autosel,visualize)

rutain= [ruta '\'];


try
    if strcmp(banda(1,:),'min')&&strcmp(banda(2,:),'max')
        [datos nombre_archivo FS] = SegmentacionPaisaje(rutain,canal);
    else
        [datos nombre_archivo FS] = Segmentacion(rutain,banda,canal);
    end

    if visualize == 1
        [datos,nombre_archivo] = VisualizacionSegs( rutain , datos, nombre_archivo,canal,banda);
    end
        
    %Los MFCC's
    datos_carac=datos(:,13:end);
    datos_carac=[datos(:,8),datos_carac];
catch
    msgbox('No vocalizations found.')
    table = [];
    mean_clas = [];    
    return;
end



%datos_carac=[repmat(datos(:,8),[1 5]),datos_carac];
%Selección de caracteristicas

%RUTINA - Zscore MOVIL

b=min(datos_carac);
a=max(datos_carac);
datos_clasifi = ZscoreMV(datos_carac,b,a-b);
InfoZC{1}=[a];
InfoZC{2}=[b];


%%%%%%%% Clasificación %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if autosel == 0
    feat=1:size(datos_clasifi,2);
    InfoZC{3}=feat;
    datos_clasifi=datos_clasifi(:,feat);
    [gadso,recon,mean_clas,std_class] = LAMDA_unsup(1, 10, datos_clasifi, 'binomial','3pi'); %ex_level,it_num,entre,dat_norma,connective
    mean_clas(1,:)=[];
    std_class(1,:)=[];
    %Eliminar clases sin datos
    i=1;
    p=1;
    sizeclasses = size(mean_clas,1);
    ind_eli=[];
    while p<= sizeclasses
        if sum(recon==i)==0
            ind_eli=[ind_eli,p];
            recon(find(recon>i))=recon(find(recon>i))-1;
        else 
            i=i+1;
        end
        p=p+1;
    end
    mean_clas(ind_eli,:)=[]; 
    gadso(ind_eli,:)=[];
    
    %vector representativo
    for i=1:size(mean_clas,1)
        ind_class= find(recon==i);
        Euc=[];
        ind=[];
        p=1;
        for j=ind_class
            V= mean_clas(i,:)-datos_clasifi(j,:);
            Euc(p)= V*V';
            p=p+1;
        end
            [dummy indm]=min(Euc);
            repre(i) = ind_class(indm);
    end
    
    %Rechazo de frecuencia
    mediafrecuencia=zeros(size(mean_clas,1),size(datos_carac,2));
    stdfrecuencia=zeros(size(mean_clas,1),size(datos_carac,2));
    for i=1:size(mean_clas,1)
        indclass= find(recon==i);
        mediafrecuencia(i,:) = mean(datos_carac(indclass,:));
        stdfrecuencia(i,:) = std(datos_carac(indclass,:));
    end       
    frecuencia{1} = mediafrecuencia;
    frecuencia{2} = stdfrecuencia;
else    
    %[feat,gadso,recon,mean_clas,~] = AlgortimoGenetico(1, 2, datos_clasifi, 'binomial','3pi'); %ex_level,it_num,entre,dat_norma,connective
    [feat,gadso,recon,mean_clas,std_class] = SeleccionFeatures(1, 2, datos_clasifi, 'binomial','3pi'); %ex_level,it_num,entre,dat_norma,connective
    mean_clas(1,:)=[];
    std_class(1,:)=[];
    
    InfoZC{3}=feat;
    
    %Eliminar clases sin datos
    i=1;
    p=1;
    sizeclasses = size(mean_clas,1);
    ind_eli=[];
    while p<= sizeclasses
        if sum(recon==i)==0
            ind_eli=[ind_eli,p];
            recon(find(recon>i))=recon(find(recon>i))-1;
        else 
            i=i+1;
        end
        p=p+1;
    end
    mean_clas(ind_eli,:)=[]; 
    gadso(ind_eli,:)=[];
    
    %vector representativo
    for i=1:size(mean_clas,1)
        ind_class= find(recon==i);
        Euc=[];
        ind=[];
        p=1;
        for j=ind_class
            V= mean_clas(i,:)-datos_clasifi(j,feat);
            Euc(p)= V*V';
            p=p+1;
        end
            [dummy indm]=min(Euc);
            repre(i) = ind_class(indm);
    end
    
    %Rechazo de frecuencia
    mediafrecuencia=zeros(size(mean_clas,1),size(datos_carac,2));
    stdfrecuencia=zeros(size(mean_clas,1),size(datos_carac,2));
    for i=1:size(mean_clas,1)
        indclass= find(recon==i);
        mediafrecuencia(i,:) = mean(datos_carac(indclass,:));
        stdfrecuencia(i,:) = std(datos_carac(indclass,:));
    end       
    frecuencia{1} = mediafrecuencia;
    frecuencia{2} = stdfrecuencia;
end


salida=[datos(:,1:10), (datos(:,11:12).*(FS/2))]; %datos de tabla
tarr=[salida recon'];
dat=num2cell(tarr);
names=cellstr(nombre_archivo);
table=[names dat];

%Rutina dispersión
for i=1:max(recon)
    Dispersion(i) = sum(std(datos_clasifi(find(recon==i),:)));
end

% Dispersion = (Dispersion - min(Dispersion))/(max(Dispersion)-min(Dispersion));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

