function [datos nombre_archivo FS] = Segmentacion(rutain,banda,canal)

Dir=[dir([rutain '*.mp3']);dir([rutain '*.wav'])];


por=1;
cont=0;
Seg={}; %Acumulador de segmentos

Bar = waitbar(0,'Initializing waitbar...','Name','Segmentation and processing');
waitbar(0,Bar,sprintf('%d%% completed...',0));

    for i=1:length(Dir) %subcarpeta
        %Dir(i).name
        [y,FS] = audioread([rutain Dir(i).name]);        %Cargar señal  
        
        
        fileID = fopen('Settings/Format.txt');
        if fileID < 0 
            format = {'RECORDER_yyyymmdd_HHMMSS','_'};
        else
            C = textscan(fileID,'%s');
            fclose(fileID);
            format = C{1,1};
        end
        
        Split = strsplit(Dir(i).name,format{2});
        Splitformat = strsplit(format{1},format{2});
        
        if length(Split)==length(Splitformat)
            indname = strfind(format{1},'RECORDER');
            
            indsep = strfind(format{1},format{2});
            indsmes = strfind(format{1},'mm');
            indsdia = strfind(format{1},'dd');
            indshora = strfind(format{1},'HH');
            indsmin = strfind(format{1},'MM');
            
            if ~isempty(indsmes)
                indsmes = find(indsmes>indsep);
                indsmes = indsmes(end)+1;
                
                indmes = strfind(Splitformat{indsmes},'mm');
                Mes=str2num(Split{indsmes}(indmes:indmes+1));
            else
                Mes=0;
            end
            
            if ~isempty(indsdia)
                indsdia = find(indsdia>indsep);
                indsdia = indsdia(end)+1;
                
                inddia = strfind(Splitformat{indsdia},'dd');
                Dia=str2num(Split{indsdia}(inddia:inddia+1));
            else
                Dia=0;
            end
            
            if ~isempty(indshora)
                indshora = find(indshora>indsep);
                indshora = indshora(end)+1;
                
                indHOR = strfind(Splitformat{indshora},'HH');
                Hora=str2num(Split{indshora}(indHOR:indHOR+1));
            else
                Hora=0;
            end
            
            if ~isempty(indsmin)
                indsmin = find(indsmin>indsep);
                indsmin = indsmin(end)+1;
                
                indMIN = strfind(Splitformat{indsmin},'MM');
                Min=str2num(Split{indsmin}(indMIN:indMIN+1));
            else
                Min=0;
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


            wspec=1024+256; %tamaño de la ventana, nombre, voc corta o larga, tiempo de computo
            ovp=960; % overlap

            [s,f,t] =spectrogram(y(:,canal),flattopwin(wspec),ovp,2*1024,FS); %256,128,256

            s = abs(s);
            [u,v]=size(s);
            resiz=length(y(:,canal))/length(s);


            bands_1=banda.*1/(FS/2); %Banda de frecuencias normalizadas
            [p,q]=size(bands_1);
            band_1=bands_1(:,1);
            band_2=bands_1(:,2);


            for j=1:p
                
                %y=zeros(u,v);
                mfband = s(round(band_1(j)*u):round(band_2(j)*u),:);
                
                if size(mfband,1)<30
                    msgbox('Frequency range too small. Minimum: 650 Hz')
                    return
                end
                
                mfband = medfilt2(mfband, [5 5]);
                selband=mfband;
                %%%%Nuevo segmentador


                mfband = mfband - repmat(mean(mfband,2),[1 size(mfband,2)]);

    %             mfband = s(round(band_1(j)*u):round(band_2(j)*u),:);

                D=std(mfband,[],2);
                D=smooth(D,10);
                D=smooth(D,10);
                Y=-D+max(D);
                [peaksY locsY]=findpeaks(Y);
                [peaksD locsD]= findpeaks(D);

                %Se eliminan picos muy pequeños
                indx = [];
                for x=1:length(peaksY)
                    indloc = find(locsD<locsY(x));

                    if isempty(indloc)
                        firstpeak = max(D);
                    else
                        firstpeak = peaksD(indloc(end));
                    end

                    indloc = find(locsD>locsY(x));
                    if isempty(indloc)
                        secondpeak = max(D);
                    else
                        secondpeak = peaksD(indloc(1));
                    end

                    if firstpeak<secondpeak
                        if D(locsY(x))-min(D)>0.6*(firstpeak-min(D))
                            indx = [indx x];
                        end
                    else
                        if D(locsY(x))-min(D)>0.6*(secondpeak-min(D))
                            indx = [indx x];
                        end
                    end
                end

                peaksY(indx)=[];
                %Se eliminan los picos muy pequeños, no discriminativos

                if isempty(peaksY)
                    puntos=D>mean(D);
                    dpuntos=diff(puntos);
                else
                    thres=[];
                    peaksY(peaksY>mean(peaksY))=[];
                    peaksY = sort(peaksY);
                    num_peaks=length(peaksY);
                    for r=1:num_peaks
                       thres(r,:) = Y<peaksY(r);
                    end

                    for r=2:size(thres,1)
                        %thres(r-1,:)
                        dthres = diff(thres(r,:));

                        bandthres=find(abs(dthres));

                        if dthres(bandthres(1))==-1 %Si la primera derivada es -1, agregue el cero al indice
                          bandthres = [1 bandthres];
                        end

                        if dthres(bandthres(end))==1 %Si la ultima derivada es 1, agregue el último numero de la banda
                          bandthres = [bandthres length(D)];
                        end

                        for g=1:size(bandthres,2)/2
                            if sum(thres(r,bandthres(2*g-1):bandthres(2*g))&thres(r-1,bandthres(2*g-1):bandthres(2*g)))>0 %Hay puntos de la banda superior
                                thres(r,bandthres(2*g-1):bandthres(2*g))= thres(r-1,bandthres(2*g-1):bandthres(2*g)); %Prima la banda superior
                            end
                        end
                    end

                    %[peaksY,idx,outliers] = deleteoutliers(peaksY, 0.05); 
    %                 threshold=min(peaksY);
                    puntos=thres(end,:)';
                    dpuntos=diff(puntos);
                end


                indband=find(abs(dpuntos));

                if dpuntos(indband(1))==-1 %Si la primera derivada es -1, agregue el cero al indice
                  indband = [1;indband];
                end

                if dpuntos(indband(end))==1 %Si la ultima derivada es 1, agregue el último numero de la banda
                  indband = [indband;length(D)];
                end

                %%%Se eliminan las bandas de un solo punto de ancho
                ind=[]; 
                for h=1:size(indband,1)/2
                    if indband(2*h-1)==indband(2*h)
                        ind=[ind;2*h-1];
                        ind=[ind;2*h];
                    end
                end
                indband(ind)=[];
                


                for g=1:size(indband,1)/2
                        if indband(2*g)-indband(2*g-1)<30 && length(indband)<=2
                            indband(1)=1;
                            indband(2)=size(mfband,1);
                        end
                    
                        fband = mfband(indband(2*g-1):indband(2*g),:); 

                        D=sum(fband);
                        D=smooth(D,80);
                        D=smooth(D,80);
                        Y=-D+max(D);
                        peaksY=findpeaks(Y);
                        peaksD = findpeaks(D);
                        if isempty(peaksY)
                            puntos=D>mean(D);
                            dpuntos=diff(puntos);
                        else
                            thres=[];
                            peaksY(peaksY>mean(peaksY))=[];
                            %peaksY(peaksY>prctile(Y,50))=[];
                            peaksY = sort(peaksY);
                            num_peaks=5;
                            if length(peaksY)<num_peaks
                                num_peaks=length(peaksY);
                            end

                            for r=1:num_peaks
                               thres(r,:) = Y<peaksY(r);
                            end

                            for r=2:size(thres,1)
                                %thres(r-1,:)
                                dthres = diff(thres(r,:));

                                bandthres=find(abs(dthres));

                                if dthres(bandthres(1))==-1 %Si la primera derivada es -1, agregue el cero al indice
                                  bandthres = [1 bandthres];
                                end

                                if dthres(bandthres(end))==1 %Si la ultima derivada es 1, agregue el último numero de la banda
                                  bandthres = [bandthres length(D)];
                                end

                                for x=1:size(bandthres,2)/2
                                    if sum(thres(r,bandthres(2*x-1):bandthres(2*x))&thres(r-1,bandthres(2*x-1):bandthres(2*x)))>0 %Hay puntos de la banda superior
                                        thres(r,bandthres(2*x-1):bandthres(2*x))= thres(r-1,bandthres(2*x-1):bandthres(2*x)); %Prima la banda superior
                                    end
                                end
                            end

                            %[peaksY,idx,outliers] = deleteoutliers(peaksY, 0.05); 
            %                 threshold=min(peaksY);
                            puntos=thres(end,:)';
                            dpuntos=diff(puntos);
                        end

                        vindband=find(abs(dpuntos));

                        if dpuntos(vindband(1))==-1 %Si la primera derivada es -1, agregue el cero al indice
                          vindband = [1;vindband];
                        end

                        if dpuntos(vindband(end))==1 %Si la ultima derivada es 1, agregue el último numero de la banda
                          vindband = [vindband;length(D)];
                        end

                        %%%Se eliminan las bandas de un solo punto de ancho
                        ind=[]; 
                        for h=1:size(vindband,1)/2
                            if vindband(2*h-1)==vindband(2*h)
                                ind=[ind;2*h-1];
                                ind=[ind;2*h];
                            end
                        end
                        vindband(ind)=[];


    %                       try
    %                             ranas{1,i}=segmentador(fband, FS); %segmentar la banda
    %                       end
                         for w=1:size(vindband,1)/2
    %                      for kk=1:length(ranas{1,i})
                            try
    %                             pini=ranas{1,i}(kk,1); %-20
    %                             pend=ranas{1,i}(kk,end); %+20
                                pini=round(vindband(2*w-1));
                                pend=round(vindband(2*w));
                                mini=round(band_1(j)*u)+indband(2*g-1);
                                maxi=round(band_1(j)*u)+indband(2*g);

    %                             seg=fband(:,pini:pend);

                                seg = selband(indband(2*g-1):indband(2*g),pini:pend);


                                nfrec = 10;
                                div= 10;
                                nfiltros=30;

                                %seg=((seg-repmat(min(seg(:)),size(seg)))./(repmat(max(seg(:)),size(seg))-repmat(min(seg(:)),size(seg))));                           

                                features=fcc5(seg,nfiltros,nfrec,div); %50 caracteristicas FCCs


                                seg=((seg-repmat(min(seg(:)),size(seg)))./(repmat(max(seg(:)),size(seg))-repmat(min(seg(:)),size(seg))));                           

                                background = imopen(seg,strel('disk',15));
                                [indx,indy] =find((background>graythresh(background)));
                                relacionpow = max(seg(:).^2)/mean(seg(:).^2);

                                B = 255*seg>graythresh(255*seg);
                                B(indx,indy) = 1;
                                Area =   sum(sum(B));
                                ge = regionprops(B,'Area','Orientation','MajorAxisLength','MinorAxisLength');
                                ge = cell2mat(struct2cell(ge));
                                [dummy indmax] = max(ge(1,:));

                                Geom = [ge(2:end,indmax)];

                                mini = (round(band_1(j)*u)+indband(2*g-1)+min(indx))/u;
                                maxi = (round(band_1(j)*u)+indband(2*g-1)+max(indx))/u;
    %                             [dummy dom] = max(max(seg,[],2));
    %                             dom=(round(band_1(j)*u)+indband(2*g-1)+dom)/u;

                                [Peaks I]= findpeaks(smooth(smooth(smooth(sum(seg,2)))));

                                if isempty(Peaks) 
                                    dom = 0;
                                else
                                    [dummy ind] = max(Peaks);
                                    dom = I(ind);
                                    dom=(round(band_1(j)*u)+indband(2*g-1)+dom)/u;
                                end


                                pend = pini + max(indy);
                                pini = pini + min(indy);



                                dfcc = diff(features, 1, 2);
                                dfcc2 = diff(features, 2, 2);

                                cf = cov(features');
                                ff = [];
                                for r=0:(size(features,1)-1)

                                  ff = [ff;diag(cf,r)];

                                end

    %                             strongest = points.selectStrongest(2);
    %                             locs = strongest.Location;
    %                             Metric2 = strongest.Metric;

                                features = [features(:);mean(dfcc,2);mean(dfcc2,2)];

                                if pend>pini && maxi>mini
                                    %datos(por,:)=[Mes;Dia;Hora;Min;pini.*((resiz)/FS);pend.*((resiz)/FS);(pend-pini).*((resiz)/FS);dom.*(FS/2);mini.*(FS/2);maxi.*(FS/2);band_1(j);band_2(j);mean(features,2)];
                                    
                                    datos(por,:)=[Mes;Dia;Hora;Min;pini.*((resiz)/FS);pend.*((resiz)/FS);(pend-pini).*((resiz)/FS);dom.*(FS/2);mini.*(FS/2);maxi.*(FS/2);band_1(j)*FS/44100;band_2(j)*FS/44100;features];

                                    nombre_archivo{por,:}=Dir(i).name; %string con nombre
                                    por=por+1;
                                end
                            end
                        end


                   end 




            end
        else
            msgbox(['This record has no valid format:  ' Dir(i).name])
        end
            cont=cont+1;
            perc = cont*100/length(Dir);
            waitbar(perc/100,Bar,sprintf('%d%% completed...',uint8(perc)))
    
    end
    
    delete(Bar)



