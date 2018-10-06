function varargout = Aureas(varargin)
% AUREAS MATLAB code for Aureas.fig
%      AUREAS, by itself, creates a new AUREAS or raises the existing
%      singleton*.
%
%      H = AUREAS returns the handle to a new AUREAS or the handle to
%      the existing singleton*.
%
%      AUREAS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUREAS.M with the given input arguments.
%
%      AUREAS('Property','Value',...) creates a new AUREAS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Aureas_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Aureas_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Aureas

% Last Modified by GUIDE v2.5 28-Dec-2016 06:22:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Aureas_OpeningFcn, ...
                   'gui_OutputFcn',  @Aureas_OutputFcn, ...
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


% --- Executes just before Aureas is made visible.
function Aureas_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Aureas (see VARARGIN)

% Choose default command line output for Aureas
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
if length(varargin) == 1
    set(handles.lspecies,'value',1);
    set(handles.lspecies,'string',varargin{1});
else
    set(handles.lspecies,'string','');
end
mkdir([pwd '\Resultados']);
set(handles.dirsave,'String',[pwd '\Resultados']);
    
% UIWAIT makes Aureas wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Aureas_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function dirsearch_Callback(hObject, eventdata, handles)
% hObject    handle to dirsearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dirsearch as text
%        str2double(get(hObject,'String')) returns contents of dirsearch as a double


% --- Executes during object creation, after setting all properties.
function dirsearch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dirsearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dirsave_Callback(hObject, eventdata, handles)
% hObject    handle to dirsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dirsave as text
%        str2double(get(hObject,'String')) returns contents of dirsave as a double


% --- Executes during object creation, after setting all properties.
function dirsave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dirsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bdirsearch.
function bdirsearch_Callback(hObject, eventdata, handles)
% hObject    handle to bdirsearch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    if length(get(handles.dirsearch,'String'))>0
        name=uigetdir(get(handles.dirsearch,'String'));
    else
        name=uigetdir('');
    end

    if name ~= 0
        set(handles.dirsearch,'String',name);
    end

    Dir=[dir([name '\*.mp3']);dir([name '\*.wav'])];
    if length(Dir) == 0
        set(handles.popfiles,'String',' ')
    else
        set(handles.popfiles,'String',strvcat(Dir.name))
    end

    Year = [];
    Month = [];
    Day = [];
    Hour = [];

    for i=1:length(Dir)
        Split = strsplit(Dir(i).name,'_');
        if length(Split)>2
        Datehora = Split{3};
        Datedate = Split{2};
        Year =  [Year;  str2num(Datedate(1:4))];
        Month = [Month; str2num(Datedate(5:6))];
        Day =   [Day;   str2num(Datedate(7:8))];
        Hour =   [Hour;   str2num(Datehora(1:2))];
        end
    end

    Day = unique(sort(Day));
    Month = unique(sort(Month));
    Year = unique(sort(Year));
    Hour = unique(sort(Hour));

    month1 = datestr([2009,min(Month),2,11,7,18]);
    month2 = datestr([2009,max(Month),2,11,7,18]);
    set(handles.tnfiles,'String',num2str(length(Dir)));
    set(handles.tyears,'String',[num2str(min(Year)) '-' num2str(max(Year))]);
    set(handles.tmonths,'String',[num2str(month1(4:6)) '-' num2str(month2(4:6))]);
    set(handles.tdays,'String',[num2str(min(Day)) '-' num2str(max(Day))]);
    set(handles.thours,'String',[num2str(min(Hour)) '-' num2str(max(Hour))]);



% --- Executes on button press in bdirsave.
function bdirsave_Callback(hObject, eventdata, handles)
% hObject    handle to bdirsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    if length(get(handles.dirsave,'String'))>0
        name=uigetdir(get(handles.dirsave,'String'));
    else
        name=uigetdir('');
    end

    if name ~= 0
        set(handles.dirsave,'String',name);
    end

% --- Executes on selection change in lspecies.
function lspecies_Callback(hObject, eventdata, handles)
% hObject    handle to lspecies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lspecies contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lspecies


% --- Executes during object creation, after setting all properties.
function lspecies_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lspecies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bchoosesp.
function bchoosesp_Callback(hObject, eventdata, handles)
% hObject    handle to bchoosesp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.lspecies,'string'))
    Species
else
    Species('A',get(handles.lspecies,'string'))
end

% --- Executes on selection change in popchannels.
function popchannels_Callback(hObject, eventdata, handles)
% hObject    handle to popchannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popchannels contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popchannels


% --- Executes during object creation, after setting all properties.
function popchannels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popchannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popfiles.
function popfiles_Callback(hObject, eventdata, handles)
% hObject    handle to popfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popfiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popfiles


% --- Executes during object creation, after setting all properties.
function popfiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bspectro.
function bspectro_Callback(hObject, eventdata, handles)
% hObject    handle to bspectro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    contents = get(handles.popfiles,'String');
    value = [get(handles.dirsearch,'String') '\' contents(get(handles.popfiles,'Value'),:)];
    [y,Fs] = audioread(value);
    info = audioinfo(value);
    channel = get(handles.popchannels,'Value');
    if size(y,2)<channel
        %Error, sólo un canal
        msgbox('This recording only has one channel');
        
    else
        y=y(:,channel);
        fi = figure(1);
        set(fi,'name','Full spectrum','numbertitle','off')
        
        wspec=1024; %tamaño de la ventana, nombre, voc corta o larga, tiempo de computo
        ovp=960; % overlap
            
        set(fi,'name','Segment of the spectrum','numbertitle','off')
        [s1,t,f] = stft(y, wspec, Fs, 'hamming',2^12);
        s1=abs(s1);
        s1=20*log10(s1);
        imagesc('XData',t,'YData',f,'CData',s1)
        axis([min(t) max(t) min(f) max(f)])
    end

% --- Executes on button press in bsearchsp.
function bsearchsp_Callback(hObject, eventdata, handles)
% hObject    handle to bsearchsp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
speciesStr=get(handles.lspecies, 'String');
checkedOnlySpec=get(handles.cselectedsp, 'Value');
titles = {'File', 'Month', 'Day', 'Hour', 'Minute','Start' , 'End','Length','Fdom','FminVoc', 'FmaxVoc','Fmin', 'Fmax', 'Class'};
channel = get(handles.popchannels,'Value');
curDirIn=[dir([get(handles.dirsearch,'String') '\*.mp3']);dir([get(handles.dirsearch,'String') '\*.wav'])];
ruta=get(handles.dirsearch,'String');
dirOut=get(handles.dirsave,'String');
if length(curDirIn)==0
    msgbox('Invalid folder');
elseif isempty(speciesStr)
        
        if checkedOnlySpec
            %Si no hay especies seleccionadas y la casilla de restringir
            %especies está activada, sacar error.
                msgbox('No species were selected.');
        else
            %Si no hay especies seleccionadas y la casilla no está
            %activada, se puede ejecutar el programa buscando especies
            %desconocidas. 
            try
                [table,Fecha,recon,~] = paisaje_acustico(ruta, channel);
            catch
                pBar.cancel;
                errormsg('Unknown error');
            end
            
            if ~isempty(table)
            end
        end
            
else
    %Si hay especies seleccionadas, obtenerlas
    specs=speciesHandle.getSpecies();
    %Encontrar las especies seleccionadas en la tabla general
    indnormal=[];
    indmerged=[];
    spec2SchInd=[];
    for i=1:size(speciesStr,1)
        for g=1:size(specs(:,1),1)
            if strcmp(speciesStr{i},specs{g,1})
                if length(specs{g,1})>=7
                    if strcmp('Merged_',specs{g,1}(1:7))
                        indmerged=[indmerged;g];
                    else
                        indnormal=[indnormal;g];
                    end
                else
                    indnormal=[indnormal;g];
                end
                spec2SchInd = [spec2SchInd;g];
            end
        end
    end
    
    %Obtener frecuencias para búsqueda (sujeto a verificación)
    banda=cell2mat(specs(indnormal,2:3));
    
    for j=1:length(indmerged)
        banda = [banda;[cell2mat(specs{indmerged(j),2}) cell2mat(specs{indmerged(j),3})]];
    end
    %Unicas bandas
    auxbanda = unique(banda,'rows');
    
    banda=[];
    banda(1,1) = min(auxbanda(:,1),[],1);
    banda(1,2) = max(auxbanda(:,2),[],1);
    
    
    %Obtiene las medias
    
    try
        mean_class=[];
        mediafrecuencia=[];
        stdfrecuencia=[];

        indmezclas = [];
        for k=1:length(spec2SchInd)
            if ismember(spec2SchInd(k),indmerged)
                params = specs{spec2SchInd(k),end};
                for i=1:size(params,1)
                    mean_class = [mean_class;params{i}(1,:)];
                    mediafrecuencia = [mediafrecuencia;params{i}(2,:)];
                    stdfrecuencia = [stdfrecuencia;params{i}(3,:)];
                end
                indmezclas = [indmezclas size(specs{spec2SchInd(k),2},1)];
            else
                params = cell2mat(specs(spec2SchInd(k),end));
                mean_class = [mean_class;params(1,:)];
                mediafrecuencia = [mediafrecuencia;params(2,:)];
                stdfrecuencia = [stdfrecuencia;params(3,:)];
                indmezclas = [indmezclas 1];
            end
            
            
        end
    catch
        msgbox('These species were trained in different times!');
    end
    
    
    feat = cell2mat(specs(indnormal,4));
    
    for j=1:length(indmerged)
        feat = [feat;cell2mat(specs{indmerged(j),4})];
    end
    feat = unique(feat,'rows');
    
    a = cell2mat(specs(indnormal,5));
    for j=1:length(indmerged)
        a = [a;cell2mat(specs{indmerged(j),5})];
    end
    
    b = cell2mat(specs(indnormal,6));
    for j=1:length(indmerged)
        b = [b;cell2mat(specs{indmerged(j),6})];
    end
    
    
    if  size(feat,1)>1
        msgbox('These species were trained in different times!');
        return;
    end
    
    
%     try
    [table,datos_clasifi,mean_class,InfoZC,gadso,repre,Dispersion,std_class]=Metodologia_prueba(ruta, banda, mean_class, ~checkedOnlySpec, channel,a,b,feat,mediafrecuencia,stdfrecuencia,indmezclas);
        %[table,Fecha,recon,mean_class] = paisaje_acustico(ruta, channel);
%     catch
%         msgbox('Unknown error');
%         return;
%     end
    if ~isempty(table)
        try
            savetable = [table num2cell(max(gadso)')];
            [savetable ix]= sortcell(savetable,1);
            titles = {'File', 'Month', 'Day', 'Hour', 'Minute','Start' , 'End','Length','Fdom','FminVoc', 'FmaxVoc','Fmin', 'Fmax', 'Class', 'Membership'};
            T = cell2table(savetable,'VariableNames',titles);
            c = clock;
            formatIn = 'mm-dd-yyyy_HH-MM-SS';
            writetable(T,[dirOut '\Output_' datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6)),formatIn) '.xls']);
        end
        ClasesTablaPrueba(table, datos_clasifi, mean_class, ruta, channel, InfoZC,gadso,repre,Dispersion,speciesStr,~checkedOnlySpec,std_class);
       % Classresult(table, mean_class,ruta,channel,InfoZC); 
    end
end

% --- Executes on button press in cselectedsp.
function cselectedsp_Callback(hObject, eventdata, handles)
% hObject    handle to cselectedsp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cselectedsp


% --- Executes on button press in bsettings.
function bsettings_Callback(hObject, eventdata, handles)
% hObject    handle to bsettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DSettings



