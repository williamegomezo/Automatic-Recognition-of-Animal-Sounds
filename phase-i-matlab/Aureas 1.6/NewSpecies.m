function varargout = NewSpecies(varargin)
% NEWSPECIES MATLAB code for NewSpecies.fig
%      NEWSPECIES, by itself, creates a new NEWSPECIES or raises the existing
%      singleton*.
%
%      H = NEWSPECIES returns the handle to a new NEWSPECIES or the handle to
%      the existing singleton*.
%
%      NEWSPECIES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEWSPECIES.M with the given input arguments.
%
%      NEWSPECIES('Property','Value',...) creates a new NEWSPECIES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NewSpecies_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NewSpecies_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NewSpecies

% Last Modified by GUIDE v2.5 31-Oct-2016 01:10:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NewSpecies_OpeningFcn, ...
                   'gui_OutputFcn',  @NewSpecies_OutputFcn, ...
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


% --- Executes just before NewSpecies is made visible.
function NewSpecies_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NewSpecies (see VARARGIN)

% Choose default command line output for NewSpecies
handles.output = hObject;
mkdir([pwd '\Resultados']);
set(handles.dirsave,'String',[pwd '\Resultados']);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NewSpecies wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NewSpecies_OutputFcn(hObject, eventdata, handles) 
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


function emin_Callback(hObject, eventdata, handles)
% hObject    handle to emin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of emin as text
%        str2double(get(hObject,'String')) returns contents of emin as a double


% --- Executes during object creation, after setting all properties.
function emin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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


% --- Executes on button press in bstart.
function bstart_Callback(hObject, eventdata, handles)
% hObject    handle to bstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ruta = get(handles.dirsearch,'String');
dirOut = get(handles.dirsave,'String');
titles = {'File', 'Month', 'Day', 'Hour', 'Minute','Start' , 'End','Length','Fdom','FminVoc', 'FmaxVoc','Fmin', 'Fmax', 'Class'};
channel = get(handles.popchannels, 'Value');

autosel = get(handles.autosel, 'Value');
visualize = get(handles.checkvisualize, 'Value');



if (strcmp(get(handles.emin, 'String'),'Min')||isempty(get(handles.emin, 'String'))) && (strcmp(get(handles.emax, 'String'),'Max') || isempty(get(handles.emax, 'String')))
    [table datos_clasifi mean_class InfoZC gadso repre Dispersion frecuencia]=Metodologia(ruta, ['min';'max'], channel,autosel,visualize);
%     mean_class(1,:)=[]; %Se elimina la info de la NIC
%     repre(1)=[];
    %Escribir archivo New_species.xls
    if ~isempty(table)
        try
            savetable = [table num2cell(max(gadso)')];
            [savetable ix]= sortcell(savetable,1);
            titles = {'File', 'Month', 'Day', 'Hour', 'Minute','Start' , 'End','Length','Fdom','FminVoc', 'FmaxVoc','Fmin', 'Fmax', 'Class', 'Membership'};
            T = cell2table(savetable,'VariableNames',titles);
            c = clock;
            formatIn = 'mm-dd-yyyy_HH-MM-SS';
            writetable(T,[dirOut '\Classification_' datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6)),formatIn) '.xls'])
        end
        %         xlswrite([dirOut '\New_species.xls'], [titles; table]); 
    %Lanzar ventana con los resultados de la clasificación
        ClasesTablaPrueba(table, datos_clasifi,mean_class, ruta, channel, InfoZC,gadso,repre,Dispersion,[],0,frecuencia);
    end
elseif ~all(isstrprop(get(handles.emin, 'String'), 'digit')) || ~all(isstrprop(get(handles.emax, 'String'), 'digit'))
    msgbox('Insert valid values.');
else
    fmin=str2num(get(handles.emin, 'String'));  
    fmax=str2num(get(handles.emax, 'String')); 
    [table datos_clasifi mean_class InfoZC gadso repre Dispersion frecuencia]=Metodologia(ruta, [fmin, fmax], channel,autosel,visualize);
%     mean_class(1,:)=[]; %Se elimina la info de la NIC
%     repre(1)=[];
    %Escribir archivo New_species.xls
    if ~isempty(table)
        try
            savetable = [table num2cell(max(gadso)')];
            [savetable ix]= sortcell(savetable,1);
            titles = {'File', 'Month', 'Day', 'Hour', 'Minute','Start' , 'End','Length','Fdom','FminVoc', 'FmaxVoc','Fmin', 'Fmax', 'Class', 'Membership'};
            T = cell2table(savetable,'VariableNames',titles);
            c = clock;
            formatIn = 'mm-dd-yyyy_HH-MM-SS';
            writetable(T,[dirOut '\Classification_' datestr(datenum(c(1),c(2),c(3),c(4),c(5),c(6)),formatIn) '.xls'])
        end
    %Lanzar ventana con los resultados de la clasificación
        ClasesTablaPrueba(table, datos_clasifi,mean_class, ruta, channel, InfoZC,gadso,repre,Dispersion,[],0,frecuencia);
    end
end

% --- Executes on button press in bcancel.
function bcancel_Callback(hObject, eventdata, handles)
% hObject    handle to bcancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1)


function emax_Callback(hObject, eventdata, handles)
% hObject    handle to emax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of emax as text
%        str2double(get(hObject,'String')) returns contents of emax as a double


% --- Executes during object creation, after setting all properties.
function emax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emax (see GCBO)
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


% --- Executes on button press in autosel.
function autosel_Callback(hObject, eventdata, handles)
% hObject    handle to autosel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autosel


% --- Executes on button press in checkvisualize.
function checkvisualize_Callback(hObject, eventdata, handles)
% hObject    handle to checkvisualize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkvisualize
