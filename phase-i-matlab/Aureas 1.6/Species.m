function varargout = Species(varargin)
% SPECIES MATLAB code for Species.fig
%      SPECIES, by itself, creates a new SPECIES or raises the existing
%      singleton*.
%
%      H = SPECIES returns the handle to a new SPECIES or the handle to
%      the existing singleton*.
%
%      SPECIES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECIES.M with the given input arguments.
%
%      SPECIES('Property','Value',...) creates a new SPECIES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Species_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Species_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Species

% Last Modified by GUIDE v2.5 27-Dec-2016 15:55:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Species_OpeningFcn, ...
                   'gui_OutputFcn',  @Species_OutputFcn, ...
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


% --- Executes just before Species is made visible.
function Species_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Species (see VARARGIN)

% Choose default command line output for Species
handles.output = hObject;
% Update handles structure

avspecies = speciesHandle.getSpecies();

if ~isempty(avspecies)
    set(handles.lspecies,'string',avspecies(:,1));
    handles.repre = avspecies(:,7:18);
end


if length(varargin) == 2
    if varargin{1}=='A'
        set(handles.ladd,'string',varargin{2});
    end
end

guidata(hObject, handles);
% UIWAIT makes Species wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Species_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --- Executes on selection change in ladd.
function ladd_Callback(hObject, eventdata, handles)
% hObject    handle to ladd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ladd contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ladd


% --- Executes during object creation, after setting all properties.
function ladd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ladd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in badd.
function badd_Callback(hObject, eventdata, handles)
% hObject    handle to badd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.lspecies,'String');
Speciesadded= cell2mat(contents(get(handles.lspecies,'Value'),:));
ListSpecies = get(handles.ladd,'String');
if ischar(ListSpecies)
    ListSpecies = cell(ListSpecies);
end
flag=1;
if ~isempty(ListSpecies)
    for g=1:size(ListSpecies,1)
        if strcmp(Speciesadded,ListSpecies{g,:})
            flag=0;
        end
    end
    
    if flag==1
        ListSpecies{length(ListSpecies)+1} = Speciesadded;
    end

else
    ListSpecies{1} = Speciesadded;
end

set(handles.ladd,'String',ListSpecies);
value = get(handles.lspecies,'Value');
if value<size(get(handles.lspecies,'String'),1)
    set(handles.lspecies,'Value',value+1);
end

% --- Executes on button press in bdel.
function bdel_Callback(hObject, eventdata, handles)
% hObject    handle to bdel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.ladd,'String');
if ~isempty(contents)
    contents(get(handles.ladd,'Value'),:)=[];
    set(handles.ladd,'Value',1);
    set(handles.ladd,'String',contents);
end

% --- Executes on button press in bnew.
function bnew_Callback(hObject, eventdata, handles)
% hObject    handle to bnew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NewSpecies

% --- Executes on button press in bdelete.
function bdelete_Callback(hObject, eventdata, handles)
% hObject    handle to bdelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = questdlg('This class will be deleted', ...
	'Confirmation', ...
	'Accept','Cancel','Cancel');
% Handle response
switch choice
    case 'Accept'
        Ind = get(handles.lspecies,'Value');
        contents = get(handles.lspecies,'String');
        if ~isempty(contents)
            speciesHandle.rmSpecies(Ind);
            contents(Ind,:)=[];
            set(handles.lspecies,'Value',1);
            set(handles.lspecies,'String',contents);
            
        end
    case 'Cancel'
end





% --- Executes on button press in bok.
function bok_Callback(hObject, eventdata, handles)
% hObject    handle to bok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.ladd,'string'))
    Aureas
else
    Aureas(get(handles.ladd,'string'))
end

% --- Executes on button press in bcancel.
function bcancel_Callback(hObject, eventdata, handles)
% hObject    handle to bcancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1)


% --- Executes on button press in elerepre.
function elerepre_Callback(hObject, eventdata, handles)
% hObject    handle to elerepre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.lspecies,'Value');
if isempty(get(handles.lspecies,'String'))
    Representative
else
    Representative(get(handles.lspecies,'String'),handles.repre);
end


% --- Executes on button press in baddall.
function baddall_Callback(hObject, eventdata, handles)
% hObject    handle to baddall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ladd,'String',get(handles.lspecies,'String'));

% --- Executes on button press in bremoveall.
function bremoveall_Callback(hObject, eventdata, handles)
% hObject    handle to bremoveall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ladd,'String',[]);


% --- Executes on button press in bload.
function bload_Callback(hObject, eventdata, handles)
% hObject    handle to bload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiopen('load');
if exist('images','var')
    mkdir('Images');
    for i=1:size(species,1)
        imwrite(images{i},['Images\' cell2mat(species(i,1)) '.jpg'])
    end
end
if exist('species','var')
    loaded = species;
    avspecies = speciesHandle.getSpecies();
    try
        prueba = [avspecies;loaded];
        cell2mat(prueba(:,4));
    catch
        msgbox('Select a valid file')
        return
    end
    
    for i=1:length(loaded)
        try
            speciesHandle.addSpecies(loaded(i,:));
        end
    end
    avspecies = speciesHandle.getSpecies();
    set(handles.lspecies,'String',avspecies(:,1)); 
    handles.repre = avspecies(:,7:18);
    guidata(hObject, handles);
else
    msgbox('No file selected')
end
set(handles.lspecies,'Value',1)

% --- Executes on button press in bsave.
function bsave_Callback(hObject, eventdata, handles)
% hObject    handle to bsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
species = speciesHandle.getSpecies();
[file,path] = uiputfile('Species.mat','Save Specie File As');
images={};
ind = get(handles.lspecies,'Value');
for i=1:length(ind)
    images{i} = imread(strcat('Images/',cell2mat(species(ind(i),1)),'.jpg'));
end

if file~=0
    species = species(ind,:);
    save([path file],'species','images')
else
    msgbox('No file selected')
end


% --- Executes on button press in bmerge.
function bmerge_Callback(hObject, eventdata, handles)
% hObject    handle to bmerge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('Species.mat')
ind = get(handles.lspecies,'Value');
for i=1:length(ind)
    images{i} = imread(strcat('Images/',cell2mat(species(ind(i),1)),'.jpg'));
end

name = inputdlg('New name:');

nueva = size(species,1)+1;
species(nueva,1)=cellstr(strcat('Merged_',name));

imwrite(images{1},cell2mat(strcat('Images/','Merged_',name,'.jpg')))

for i=2:size(species,2)
    species{nueva,i}=species(ind,i);
end

set(handles.lspecies,'String',species(:,1)); 

save('Species.mat','species','images')

handles.repre = species(:,7:18);
guidata(hObject, handles);