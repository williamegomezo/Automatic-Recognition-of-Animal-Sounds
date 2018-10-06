function [ datos, nombre_archivo ] = VisualizacionSegs( rutain , datos, nombre_archivo, canal,banda)
%VISUALIZACIONSEGS Summary of this function goes here
%   Detailed explanation goes here
    choice = questdlg('Visualize and add new segments?', ...
        'Segmentation', ...
        'Yes','No','No');
    % Handle response
    switch choice
        case 'Yes'
            Dir=dir([rutain '*.wav']);
            por=1;
            contf=1;
            f = figure(contf);
            wspec=1024; %tamaño de la ventana, nombre, voc corta o larga, tiempo de computo
            ovp=960; % overlap
            
            i=1;
            Name = cell2mat(nombre_archivo(i,:));
            Split = strsplit(Name,'_');
            datosfecha = Split{2};
            datoshora = Split{3};

            Mes=str2num(datosfecha(5:6));
            Dia=str2num(datosfecha(7:8));
            Min=str2num(datoshora(3:4));
            Hora=str2num(datoshora(1:2));
            
            
            f = figure(contf);
            [y FS]=audioread([rutain '\' cell2mat(nombre_archivo(i,:))]);
            y=y(:,canal);
            
            [s1,t,f] = stft(y, round(length(y)/5000), FS, 'hamming',2^12);
            s1=abs(s1);
            s1=20*log10(s1);
            imagesc('XData',t,'YData',f,'CData',s1)
            axis([min(t) max(t) min(f) max(f)])
            title(nombre_archivo(i,:))
            xlabel('Time')
            ylabel('Frecuency')
            rectangle('Position',[datos(i,5) datos(i,9) datos(i,6)-datos(i,5) datos(i,10)-datos(i,9)],'EdgeColor',[0 0 1],'LineWidth',1.5);
          
            wspec=1024+256; %tamaño de la ventana, nombre, voc corta o larga, tiempo de computo
            ovp=960; % overlap
            [s,f,t] =spectrogram(y,flattopwin(wspec),ovp,2048,FS); %256,128,256
            s = abs(s);
            [u,v]=size(s);
            resiz=length(y)/length(s);
            
            for i=2:size(nombre_archivo,1) %subcarpeta      
                if strcmp(Name,nombre_archivo(i,:)) %Si ya se creo la figura, está en el mismo archivo
                    i
                    [datos(i,5) datos(i,9) datos(i,6)-datos(i,5) datos(i,10)-datos(i,9)]
                
                    f = figure(contf);
                    rectangle('Position',[datos(i,5) datos(i,9) datos(i,6)-datos(i,5) datos(i,10)-datos(i,9)],'EdgeColor',[0 0 1],'LineWidth',1.5);
          
                else
                    w=0;
                    while ~w
                        try
                            [x1,y1] = ginput(2);
                            rectangle('Position',[min(x1) min(y1) max(x1)-min(x1) max(y1)-min(y1)],'EdgeColor',[0 0 1],'LineWidth',1.5);

                            seg = s(u*min(y1)/(FS/2):u*max(y1)/(FS/2),v*min(x1)/(length(y)/FS):v*max(x1)/(length(y)/FS));

                            nfrec = 10;
                            div= 10;
                            nfiltros=30;
                            features=fcc5(seg,nfiltros,nfrec,div); %50 caracteristicas FCCs

                            [Peaks I]= findpeaks(smooth(smooth(smooth(sum(seg,2)))));

                            if isempty(Peaks) 
                                dom = 0;
                            else
                                [dummy ind] = max(Peaks);
                                dom = I(ind);
                                dom=(u*min(y1)/(FS/2)+dom)/u;
                            end
                            

                            dfcc = diff(features, 1, 2);
                            dfcc2 = diff(features, 2, 2);
                            

                            features = [features(:);mean(dfcc,2);mean(dfcc2,2)];

                            datos(size(datos,1)+por,:)=[Mes;Dia;Hora;Min;min(x1);max(x1);max(x1)-min(x1);dom;min(y1);max(y1);banda(1)/(FS/2);banda(2)/(FS/2);features];
                            nombre_archivo(size(nombre_archivo,1)+por,:) = nombre_archivo(i,:);
                            por=por+1;
                        end
                        try
                            w = waitforbuttonpress;
                        end
                    end
                    
                    Name=cell2mat(nombre_archivo(i,:));
                    Split = strsplit(Name,'_');
                    datosfecha = Split{2};
                    datoshora = Split{3};

                    Mes=str2num(datosfecha(5:6));
                    Dia=str2num(datosfecha(7:8));
                    Min=str2num(datoshora(3:4));
                    Hora=str2num(datoshora(1:2));
                    
                    contf=contf+1;
                    fi = figure(contf);
                    
                    [y FS]=audioread([rutain '\' cell2mat(nombre_archivo(i,:))]);
                    y=y(:,canal);
                    [s1,t,f] = stft(y, round(length(y)/5000), FS, 'hamming',2^12);
                    s1=abs(s1);
                    s1=20*log10(s1);
                    imagesc('XData',t,'YData',f,'CData',s1)
                    axis([min(t) max(t) min(f) max(f)])
                    title(nombre_archivo(i,:))
                    xlabel('Time')
                    ylabel('Frecuency')
                    rectangle('Position',[datos(i,5) datos(i,9) datos(i,6)-datos(i,5) datos(i,10)-datos(i,9)],'EdgeColor',[0 0 1],'LineWidth',1.5);
          
                    wspec=1024+256; %tamaño de la ventana, nombre, voc corta o larga, tiempo de computo
                    ovp=960; % overlap
                    [s,f,t] =spectrogram(y,flattopwin(wspec),ovp,2048,FS); %256,128,256
                    s = abs(s);
                    [u,v]=size(s);
                    resiz=length(y)/length(s);
                end
            end
        case 'No'
    end

end

