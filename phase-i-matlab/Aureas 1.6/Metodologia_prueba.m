function [table,datos_clasifi,mean_clas,InfoZC,gadso,repre,Dispersion,frecuencia]=Metodologia_prueba(ruta, banda , mean_class, flag, canal,a,b,feat,mediafrecuencia,stdfrecuencia,indmerged)
%flag es para seleccionar sólo las especies que tuevieron entrenamiento, y
%no permitir la creación de nuevas clases (1 crea clases, 0 no crea clases)

rutain= [ruta '\'];

if strcmp(banda(1,:),'min')&&strcmp(banda(2,:),'max')
    [datos nombre_archivo FS] = SegmentacionPaisaje(rutain,canal);
else
    [datos nombre_archivo FS] = Segmentacion(rutain,banda,canal);
end   
%%%%%%%%%%%%normalización-winsorization%%%%%%%%
try
    %Se desordenan
%     new_index=randperm(size(datos,1));
%     datos=datos(new_index,:);
%     nombre_archivo=nombre_archivo(new_index,:);
    
    datos_carac=datos(:,13:end);
catch
    msgbox('No vocalizations found.')
    table = [];
    Fecha = [];
    recon = [];    
    return;
end

datos_carac=[datos(:,8),datos_carac];

blocal=min(datos_carac);
alocal=max(datos_carac);

aglobal = [a;alocal];
bglobal = [b;blocal];

aglobal = max(aglobal,[],1);
bglobal = min(bglobal,[],1);

datosnorm = ZscoreMV(datos_carac,bglobal,aglobal-bglobal);
a1=find(datosnorm>1);% winsorization
b1=find(datosnorm<0);% winsorization
datosnorm(a1)=1;
datosnorm(b1)=0;
datos_clasifi=datosnorm;
    
InfoZC{1}=aglobal;
InfoZC{2}=bglobal;

for i=1:size(mean_class,1)
    mean_class(i,:) = (mean_class(i,:).*(a(i,:)-b(i,:))+b(i,:)-bglobal)./(aglobal-bglobal);
end

feat=1:size(datos_clasifi,2);
InfoZC{3}=feat;
datos_clasifi=datos_clasifi(:,feat);
[gadso,recon,mean_clas] = mLAMDA_fuzzy_3pi_apract(10,datos_clasifi,mean_class,flag); %it_num,entre,dat_norma,mean_class,new classes (1-yes, 0-no)
%mean_clas=datos_clasifi;
%[gadso,recon,mean_clas] = mLAMDA_fuzzy_3pi_apract_ruidoso(10,datos_clasifi,mean_class,mean(mean_clas),flag); %it_num,entre,dat_norma,mean_class,new classes (1-yes, 0-no)


meandom = [mediafrecuencia(:,1)];
stddom  = [stdfrecuencia(:,1)]; %Se agrega la desviación de la NIC, para que dé 1
datosdom = datos_carac(:,1)'; 

%Prioridad frecuencia
Memberdom = exp(-(repmat(datosdom,[size(meandom,1) 1])-repmat(meandom,[1 size(datosdom,2)])).^2./(2*repmat(stddom,[1 size(datosdom,2)]).^2));

Gadsdom = gadso(2:end,:);
threshold = exp(-(2*stddom).^2./(2*stddom.^2));
Gadsdom(Memberdom<repmat(threshold,[1 size(Memberdom,2)])) = 0;
Gadsdom = [gadso(1,:);Gadsdom];

[Sort I]=sort(Gadsdom,'descend');
recon = I(1,:);


%vector representativo
for i=1:size(mean_clas,1)
    Euc=[];
    for j=1:size(datos_clasifi,1)
        V= mean_clas(i,:)-datos_clasifi(j,:);
        Euc(j)= V*V';
    end
    [dummy repre(i)]=min(Euc);
end

%Rechazo de frecuencia
for i=1:size(mean_clas,1)
    indclass= find(recon==i);
    mediasfrecuencia(i,:) = mean(datos_carac(indclass,:));
    stdsfrecuencia(i,:) = std(datos_carac(indclass,:));
end       
frecuencia{1} = mediasfrecuencia;
frecuencia{2} = stdsfrecuencia;

%mean_clas fila del número de clase principal
%Crear tabla.
acc=1;
aux_gadso(1,:) = gadso(1,:);
aux_mean_clas(1,:) = mean_clas(1,:);
for i=1:length(indmerged)
    recon(find(indmerged(i)+acc>=recon & recon>acc))=i+1;
    aux_gadso(i+1,:) = max(gadso(acc+1:indmerged(i)+acc,:),[],1);
    aux_mean_clas(i+1,:) = mean(mean_clas(acc+1:indmerged(i)+acc,:),1);
    acc = indmerged(i)+acc;
end
gadso =  aux_gadso;
mean_clas = aux_mean_clas;

salida=[datos(:,1:10), (datos(:,11:12).*(FS/2))]; %datos de tabla
tarr=[salida recon'];
dat=num2cell(tarr);
names=cellstr(nombre_archivo);
table=[names dat];
Fecha=datos(:,1:4);




%Rutina dispersión
for i=1:max(recon)
    Dispersion(i) = sum(std(datos_clasifi(find(recon==i),:)));
end

Dispersion = (Dispersion - min(Dispersion))/(max(Dispersion)-min(Dispersion));




