function varargout = NewClass(varargin)
% NEWCLASS MATLAB code for NewClass.fig
%      NEWCLASS, by itself, creates a new NEWCLASS or raises the existing
%      singleton*.
%
%      H = NEWCLASS returns the handle to a new NEWCLASS or the handle to
%      the existing singleton*.
%
%      NEWCLASS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEWCLASS.M with the given input arguments.
%
%      NEWCLASS('Property','Value',...) creates a new NEWCLASS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NewClass_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NewClass_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NewClass

% Last Modified by GUIDE v2.5 21-Aug-2016 21:41:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NewClass_OpeningFcn, ...
                   'gui_OutputFcn',  @NewClass_OutputFcn, ...
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


% --- Executes just before NewClass is made visible.
function NewClass_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NewClass (see VARARGIN)

% Choose default command line output for NewClass
handles.output = hObject;
if length(varargin) == 8
    
    handles.minbanda = varargin{1};
    handles.maxbanda = varargin{2};
    handles.mean_class = varargin{3};
    handles.clase = varargin{4};
    handles.InfoZC = varargin{5};
    handles.count = varargin{6};
    handles.repre = varargin{7};
    handles.frecuencia = varargin{8};
    
    
    handles.fmin = handles.repre{6}+500;
    handles.fmax = handles.repre{7}-500;
    leng = handles.repre{10};
    sings = handles.repre{12};
    
    set(handles.tfmin,'String',[num2str(handles.fmin,5) ' Hz']);
    set(handles.tfmax,'String',[num2str(handles.fmax,5) ' Hz']);
    set(handles.tlength,'String',[num2str(leng,2) ' s']);
    set(handles.tsings,'String',[num2str(sings,2) ' s']);
    
    set(handles.tcount,'String',num2str(handles.count));
    set(handles.tclase,'String',num2str(handles.clase));
    
    axes(handles.axes1)
    imagesc('XData',handles.repre{2},'YData',handles.repre{3},'CData',handles.repre{1})
    axis([handles.repre{4} handles.repre{5} handles.repre{6} handles.repre{7}]) 
    rectangle('Position',[handles.repre{8} handles.repre{6} handles.repre{10} handles.repre{7}-handles.repre{6}],'EdgeColor',[0 0 0],'LineWidth',2,'LineStyle',':')
    xlabel('Time')
    ylabel('Frecuency') 
    
    
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NewClass wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NewClass_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function ename_Callback(hObject, eventdata, handles)
% hObject    handle to ename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ename as text
%        str2double(get(hObject,'String')) returns contents of ename as a double


% --- Executes during object creation, after setting all properties.
function ename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bguardar.
function bguardar_Callback(hObject, eventdata, handles)
% hObject    handle to bguardar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Obtener el nombre escogido
name=get(handles.ename, 'String');   

%Guardar especie
if isempty(name)
    %Si está vacío, arrojar un mensaje de error
    msgbox('Insert a name for the species.')
else

 
    mkdir([pwd '\Images'])
    f1 = figure;
    imagesc('XData',handles.repre{2},'YData',handles.repre{3},'CData',handles.repre{1})
    axis([handles.repre{4} handles.repre{5} handles.repre{6} handles.repre{7}]) 
    rectangle('Position',[handles.repre{8} handles.repre{6} handles.repre{10} handles.repre{7}-handles.repre{6}],'EdgeColor',[0 0 0],'LineWidth',2,'LineStyle',':')
    xlabel('Time')
    ylabel('Frecuency') 
    print(f1,[pwd '\Images\' name],'-djpeg')
    delete(f1);
    
    handles.repre(1:3)={0,0,0};
    %Obtener parámetros
    mediafrecuencia = handles.frecuencia{1};
    stdfrecuencia = handles.frecuencia{2};
    
    params=[handles.mean_class(handles.clase,:);mediafrecuencia(handles.clase,:);stdfrecuencia(handles.clase,:)];
    %Crear cell array con los datos de la nueva especie
    newSpec=[cellstr(name) handles.minbanda handles.maxbanda handles.InfoZC{3} handles.InfoZC{1} handles.InfoZC{2} handles.repre params];
    %Agregar nueva especie a la base de datos
    speciesHandle.addSpecies(newSpec);
    %Lanzar un mensaje indicando que la especie se guardó correctamente
    Species
    msgbox('The new species has been saved correctly.');
end

% --- Executes on button press in bcancelar.
function bcancelar_Callback(hObject, eventdata, handles)
% hObject    handle to bcancelar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1)
