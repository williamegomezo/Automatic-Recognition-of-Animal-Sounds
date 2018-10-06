function varargout = Analysis(varargin)
% ANALYSIS MATLAB code for Analysis.fig
%      ANALYSIS, by itself, creates a new ANALYSIS or raises the existing
%      singleton*.
%
%      H = ANALYSIS returns the handle to a new ANALYSIS or the handle to
%      the existing singleton*.
%
%      ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSIS.M with the given input arguments.
%
%      ANALYSIS('Property','Value',...) creates a new ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Analysis

% Last Modified by GUIDE v2.5 08-Nov-2016 22:29:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @Analysis_OutputFcn, ...
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


% --- Executes just before Analysis is made visible.
function Analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Analysis (see VARARGIN)

% Choose default command line output for Analysis
handles.output = hObject;
if length(varargin) == 10
    handles.table = varargin{1};
    handles.mean_class = varargin{2};
    handles.gadso = varargin{3};
    handles.repre = varargin{4};
    handles.ruta = varargin{5};
    handles.ch = varargin{6};
    handles.addvector=varargin{7};
    handles.Dispersion = varargin{8};
    handles.Species = varargin{9};
    nopatterns = varargin{10};
    if nopatterns
        set(handles.pushbutton4,'Enable','off')
    else
        set(handles.pushbutton4,'Enable','on')
    end
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Analysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in vergad.
function vergad_Callback(hObject, eventdata, handles)
% hObject    handle to vergad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
classes=cell2mat(handles.table(:,end))';
%Graficar clases y etiquetar los ejes.
colors = distinguishable_colors(max(classes));

for k=1:max(classes)
    figure
    plot(handles.gadso(k,:),'Color',colors(k,:),'LineWidth',2);
    xlabel('Samples')
    ylabel('Membership')
    if isempty(num2str(handles.Species{k}))
        title(['Cluster ' handles.Species{k}])
    else
        title(['Cluster ' num2str(handles.Species{k})])
    end
    hold on
end

% --- Executes on button press in verclases.
function verclases_Callback(hObject, eventdata, handles)
% hObject    handle to verclases (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabla = handles.table;

xdata=cell2mat(tabla(:,11))';
classes=cell2mat(tabla(:,end))';
%Graficar clases y etiquetar los ejes.
colors = distinguishable_colors(max(classes));

figure
for k=1:max(classes)   
    ind = find(classes==k);
    x=xdata(ind);
    y=classes(ind);
    a = 15;
    scatter(x,y,a,'filled','s','MarkerFaceColor',colors(k,:))
    xlabel('Min. Frequency [Hz]')
    ylabel('Cluster')
    hold on
end
set(gca, 'YTick', 1:length(handles.Species), 'YTickLabel', handles.Species)

% --- Executes on button press in gadfunction.
function gadfunction_Callback(hObject, eventdata, handles)
% hObject    handle to gadfunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Bar = waitbar(0,'Computing...','Name','Computing membership as function of...');
waitbar(0,Bar,sprintf('%d%% completed...',0));


x = get(handles.popupmenu1, 'Value');
y = get(handles.popupmenu2, 'Value');

data = handles.table;
data(:,end+1)=num2cell(handles.addvector);

variable = [11 12 10 9 16];%Indices de las columnas de la tabla
Stringslabel = {'Fmin' 'Fmax' 'Fdom' 'Length' 'Singing Freq.'};


v1=cell2mat(data(:,variable(x)));
v2=cell2mat(data(:,variable(y)));


label_x=Stringslabel(x);
label_y=Stringslabel(y);

classes=cell2mat(handles.table(:,end))';
%Graficar clases y etiquetar los ejes.
colors = distinguishable_colors(max(classes));
fig = figure;
p=1;
if strcmp(handles.Species(1,:),'NIC')
    inicio=2;
else
    inicio=1;
end
for k=inicio:max(classes)  
    ind =find(classes==k);
    x=v1(ind)';
    y=v2(ind)';
    gad=handles.gadso(k,ind)';
    
    for i=1:length(x)
        colorgad = rgb2hsv(colors(k,:));
        colorgad(2) = gad(i)*colorgad(2);
        colorgad = hsv2rgb(colorgad);
        sz=50;
        scatter(x(i),y(i),sz,'filled','MarkerFaceColor',colorgad,'MarkerEdgeColor',colors(k,:)); 
        grid on
        hold on
    end
    
    
    xlabel(label_x)
    ylabel(label_y)
    zlabel('Samples')
   
    
    perc = k*100/max(classes);
    waitbar(perc/100,Bar,sprintf('%d%% completed...',uint8(perc)))

end
delete(Bar)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Activity patterns




Bar = waitbar(0,'Computing...','Name','Computing Activity patterns...');
waitbar(0,Bar,sprintf('%d%% completed...',0));

data = handles.table;
names = data(:,2);    
Zona = [];
Year = [];
Month = [];
Day = [];
Hour = [];

classes=cell2mat(handles.table(:,end))';
%Graficar clases y etiquetar los ejes.
colors = distinguishable_colors(max(classes));

if get(handles.caverage,'Value') || get(handles.cperday,'Value')
    if isempty(get(handles.eactivity, 'String'))
        min_class = 1;
        max_class = max(classes);
        activity_vector=1:max_class;
    else
        stringvector = strsplit(get(handles.eactivity, 'String'),' ');
        Ind = [];
        for i=1:length(stringvector)
            if isempty(str2num(stringvector{i}))
                ind=[];
                for g=1:size(handles.Species,1)
                    if strcmp(stringvector{i},handles.Species{g})
                        ind = g;
                    end
                end
                if isempty(ind)
                    msgbox('Select a valid cluster')
                    return;
                end
                Ind=[Ind,ind];
            else
                Ind=[Ind,str2num(stringvector{i})];
            end
        end


        activity_vector = Ind;
    end

    if length(find(activity_vector>max(classes)))
        msgbox('Select a valid cluster')
        return;
    end

    for i=1:size(names,1)
        Split = strsplit(names{i},'_');

        Zona =  strvcat(Zona,Split{1});
        Year =  [Year;  str2num(Split{2}(1:4))];
        Month = [Month; str2num(Split{2}(5:6))];
        Day =   [Day;   str2num(Split{2}(7:8))];
        Hour =   [Hour;  str2num(Split{3}(1:2))];
    end

    Zona = unique(Zona,'rows');
    Day = unique(sort(Day));
    Month = unique(sort(Month));
    Year = unique(sort(Year));
    Hour = unique(sort(Hour));


    for i=1:size(Zona,1)
        for j=1:size(Year,1)
            for k=1:size(Month,1)
                Graphmes = [];
                for e=1:size(Day,1)


                        year= num2str(Year(j));

                        dia = num2str(Day(e));
                        if Day(e)<10
                           dia = strcat('0',num2str(Day(e)));
                        end

                        mes = num2str(Month(k));
                        if Month(k)<10
                           mes = strcat('0',num2str(Month(k)));
                        end



                        %Se mira si hay archivos con esas caracteristica
                        Named = [Zona(i,~isspace(Zona(i,:))) '_' year mes dia];

                        idx = strfind(data(:,2),Named);
                        %Mira si ese día sí está

                        if sum(cell2mat(idx))>0 %Grafique

                            graphdia = zeros(24,max(classes));
                            for w=0:23 %24 horas
                                hora = num2str(w);
                                if w<10
                                    hora = strcat('0',num2str(w));
                                end

                                Name = [Zona(i,~isspace(Zona(i,:))) '_' year mes dia '_' hora];

                                idx = strfind(data(:,2),Name);

                                for g=1:size(idx,1)
                                    if isempty(idx{g})
                                        indx(g)=0;
                                    else
                                        indx(g)=1;
                                    end
                                end
                                indx =  find(indx); %Archivos con esa hora


                                for g=activity_vector
                                    graphdia(w+1,g) =  sum(g==cell2mat(data(indx,end)));
                                end
                            end

                            Graphmes(:,:,e) = graphdia;

                            if sum(sum(graphdia))>0
                                indb = find(sum(graphdia)==0);
                                indp = find(sum(graphdia)~=0);
                                graphdia(:,indb)=[];

                                if get(handles.cperday,'Value')
                                    figure
                                    b = bar(0:23,graphdia);


                                    for g=1:length(indp)
                                        set(b(g),'FaceColor',colors(indp(g),:));
                                        hold on
                                    end
                                    title(['Per day ' Named]);
                                    xlabel('Hours');
                                    ylabel('# of Calls');
                                    if max(max(graphdia))>100
                                        Maximo= max(max(graphdia));
                                    else
                                        Maximo= 100;
                                    end

                                    axis([-1 24 0 Maximo])
                                    set(gca,'xtick',-1:24)
                                end
                            end
                        end
                        
                    perc = (e + (k-1)*size(Day,1) + (j-1)*size(Month,1)*size(Day,1) + (i-1)*size(Month,1)*size(Day,1)*size(Year,1) )*100/(size(Day,1)*size(Month,1)*size(Year,1)*size(Zona,1));
                    waitbar(perc/100,Bar,sprintf('%d%% completed...',uint8(perc)))

                end
                
                if get(handles.caverage,'Value')
                    Graphmes = sum(Graphmes,3)/30;
                    if sum(sum(Graphmes))>0

                            indb = find(sum(Graphmes)==0);
                            indp = find(sum(Graphmes)~=0);
                            Graphmes(:,indb)=[];
                            figure
                            b = bar(0:23,Graphmes);


                            for g=1:length(indp)
                                set(b(g),'FaceColor',colors(indp(g),:));
                                hold on
                            end
                            xlabel('Hours');
                            ylabel('Average of # of Calls');
                            if max(max(Graphmes))>3
                                Maximo= max(max(Graphmes));
                            else
                                Maximo= 3;
                            end
                            title(['Average per Month ' Named(1:end-2)]);
                            axis([-1 24 0 Maximo])
                            set(gca,'xtick',-1:24)
                    end
                end
            end
        end
    end
end
delete(Bar)


% --- Executes on button press in repre_ele.
function repre_ele_Callback(hObject, eventdata, handles)
% hObject    handle to repre_ele (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.table(:,end+1)=num2cell(handles.addvector);
Representative(handles.repre,handles.table,handles.ruta,handles.ch,handles.Dispersion,handles.gadso,handles.Species)



function eactivity_Callback(hObject, eventdata, handles)
% hObject    handle to eactivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eactivity as text
%        str2double(get(hObject,'String')) returns contents of eactivity as a double


% --- Executes during object creation, after setting all properties.
function eactivity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eactivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cperday.
function cperday_Callback(hObject, eventdata, handles)
% hObject    handle to cperday (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cperday


% --- Executes on button press in caverage.
function caverage_Callback(hObject, eventdata, handles)
% hObject    handle to caverage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of caverage
