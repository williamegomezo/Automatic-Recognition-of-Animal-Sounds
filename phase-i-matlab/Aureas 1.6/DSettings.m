function varargout = DSettings(varargin)
% DSETTINGS MATLAB code for DSettings.fig
%      DSETTINGS, by itself, creates a new DSETTINGS or raises the existing
%      singleton*.
%
%      H = DSETTINGS returns the handle to a new DSETTINGS or the handle to
%      the existing singleton*.
%
%      DSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DSETTINGS.M with the given input arguments.
%
%      DSETTINGS('Property','Value',...) creates a new DSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DSettings

% Last Modified by GUIDE v2.5 06-Jan-2017 17:54:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @DSettings_OutputFcn, ...
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


% --- Executes just before DSettings is made visible.
function DSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DSettings (see VARARGIN)

% Choose default command line output for DSettings
handles.output = hObject;
mkdir Settings

fileID = fopen('Settings/Format.txt');
if fileID < 0 
    defaultans = {'RECORDER_yyyymmdd_HHMMSS','_'};
    set(handles.eformat,'String', defaultans{1})
    set(handles.esep,'String', defaultans{2})
    
else
    C = textscan(fileID,'%s');
    fclose(fileID);
    defaultans = C{1,1};
    
    set(handles.eformat,'String', defaultans{1})
    set(handles.esep,'String', defaultans{2})
end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DSettings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function eformat_Callback(hObject, eventdata, handles)
% hObject    handle to eformat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eformat as text
%        str2double(get(hObject,'String')) returns contents of eformat as a double


% --- Executes during object creation, after setting all properties.
function eformat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eformat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function esep_Callback(hObject, eventdata, handles)
% hObject    handle to esep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of esep as text
%        str2double(get(hObject,'String')) returns contents of esep as a double


% --- Executes during object creation, after setting all properties.
function esep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to esep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pdefault.
function pdefault_Callback(hObject, eventdata, handles)
% hObject    handle to pdefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
defaultans = {'RECORDER_yyyymmdd_HHMMSS','_'};
set(handles.eformat,'String', defaultans{1})
set(handles.esep,'String', defaultans{2})

% --- Executes on button press in pnodate.
function pnodate_Callback(hObject, eventdata, handles)
% hObject    handle to pnodate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
defaultans = {'RECORDER','?'};
set(handles.eformat,'String', defaultans{1})
set(handles.esep,'String', defaultans{2})

% --- Executes on button press in paccept.
function paccept_Callback(hObject, eventdata, handles)
% hObject    handle to paccept (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fid = fopen('Settings/Format.txt','w');
fprintf(fid, get(handles.eformat,'String'));
fprintf(fid, char(13));
fprintf(fid, get(handles.esep,'String'));
fclose(fid);
delete(handles.figure1)

% --- Executes on button press in pcancel.
function pcancel_Callback(hObject, eventdata, handles)
% hObject    handle to pcancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1)