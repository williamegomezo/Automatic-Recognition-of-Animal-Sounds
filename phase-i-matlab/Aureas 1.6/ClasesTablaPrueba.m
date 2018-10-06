function varargout = ClasesTablaPrueba(varargin)
% CLASESTABLAPRUEBA MATLAB code for ClasesTablaPrueba.fig
%      CLASESTABLAPRUEBA, by itself, creates a new CLASESTABLAPRUEBA or raises the existing
%      singleton*.
%
%      H = CLASESTABLAPRUEBA returns the handle to a new CLASESTABLAPRUEBA or the handle to
%      the existing singleton*.
%
%      CLASESTABLAPRUEBA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLASESTABLAPRUEBA.M with the given input arguments.
%
%      CLASESTABLAPRUEBA('Property','Value',...) creates a new CLASESTABLAPRUEBA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ClasesTablaPrueba_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ClasesTablaPrueba_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ClasesTablaPrueba

% Last Modified by GUIDE v2.5 15-Dec-2016 10:12:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ClasesTablaPrueba_OpeningFcn, ...
                   'gui_OutputFcn',  @ClasesTablaPrueba_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ClasesTablaPrueba is made visible.
function ClasesTablaPrueba_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ClasesTablaPrueba (see VARARGIN)

% Choose default command line output for ClasesTablaPrueba
handles.output = hObject;

if length(varargin) == 12
    handles.table = varargin{1};
    handles.datos_clasifi= varargin{2};
    handles.mean_class = varargin{3};
    handles.ruta = varargin{4};
    handles.ch = varargin{5};
    handles.InfoZC = varargin{6};
    handles.gadso = varargin{7};
    handles.repre = varargin{8};
    handles.Dispersion = varargin{9};
    handles.Species = varargin{10};
    flag = varargin{11};
    handles.frecuencia = varargin{12};
    
    %Número de filas
    rows=size(handles.table,1);
    %Columna de selección
    chooseColumn = num2cell(false(rows,1));
    %Datos de la tabla
    tabla = handles.table;
    [tabla ix]= sortcell(tabla,1);
    for u=1:length(handles.repre)
        handles.repre(u) = find(handles.repre(u)==ix);
    end
    
    handles.datos_clasifi = handles.datos_clasifi(ix,:);
    
    
    data =[chooseColumn,tabla];
    %Crear variable de edición de columna, verdadera solo para la primera.
    editColumn=false(1,size(data,2));
    editColumn(1)=true;
    
    % Colocarle color a las clases
    colors = distinguishable_colors(max(cell2mat(data(:,end))));
    
    colergen = @(color,text) ['<html><table color="white" width=400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];

    auxtable=data;
    
    if size(handles.Species,1)+1==size(handles.mean_class,1) && size(handles.Species,1)~=0 && flag==0
        handles.Species = ['NIC';handles.Species];
    end
    
    for k=1:max(cell2mat(data(:,end)))
        ind=find(k==cell2mat(data(:,end)));
        if k<=size(handles.Species,1)            
            auxtable(ind,end) = cellstr(colergen(rgb2hex(colors(k,:)),cell2mat(handles.Species(k,:))));
        else
            auxtable(ind,end) = cellstr(colergen(rgb2hex(colors(k,:)),num2str(k)));
        end
    end
    
    if size(handles.Species,1)<max(cell2mat(data(:,end)))
        handles.Species = [handles.Species;cellstr(num2str([size(handles.Species,1)+1:max(cell2mat(data(:,end)))]'))];
    end
  
    set(handles.popspecies,'String',handles.Species);
    set(handles.popspecies,'Value',1);
    
    set(handles.tablaclass,'data',auxtable)
    handles.table=data;
    
   
    names = unique(handles.table(:,2),'rows');
    classes=cell2mat(handles.table(:,end))';
    
    addvector = zeros(size(classes));
    for j=1:size(names,1)
        
        %Se escogen los indices que pertenecen a ese archivo
        idx = strfind(data(:,2),names{j});
        for g=1:size(idx,1)
            if isempty(idx{g})
                ind(g)=0;
            else
                ind(g)=1;
            end
        end
        ind=find(ind);
        %Finaliza
        Selected = cell2mat(data(ind,3:end));
        for k=1:max(classes)   
            %Se seleccionan por clases
            indclass=find(Selected(:,end)==k);
            [Selectedclass,I] = sort(Selected(indclass,5:6));
            indclass = indclass(I(:,1));
            vectorl = zeros(size(Selectedclass,1),1);
            for h=1:size(Selectedclass,1)
                if h==size(Selectedclass,1) && size(Selectedclass,1)>1
                    outvect = deleteoutliers(vectorl(1:end-1));
                    vectorl(h) = mean(outvect);
                elseif h==size(Selectedclass,1)
                    vectorl(h) = 0;
                else
                    vectorl(h) = Selectedclass(h+1,1)-Selectedclass(h,2);
                end
            end
            addvector(ind(indclass)) = vectorl;
        end
    end
    addvector(find(addvector<0))=0;
    handles.addvector=addvector;
end
% Update handles structure
guidata(hObject, handles);

screen_size = get(0, 'ScreenSize');
set(handles.figure1, 'Position', [0 0 screen_size(3) screen_size(4) ] );

% UIWAIT makes ClasesTablaPrueba wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ClasesTablaPrueba_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bextraer.
function bextraer_Callback(hObject, eventdata, handles)
% hObject    handle to bextraer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabDat = get(handles.tablaclass,'Data');
[tabDat ix] = sortcell(tabDat,2);
handles.datos_clasifi = handles.datos_clasifi(ix,:);
[data ix] = sortcell(handles.table,2);
%Índices de vocalizaciones seleccionadas
ind=find(cell2mat(tabDat(:,1))==true);
indsel=cell2mat(tabDat(:,1))==true;
%Obtener frecuencia mínima y máxima
fmin = mean(cell2mat(data(ind,13)));
fmax = mean(cell2mat(data(ind,14)));

count=length(ind);

if count>0
    clase = mode(cell2mat(data(ind,end)));
    indc=cell2mat(data(:,end))==2;
    
    if sum(indc~=indsel)>0
        a=handles.InfoZC{1};
        b=handles.InfoZC{2};
        Datos = handles.datos_clasifi(ind,:);
        Datos= Datos.*(repmat(a,size(Datos,1),1)-repmat(b,size(Datos,1),1))+repmat(b,size(Datos,1),1);

        mediasfrecuencia = handles.frecuencia{1};
        stdsfrecuencia = handles.frecuencia{2};

        mediasfrecuencia(clase,:) = mean(Datos,1);
        stdsfrecuencia(clase,:) = std(Datos,[],1);

        handles.frecuencia{1} = mediasfrecuencia;
        handles.frecuencia{2} = stdsfrecuencia;
        %Verificar que se haya seleccionado al menos una vocalización




        handles.mean_class(clase,:) = mean(handles.datos_clasifi(ind,:));
        %Ejecutar función de medidas_calidad
        %Medidas no validas para no supervisado
    %     [sen,esp,acc,balanacc,clase] = medidas_calidad(cell2mat(data(:,end)),...
    %                                                    cell2mat(data(:,1)));
        %Mostrar resultados en nueva ventana  
        %vector representativo
        ind_class= ind;
        Euc=[];
        ind=[];
        p=1;
        for j=1:length(ind_class)
            V= handles.mean_class(clase,:) - handles.datos_clasifi(ind_class(j),:);
            Euc(p)= V*V';
            p=p+1;
        end
        [dummy indm]=min(Euc);
        Ind = ind_class(indm);
    
        row= Ind; 
    else
        row= handles.repre(clase);
    end
    
    File = cell2mat(tabDat(row,2));
    Start = cell2mat(tabDat(row,7));
    End = cell2mat(tabDat(row,8));
    Ruta = handles.ruta;   
    [y Fs]=audioread([Ruta '\' File]);
    y=y(:,handles.ch);

    [s1,t,f] = stft(y, round(length(y)/5000), Fs, 'hamming',2^12);
    s1=abs(s1);
    s1=20*log10(s1);
    repre = {s1 t f Start-1 End+1 cell2mat(tabDat(row,11))-500 cell2mat(tabDat(row,12))+500 Start cell2mat(data(row,11)) End-Start cell2mat(data(row,12))-cell2mat(data(row,11)) handles.addvector(row)};  
    
    NewClass(fmin,fmax, handles.mean_class,clase,handles.InfoZC,count,repre,handles.frecuencia);
else
    %Lanzar mensaje de error si no se ha seleccionado ninguna
    %vocalización
    msgbox('Select the vocalizations.')
end

% --- Executes on button press in bdesel.
function bdesel_Callback(hObject, eventdata, handles)
% hObject    handle to bdesel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabDat = get(handles.tablaclass,'Data');
tabDat(:,1) = num2cell(false(1,1));
handles.table(:,1) = num2cell(false(1,1));
set(handles.tablaclass,'data',tabDat)
guidata(hObject, handles);

% --- Executes on button press in selectedseg.
function selectedseg_Callback(hObject, eventdata, handles)
% hObject    handle to selectedseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabDat = get(handles.tablaclass,'Data');
tabla = handles.table;

[tabDat ix]= sortcell(tabDat,2); %Organizamos por nombre
tabla=tabla(ix,:);

ind=find(cell2mat(tabDat(:,1))==true);

colors = distinguishable_colors(max(cell2mat(tabla(:,end))));


if length(ind)>0 %Primer segmento
    row=ind(1);
    Name=tabDat(row,2);
    contf=1;
    f = figure(contf);
    
    File = cell2mat(tabDat(row,2));
    Start = cell2mat(tabDat(row,7));
    End = cell2mat(tabDat(row,8));
    Ruta = handles.ruta;
   
    [y Fs]=audioread([Ruta '\' File]);
    y=y(:,handles.ch);

    set(f,'name','Segment of the spectrum','numbertitle','off')
    
    wspec=1024; %tamaño de la ventana, nombre, voc corta o larga, tiempo de computo
    ovp=960; % overlap
    [s1,t,f] = stft(y, round(length(y)/5000), Fs, 'hamming',2^12);
    s1=abs(s1);
    s1=20*log10(s1);
    imagesc('XData',t,'YData',f,'CData',s1)
    axis([min(t) max(t) min(f) max(f)])
    title(File)
    xlabel('Time')
    ylabel('Frecuency')
    rectangle('Position',[Start cell2mat(tabDat(row,11)) End-Start cell2mat(tabDat(row,12))-cell2mat(tabDat(row,11))],'EdgeColor',[1 1 1],'LineWidth',3);
    rectangle('Position',[Start cell2mat(tabDat(row,11)) End-Start cell2mat(tabDat(row,12))-cell2mat(tabDat(row,11))],'EdgeColor',colors(cell2mat(tabla(row,15)),:),'LineWidth',1.5);

    
    for i=2:length(ind)
        row=ind(i);
        if strcmp(tabDat(row,2),Name) %Si ya se creo la figura, está en el mismo archivo
            f = figure(contf);
            Start = cell2mat(tabDat(row,7));
            End = cell2mat(tabDat(row,8));
            rectangle('Position',[Start cell2mat(tabDat(row,11)) End-Start cell2mat(tabDat(row,12))-cell2mat(tabDat(row,11))],'EdgeColor',[1 1 1],'LineWidth',3);
            rectangle('Position',[Start cell2mat(tabDat(row,11)) End-Start cell2mat(tabDat(row,12))-cell2mat(tabDat(row,11))],'EdgeColor',colors(cell2mat(tabla(row,15)),:),'LineWidth',1.5);

        else
            Name=tabDat(row,2);
            contf=contf+1;
            fi = figure(contf);

            File = cell2mat(tabDat(row,2));
            Start = cell2mat(tabDat(row,7));
            End = cell2mat(tabDat(row,8));
            Ruta = handles.ruta;
    %     
            [y Fs]=audioread([Ruta '\' File]);
            y=y(:,handles.ch);

            set(fi,'name','Segment of the spectrum','numbertitle','off')
            
            wspec=1024; %tamaño de la ventana, nombre, voc corta o larga, tiempo de computo
            ovp=960; % overlap
            [s1,t,f] = stft(y, round(length(y)/5000), Fs, 'hamming',2^12);
            s1=abs(s1);
            s1=20*log10(s1);
            imagesc('XData',t,'YData',f,'CData',s1)
            axis([min(t) max(t) min(f) max(f)])
            title(File)
            xlabel('Time')
            ylabel('Frecuency')
            rectangle('Position',[Start cell2mat(tabDat(row,11)) End-Start cell2mat(tabDat(row,12))-cell2mat(tabDat(row,11))],'EdgeColor',[1 1 1],'LineWidth',3);
            rectangle('Position',[Start cell2mat(tabDat(row,11)) End-Start cell2mat(tabDat(row,12))-cell2mat(tabDat(row,11))],'EdgeColor',colors(cell2mat(tabla(row,15)),:),'LineWidth',1.5);

        end
    end
end

% --- Executes on button press in stodo.
function stodo_Callback(hObject, eventdata, handles)
% hObject    handle to stodo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabDat = get(handles.tablaclass,'Data');
tabDat(:,1) = num2cell(true(1,1));
handles.table(:,1) = num2cell(true(1,1));
set(handles.tablaclass,'data',tabDat)
guidata(hObject, handles);

% --- Executes on button press in verfig.
function verfig_Callback(hObject, eventdata, handles)
% hObject    handle to verfig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[data ix]= sortcell(handles.table,2); %Organizamos por nombre
for u=1:length(handles.repre)
    handles.repre(u) = find(handles.repre(u)==ix);
end

fileID = fopen('Settings/Format.txt');
if fileID < 0 
    defaultans = {'RECORDER_yyyymmdd_HHMMSS','_'};
else
    C = textscan(fileID,'%s');
    fclose(fileID);
    defaultans = C{1,1};
end

if strcmp(defaultans{1},'RECORDER')
    nopatterns=1;
else
    nopatterns=0;
end
Analysis(data, handles.mean_class, handles.gadso,handles.repre,handles.ruta,handles.ch,handles.addvector,handles.Dispersion,handles.Species,nopatterns);



% --- Executes on button press in bplay.
function bplay_Callback(hObject, eventdata, handles)
% hObject    handle to bplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.row)
    row= handles.row;
    tabDat = get(handles.tablaclass,'Data');   
    File = cell2mat(tabDat(row,2));
    Start = cell2mat(tabDat(row,7))-1;
    End = cell2mat(tabDat(row,8))+1;
    Ruta = handles.ruta;
    
    
    [y f]=audioread([Ruta '\' File]);
    if Start<0
        Start=0
    end
    if End>length(y)/f
        End=length(y)/f
    end
    
    y=y(Start*f+1:End*f,handles.ch);
    sound(y,f);
    tic;
    tocant=0;
    
    while toc+Start < End
        Start+toc
        if exist('hLine')
            delete(hLine)
        end
        hLine = line([Start+toc Start+toc],[cell2mat(tabDat(row,11))-500 cell2mat(tabDat(row,12))+500]);
        pause(0.00001) 
    end    
    delete(hLine)   
    
else
    msgbox('No audio selected.');
end


% --- Executes on button press in bstop.
function bstop_Callback(hObject, eventdata, handles)
% hObject    handle to bstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear sound

% --- Executes on button press in bspec.
function bspec_Callback(hObject, eventdata, handles)
% hObject    handle to bspec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'row')
    row= handles.row;
    tabDat = get(handles.tablaclass,'Data');   
    File = cell2mat(tabDat(row,2));
    Start = cell2mat(tabDat(row,7));
    End = cell2mat(tabDat(row,8));
    Ruta = handles.ruta;
    
    [y Fs]=audioread([Ruta '\' File]);
    y=y(:,handles.ch);
    
    
    
    f = figure(1)
    set(f,'name','Full spectrum','numbertitle','off')
    
    wspec=1024; %tamaño de la ventana, nombre, voc corta o larga, tiempo de computo
    ovp=960; % overlap
    [s1,t,f] = stft(y, round(length(y)/5000), Fs, 'hamming',2^12);
    s1=abs(s1);
    s1=20*log10(s1);
    imagesc('XData',t,'YData',f,'CData',s1)
    axis([min(t) max(t) min(f) max(f)])
    title(File)
    xlabel('Time')
    ylabel('Frecuency')
else
    msgbox('No audio selected.');
end


% --- Executes on button press in bsspect.
function bsspect_Callback(hObject, eventdata, handles)
% hObject    handle to bsspect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'row')
    row= handles.row;
    tabDat = get(handles.tablaclass,'Data');   
    File = cell2mat(tabDat(row,2));
    Start = cell2mat(tabDat(row,7));
    End = cell2mat(tabDat(row,8));
    Ruta = handles.ruta;
%     
    [y Fs]=audioread([Ruta '\' File]);
    y=y(:,handles.ch);
    
    f = figure(1)
    set(f,'name','Segment of the spectrum','numbertitle','off')
    
    wspec=1024; %tamaño de la ventana, nombre, voc corta o larga, tiempo de computo
    ovp=960; % overlap
    [s1,t,f] = stft(y, round(length(y)/5000), Fs, 'hamming',2^12);
    s1=abs(s1);
    s1=20*log10(s1);
    imagesc('XData',t,'YData',f,'CData',s1)
    axis([min(t) max(t) min(f) max(f)])
    title(File)
    xlabel('Time')
    ylabel('Frecuency')        
    rectangle('Position',[Start cell2mat(tabDat(row,11)) End-Start cell2mat(tabDat(row,12))-cell2mat(tabDat(row,11))],'EdgeColor',[1 1 1])
   
else
    msgbox('No audio selected.');
end

% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if hObject == handles.rfile
    rbutton=1;
elseif hObject == handles.rmonth
    rbutton=2;
elseif hObject == handles.rday
    rbutton=3;
elseif hObject == handles.rhour
    rbutton=4;
elseif hObject == handles.rminute
    rbutton=5;
elseif hObject == handles.rstart
    rbutton=6;
elseif hObject == handles.rend
    rbutton=7;
elseif hObject == handles.rlength
    rbutton=8;
elseif hObject == handles.rdomfreq
    rbutton=9;
elseif hObject == handles.rfminvoc
    rbutton=10;
elseif hObject == handles.rfmaxvoc
    rbutton=11;
elseif hObject == handles.rfmin
    rbutton=12;
elseif hObject == handles.rfmax
    rbutton=13;
elseif hObject == handles.rclass
    rbutton=14;
end   

tabla = handles.table; %Guardada
[tabla ix]= sortcell(tabla,rbutton+1);
handles.table=tabla;
handles.datos_clasifi = handles.datos_clasifi(ix,:);
for u=1:length(handles.repre)
    handles.repre(u) = find(handles.repre(u)==ix);
end

data = get(handles.tablaclass,'Data');
data = data(ix,:);
set(handles.tablaclass,'data',data)

guidata(hObject, handles);


% --- Executes when selected cell(s) is changed in tablaclass.
function tablaclass_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tablaclass (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(eventdata.Indices)
    if isfield(handles,'previousrec')
        set(handles.previousrec,'Visible','off')
    end
    index = eventdata.Indices;
    handles.row = index(1);    
    guidata(hObject, handles);
    
    row= handles.row;
    tabDat = get(handles.tablaclass,'Data');   
    File = cell2mat(tabDat(row,2));
    Start = cell2mat(tabDat(row,7));
    End = cell2mat(tabDat(row,8));
    Ruta = handles.ruta;
%     
    h=get(gca,'Title');
    t=get(h,'String')
    
    if ~strcmp(t,File)
        [y Fs]=audioread([Ruta '\' File]);
        y=y(:,handles.ch);

        set(handles.axes1,'Visible','On')
        axes(handles.axes1)

        wspec=1024; %tamaño de la ventana, nombre, voc corta o larga, tiempo de computo
        ovp=960; % overlap
        [s1,t,f] = stft(y, round(length(y)/5000), Fs, 'hamming',2^12);
        s1=abs(s1);
        s1=20*log10(s1);
        imagesc('XData',t,'YData',f,'CData',s1)
    end
    axis([Start-1 End+1 cell2mat(tabDat(row,11))-500 cell2mat(tabDat(row,12))+500])
    rec=rectangle('Position',[Start tabDat{row,11}-500 End-Start tabDat{row,12}-tabDat{row,11}+1000],'EdgeColor',[0 0 0],'LineWidth',2,'LineStyle',':')
    title(File)
    xlabel('Time')
    ylabel('Frecuency') 
    handles.previousrec=rec;
end
guidata(hObject, handles);

% --- Executes on selection change in popspecies.
function popspecies_Callback(hObject, eventdata, handles)
% hObject    handle to popspecies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popspecies contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popspecies
tabDat = get(handles.tablaclass,'Data');
table = cell2mat(handles.table(:,15));
clase = get(handles.popspecies,'Value');

if length(find(clase==table))>0
    ind = find(clase==table);
    tabDat(ind,1) = num2cell(true(1,1));;
    set(handles.tablaclass,'data',tabDat)
else
    msgbox('This class has no segments.');
end

% --- Executes during object creation, after setting all properties.
function popspecies_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popspecies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    row= handles.row;
    tabDat = get(handles.tablaclass,'Data');   
    File = cell2mat(tabDat(row,2));
    
    Start = cell2mat(tabDat(row,7));
    End = cell2mat(tabDat(row,8));
    Ruta = handles.ruta;
    
    
    [y Fs]=audioread([Ruta '\' File]);
    if Start<0
        Start=0
    end
    if End>length(y)/Fs
        End=length(y)/Fs
    end
    
        y=y(round(Start*Fs)+1:round(End*Fs),handles.ch);

        wspec=512; %tamaño de la ventana, nombre, voc corta o larga, tiempo de computo
        ovp=500; % overlap
        
        [s1,f,t] =spectrogram(y,wspec,ovp,8*1024,Fs); %256,128,256
        figure
        s1=abs(s1);
        imagesc('XData',t,'YData',f,'CData',s1)
        axis([-inf inf cell2mat(tabDat(row,11)) cell2mat(tabDat(row,12))])
        X = get(gca, 'XTick');
        set(gca, 'XTick', X , 'XTickLabel' , num2str(linspace(Start,End,length(X))',4))
