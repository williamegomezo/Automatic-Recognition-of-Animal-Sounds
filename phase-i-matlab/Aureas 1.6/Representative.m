function varargout = Representative(varargin)
% REPRESENTATIVE MATLAB code for Representative.fig
%      REPRESENTATIVE, by itself, creates a new REPRESENTATIVE or raises the existing
%      singleton*.
%
%      H = REPRESENTATIVE returns the handle to a new REPRESENTATIVE or the handle to
%      the existing singleton*.
%
%      REPRESENTATIVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REPRESENTATIVE.M with the given input arguments.
%
%      REPRESENTATIVE('Property','Value',...) creates a new REPRESENTATIVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Representative_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Representative_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Representative

% Last Modified by GUIDE v2.5 23-Oct-2016 16:15:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Representative_OpeningFcn, ...
                   'gui_OutputFcn',  @Representative_OutputFcn, ...
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


% --- Executes just before Representative is made visible.
function Representative_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Representative (see VARARGIN)

% Choose default command line output for Representative
handles.output = hObject;
if length(varargin) == 7
    handles.repre = varargin{1};
    handles.table = varargin{2};
    handles.ruta = varargin{3};
    handles.ch = varargin{4};
    handles.Dispersion = varargin{5};
    handles.gadso = varargin{6};
    handles.Species = varargin{7};
    
    handles.flag = 0;
    classes=cell2mat(handles.table(:,end-1))';
    
    tabDat = handles.table; 
    for i=1:max(classes)
        count(i) = length(find(i==cell2mat(tabDat(:,15))));
    end
    
    count = (count -min(count))./(max(count) - min(count));
    
    Organizacion = count./handles.Dispersion;
    
    [B,handles.I] = sort(Organizacion,'descend');

    
    
    set(handles.popclasses,'String',handles.Species(handles.I))
    %Graficar clases y etiquetar los ejes.
    colors = distinguishable_colors(max(classes));
    repre = handles.repre;
    
    axes(handles.axes1)
    k=handles.I(1);
    Ind = repre(k);

    row= Ind;
      
    File = cell2mat(tabDat(row,2));
    Start = cell2mat(tabDat(row,7));
    End = cell2mat(tabDat(row,8));
    Ruta = handles.ruta;
    
    set(handles.tfmin,'String',strcat(num2str(cell2mat(tabDat(row,11)),5),' Hz'))
    set(handles.tfmax,'String',strcat(num2str(cell2mat(tabDat(row,12)),5),' Hz'))
    set(handles.tsings,'String',strcat(num2str(mean(cell2mat(tabDat(cell2mat(tabDat(:,15))==k,16))),2),' s'))
    set(handles.tlength,'String',strcat(num2str(cell2mat(tabDat(row,9)),2),' s'))
    set(handles.tcount,'String',num2str(length(find(k==cell2mat(tabDat(:,15))))))
    set(handles.tdisper,'String',num2str(handles.Dispersion(k)))
    %     
    if length(find(k==cell2mat(tabDat(:,15))))>0
        [y Fs]=audioread([Ruta '\' File]);
        y=y(:,handles.ch);

        wspec=1024; %tamaño de la ventana, nombre, voc corta o larga, tiempo de computo
        ovp=960; % overlap
        [s1,t,f] = stft(y, round(length(y)/5000), Fs, 'hamming',2^12);
        s1=abs(s1);
        s1=20*log10(s1);

        imagesc('XData',t,'YData',f,'CData',s1)
        axis([Start-1 End+1 cell2mat(tabDat(row,11))-500 cell2mat(tabDat(row,12))+500])  
        xlabel('Time')
        ylabel('Frecuency')        
        rectangle('Position',[Start cell2mat(tabDat(row,11)) End-Start cell2mat(tabDat(row,12))-cell2mat(tabDat(row,11))],'EdgeColor',[1 1 1],'LineWidth',3);
        rectangle('Position',[Start cell2mat(tabDat(row,11)) End-Start cell2mat(tabDat(row,12))-cell2mat(tabDat(row,11))],'EdgeColor',colors(k,:),'LineWidth',1.5);
    end
    
end
if length(varargin) == 2
    set(handles.bsimi,'visible','off')
    set(handles.text45,'visible','off')
    set(handles.text12,'visible','off')
    set(handles.tcount,'visible','off')
    set(handles.tdisper,'visible','off')
    handles.names = varargin{1};
    handles.repre = varargin{2};
    handles.flag=1;
    
    ind=1;
    
    set(handles.popclasses,'String',handles.names)
    
    fmin = handles.repre{ind,6}+500;
    fmax = handles.repre{ind,7}-500;
    leng = handles.repre{ind,10};
    sings = handles.repre{ind,12};
    
    set(handles.tfmin,'String',strcat(num2str(fmin,5),' Hz'))
    set(handles.tfmax,'String',strcat(num2str(fmax,5),' Hz'))
    set(handles.tsings,'String',strcat(num2str(leng,2),' s'))
    set(handles.tlength,'String',strcat(num2str(sings,2),' s'))
    
    
    Re = imread([pwd '\Images\' handles.names{get(handles.popclasses,'Value')} '.jpg']);
    imshow(Re) 
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Representative wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Representative_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popclasses.
function popclasses_Callback(hObject, eventdata, handles)
% hObject    handle to popclasses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popclasses contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popclasses
if handles.flag==0
    classes=cell2mat(handles.table(:,end-1))';

    colors = distinguishable_colors(max(classes));
    repre = handles.repre;
    axes(handles.axes1)
    k=handles.I(get(hObject,'Value'));
    Ind = repre(k);

    row= Ind;
    tabDat = handles.table;   
    File = cell2mat(tabDat(row,2));
    Start = cell2mat(tabDat(row,7));
    End = cell2mat(tabDat(row,8));
    Ruta = handles.ruta;

    set(handles.tfmin,'String',strcat(num2str(cell2mat(tabDat(row,11)),5),' Hz'))
    set(handles.tfmax,'String',strcat(num2str(cell2mat(tabDat(row,12)),5),' Hz'))
    set(handles.tsings,'String',strcat(num2str(cell2mat(tabDat(row,16)),2),' s'))
    set(handles.tlength,'String',strcat(num2str(cell2mat(tabDat(row,9)),2),' s'))
    set(handles.tcount,'String',num2str(length(find(k==cell2mat(tabDat(:,15))))))
    set(handles.tdisper,'String',num2str(handles.Dispersion(k)))
    % 
    if length(find(k==cell2mat(tabDat(:,15))))>0
        [y Fs]=audioread([Ruta '\' File]);
        y=y(:,handles.ch);

        wspec=1024; %tamaño de la ventana, nombre, voc corta o larga, tiempo de computo
        ovp=960; % overlap
        [s1,t,f] = stft(y, round(length(y)/5000), Fs, 'hamming',2^12);
        s1=abs(s1);
        s1=20*log10(s1);
        imagesc('XData',t,'YData',f,'CData',s1)
        axis([Start-1 End+1 cell2mat(tabDat(row,11))-500 cell2mat(tabDat(row,12))+500])  
        xlabel('Time')
        ylabel('Frecuency')        
        rectangle('Position',[Start cell2mat(tabDat(row,11)) End-Start cell2mat(tabDat(row,12))-cell2mat(tabDat(row,11))],'EdgeColor',[1 1 1],'LineWidth',3);
        rectangle('Position',[Start cell2mat(tabDat(row,11)) End-Start cell2mat(tabDat(row,12))-cell2mat(tabDat(row,11))],'EdgeColor',colors(k,:),'LineWidth',1.5);
    end
elseif handles.flag==1
    ind=get(hObject,'Value');
    
    set(handles.popclasses,'String',handles.names)
    
    if size(handles.repre{ind,6},1)>1
        fmin = mean(cell2mat(handles.repre{ind,6}))+500;
        fmax = mean(cell2mat(handles.repre{ind,7}))-500;
        leng = mean(cell2mat(handles.repre{ind,10}));
        sings = mean(cell2mat(handles.repre{ind,12}));
    else
        fmin = handles.repre{ind,6}+500;
        fmax = handles.repre{ind,7}-500;
        leng = handles.repre{ind,10};
        sings = handles.repre{ind,12};
    end
    
    
    
    set(handles.tfmin,'String',strcat(num2str(fmin,5),' Hz'))
    set(handles.tfmax,'String',strcat(num2str(fmax,5),' Hz'))
    set(handles.tsings,'String',strcat(num2str(leng,2),' s'))
    set(handles.tlength,'String',strcat(num2str(sings,2),' s'))
    
    Re = imread([pwd '\Images\' handles.names{get(handles.popclasses,'Value')} '.jpg']);
    imshow(Re)  
end

% --- Executes during object creation, after setting all properties.
function popclasses_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popclasses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bsimi.
function bsimi_Callback(hObject, eventdata, handles)
% hObject    handle to bsimi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gadso = handles.gadso;

if strcmp(handles.Species(1,:),'NIC')
    gadso(1,:)=[]
    handles.Species(1,:)=[];
end

[n m] = size(gadso);
tree=[];
while sum(sum(gadso(1:end-1,:),2))~=0
    Index = IndiceSimilitud( gadso );
    Index = triu(Index,1);
    [dummy c1]=max(Index);
    [dummy c2]=max(dummy);
    c1=c1(c2);
    Index(c1,c2)=0;
    gadso(end+1,:)=max([gadso(c1,:);gadso(c2,:)]);
    gadso(c1,:)=zeros(1,size(gadso,2));
    gadso(c2,:)=zeros(1,size(gadso,2));
    tree = [tree;c1,c2,1-dummy];
end
figure
dendrogram(tree)
set(gca, 'XTick', 1:length(handles.Species) , 'XTickLabel', handles.Species(str2num(get(gca,'XTickLabel')),:))
xlabel('Clusters')
ylabel('1 - Similarity')
