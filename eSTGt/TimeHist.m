function varargout = TimeHist(varargin)
% TIMEHIST MATLAB code for TimeHist.fig
%      TIMEHIST, by itself, creates a new TIMEHIST or raises the existing
%      singleton*.
%
%      H = TIMEHIST returns the handle to a new TIMEHIST or the handle to
%      the existing singleton*.
%
%      TIMEHIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TIMEHIST.M with the given input arguments.
%
%      TIMEHIST('Property','Value',...) creates a new TIMEHIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TimeHist_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TimeHist_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TimeHist

% Last Modified by GUIDE v2.5 16-Jul-2013 08:31:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TimeHist_OpeningFcn, ...
                   'gui_OutputFcn',  @TimeHist_OutputFcn, ...
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


% --- Executes just before TimeHist is made visible.
function TimeHist_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TimeHist (see VARARGIN)

% Choose default command line output for TimeHist
handles.output = hObject;
handles.Time = varargin{1};
handles.HistData = varargin{2};
handles.Names = varargin{3};

L = length(handles.Time);
set(handles.sliderTime,'SliderStep',[1/L 1/L]);
set(handles.sliderTime,'Value',1);
set(handles.textTime,'String',['Time: ' num2str(handles.Time(end))]);
hListener=handle.listener(handles.sliderTime,'ActionEvent',@updateHist);
setappdata(handles.sliderTime,'myListener',hListener);
set(handles.checkboxAutoBins,'Value',1);
set(handles.editBins,'Enable','off');
for i=1:length(handles.Names)
    maxHistX(i) = max(max(cell2mat(handles.HistData(:,i))));
    maxHistY(i) = max(max(cellfun(@(x) size(x,2),handles.HistData(:,i))));
end
handles.maxHistX = maxHistX;
handles.maxHistY = maxHistY;
[a b] = hist(handles.axesHist,cell2mat(handles.HistData(end,1)));
set(handles.editBins,'String',length(b));
bar(b,a);
legend(handles.axesHist,handles.Names(1));
datacursormode(handles.output);
set(handles.axesHist,'xlim',[0 maxHistX(1)]);
set(handles.listboxSpecies,'String',handles.Names);

% Update handles structure
set(handles.sliderTime,'UserData',handles);
guidata(hObject, handles);

% UIWAIT makes TimeHist wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function map = uniteMaps(maps)
a = cellfun(@(x) x.keys,maps,'UniformOutput',false);
keys = unique(horzcat(a{:}));
map = containers.Map(keys,zeros(1,length(keys)));
for i=1:length(maps)
    mapsTmp{i} = containers.Map(keys,zeros(1,length(keys)));
    mapsTmp{i} = [mapsTmp{i}'; maps{i}'];
end
values = sum(cell2mat(cellfun(@(x) cell2mat(x.values),mapsTmp,'UniformOutput',false)'));
map = containers.Map(keys,values);


% --- Outputs from this function are returned to the command line.
function varargout = TimeHist_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function sliderTime_Callback(hObject, eventdata, handles)
% hObject    handle to sliderTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

function updateHist(varargin)
handles = varargin{1}.UserData;
val = get(handles.sliderTime,'Value');
t = round(val*length(handles.Time));
if (t == 0)
    t = 1;
end
set(handles.textTime,'String',['Time: ' num2str(handles.Time(t))]);
plotHist(handles);

% --- Executes during object creation, after setting all properties.
function sliderTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in listboxSpecies.
function listboxSpecies_Callback(hObject, eventdata, handles)
% hObject    handle to listboxSpecies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxSpecies contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxSpecies
plotHist(handles);

function plotHist(handles)

val = get(handles.sliderTime,'Value');
t = round(val*length(handles.Time));
if (t == 0)
    t = 1;
end

vals = get(handles.listboxSpecies,'Value');
if (get(handles.checkboxAutoBins,'Value') == 0)
    bins = str2num(get(handles.editBins,'String'));
    hist(handles.axesHist,cell2mat(handles.HistData(t,vals)')',bins);
else
    [a b] = hist(handles.axesHist,cell2mat(handles.HistData(t,vals)')');
    bar(handles.axesHist,b,a);
end
if (get(handles.checkboxAutoBins,'Value') == 1)
    set(handles.editBins,'String',length(b));
end
if (get(handles.checkboxX,'Value') == 1)
    set(handles.axesHist,'xlim',[0 max(handles.maxHistX(vals))]);
end
if (get(handles.checkboxY,'Value'))
    set(handles.axesHist,'ylim',[0 max(handles.maxHistY(vals))]);
end
legend(handles.axesHist,handles.Names(vals));


% --- Executes during object creation, after setting all properties.
function listboxSpecies_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxSpecies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxX.
function checkboxX_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxX
plotHist(handles);

% --- Executes on button press in checkboxY.
function checkboxY_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxY
plotHist(handles);



function editBins_Callback(hObject, eventdata, handles)
% hObject    handle to editBins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBins as text
%        str2double(get(hObject,'String')) returns contents of editBins as a double
val = str2num(get(hObject,'String'));
if (isempty(val))
    set(hObject,'String',10);
else
    set(hObject,'String',round(val));
end
plotHist(handles);

% --- Executes during object creation, after setting all properties.
function editBins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxAutoBins.
function checkboxAutoBins_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxAutoBins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxAutoBins
if (get(hObject,'Value'))
    set(handles.editBins,'Enable','off');
else
    set(handles.editBins,'Enable','on');
end
plotHist(handles);
