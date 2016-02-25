function varargout = TimeBar(varargin)
% TIMEBAR MATLAB code for TimeBar.fig
%      TIMEBAR, by itself, creates a new TIMEBAR or raises the existing
%      singleton*.
%
%      H = TIMEBAR returns the handle to a new TIMEBAR or the handle to
%      the existing singleton*.
%
%      TIMEBAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TIMEBAR.M with the given input arguments.
%
%      TIMEBAR('Property','Value',...) creates a new TIMEBAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TimeBar_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TimeBar_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TimeBar

% Last Modified by GUIDE v2.5 23-Sep-2013 10:15:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TimeBar_OpeningFcn, ...
                   'gui_OutputFcn',  @TimeBar_OutputFcn, ...
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


% --- Executes just before TimeBar is made visible.
function TimeBar_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TimeBar (see VARARGIN)

% Choose default command line output for TimeBar
handles.output = hObject;

handles.DataHandles = varargin{1};
if (~isfield(handles.DataHandles,'RunsData'))
    return;
end
datacursormode(handles.output);
handles.Time = unique(handles.DataHandles.RunsData.Tall);
L = length(handles.Time);
set(handles.sliderTime,'SliderStep',[1/L 1/L]);
set(handles.sliderTime,'Value',1);
set(handles.textTime,'String',['Time: ' num2str(handles.Time(end))]);
handles.selT = length(handles.Time);

set(handles.listbox1,'String',handles.DataHandles.Rules.StartNames);
set(handles.listbox1,'Value',1);

set(handles.listbox2,'String',handles.DataHandles.Rules.Prod{1}.InternalStatesNames);
set(handles.listbox2,'Value',1);
set(handles.checkboxAutoHist,'Value',1);

set(handles.listboxPopSizeSp,'String',handles.DataHandles.Rules.AllNames);
set(handles.listboxPopSizeSp,'Value',1:length(handles.DataHandles.Rules.AllNames));

handles.DataHandles.axesPopSize = handles.axesPopSize;
handles.DataHandles.listboxPopSizeSp = handles.listboxPopSizeSp;

set(handles.checkboxLine,'Value',0);
plotPopulationSize(handles,handles.axesPopSize);
yl = ylim(handles.axesPopSize);
handles.XData = [-1 -1];
handles.YData = [yl(1) yl(2)];
handles.hLine = line(handles.XData, handles.YData ,'Color','k','LineWidth',5);
set(handles.hLine,'Parent',handles.axesPopSize);

set(handles.listboxFigType,'String',{'Clones Histogram','Rules Histogram','Internal States Histogram'});
set(handles.listboxFigType,'Value',1);
handles.nBins = 0;
listboxFigType_Callback(handles.listboxFigType, eventdata, handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TimeBar wait for user response (see UIRESUME)
% uiwait(handles.figureTimeBar);
function updateRulesHistogram(handles,fig)
i = get(handles.listbox1,'Value');
j = get(handles.listbox2,'Value');
t = handles.Time(handles.selT);
per = get(handles.checkbox5,'Value');
histMap = cell(length(handles.DataHandles.Runs),1);
for r=1:length(handles.DataHandles.Runs)
    ind = find(handles.DataHandles.Runs(r).T>=t,1,'first');
    if (isempty(ind))
        ind = length(handles.DataHandles.Runs(r).T);
    end
    R(r,:) = histc(handles.DataHandles.Runs(r).R(1:ind),0:length(handles.DataHandles.Rules.Propensities));
end

hold(fig,'off');
inds = get(handles.listbox2,'Value');
list = get(handles.listbox2,'String');
if (r == 1)
    h = bar(fig,R(inds+1));
    set(fig,'XTickLabel',list(inds));
else
    if (handles.nBins == 0)
        [n,x] = hist(fig,R(:,inds+1));
        S = sum(n);
        if (per == 0)
            S = 1;
        end
        bar(fig,x,n./S(1),'hist');
    else
        [n,x] = hist(fig,R(:,inds+1),handles.nBins);
        S = sum(n);
        if (per == 0)
            S = 1;
        end
        if (per == 0)
            S = 1;
        end
        bar(fig,x,n./S(1),'hist');
    end
    hLeg = legend(fig,list(inds));
    set(hLeg,'Interpreter','none');
end

xlabel(fig,'# of times the rule has been executed');

if (per == 0)
    ylabel(fig,'# of Runs');
else
    ylabel(fig,'% of Runs');
end
title(fig,['Rules Execution Histogram (total of ' num2str(length(handles.DataHandles.Runs)) ' runs)']);


function updateISHistogram(handles,fig)
if (isempty(get(handles.listbox2,'String')))
    return;
end
per = get(handles.checkbox5,'Value');
i = get(handles.listbox1,'Value');
j = get(handles.listbox2,'Value');
t = handles.Time(handles.selT);
histMap = cell(length(handles.DataHandles.Runs),1);
for r=1:length(handles.DataHandles.Runs)
    ind = find(handles.DataHandles.Runs(r).T>=t,1,'first');
    if (isempty(ind))
        ind = length(handles.DataHandles.Runs(r).T);
    end
    liveinds = handles.DataHandles.Runs(r).LiveNodes{ind,i};
    A=handles.DataHandles.Runs(r).Nodes{i}(liveinds);
    vals = [];
    for k=1:length(A) 
        vals{k} = A(k).InternalStates.(handles.DataHandles.Rules.Prod{i}.InternalStatesNames{j}); 
    end
    histMap{r} = cell2mat(vals);
end   
histMapNE = histMap;
histMapNE(cellfun(@isempty,histMap)) = [];
if (isempty(histMapNE))
    bar(fig,0);
else
    MI = min(cellfun(@min,histMapNE));
    MA = max(cellfun(@max,histMapNE));
    numbins = str2num(get(handles.editBins,'String'));
    X = [MI:(MA-MI)/numbins:MA];
    if (isempty(X))
        X = [MI-1 MI MI+1];
    end
    for r=1:length(handles.DataHandles.Runs)
        [a{r} b{r}] = hist(histMap{r},X);
    end

    if (r==1)
        M = cell2mat(a');
    else
        M = mean(cell2mat(a'));
    end
    hold(fig,'off');
if (per == 1)
    S = sum(M);
    bar(fig,X,M/S);
    ylabel(fig,'% of Internal States');
else
    bar(fig,X,M);
    ylabel(fig,'# of Internal States');
end
end
xlabel(fig,'Internal State Value');
title(fig,['Internal States Values Histogram (total of ' num2str(length(handles.DataHandles.Runs)) ' runs)']);


function updateClonesHistogram(handles,fig)
tsel = handles.Time(handles.selT);
valOrig = get(handles.listbox1,'Value');
valsDispSp = get(handles.listbox2,'Value');
histRuns = cell(length(handles.DataHandles.Runs),length(valsDispSp));
per = get(handles.checkbox5,'Value');
for r=1:length(handles.DataHandles.Runs)
    t = find(handles.DataHandles.Runs(r).T>=tsel,1,'first');
    for i=1:length(valsDispSp)
        valDisp = valsDispSp(i);
        livenodes = handles.DataHandles.Runs(r).LiveNodes{t,valDisp};
        nodes = handles.DataHandles.Runs(r).Nodes{valDisp}(livenodes);
        if (isempty(nodes))
            continue;
        end
        RootType = extractfield(nodes,'RootType');
        RootInd = extractfield(nodes,'RootInd');
        inds = find(RootType == valOrig);
        RootInd(inds);
        [a b] = histc(RootInd(inds),unique(RootInd(inds)));
        histRuns{r,i} = a;
        histRuns{r,i}(end+1:end+handles.DataHandles.Rules.InitPop(valOrig)-length(a)) = 0;
    end
end
cc=handles.DataHandles.colors;
histRuns(cellfun(@isempty,histRuns)) = {0};
data = cell2mat(histRuns(:,1)');
if (handles.nBins > 0)
    [n{1}, xout{1}] = hist(data,handles.nBins);
else
    [n{1}, xout{1}] = hist(data,[0:max(data)]);
    maxD = max(data);
end
xall = xout{1};
hold(fig,'off');
S(1) = sum(n{1});
for i=2:length(valsDispSp)
    data = cell2mat(histRuns(:,i)');
    if (handles.nBins > 0)
        [n{i}, xout{i}] = hist(data,handles.nBins);
    else
        [n{i}, xout{i}] = hist(data,[0:max(data)]);
        maxD = max([maxD data]);
    end
    S(i) = sum(n{i});
    xall = union(xall,xout{i});
end

for i=1:length(valsDispSp)
    if (per == 0)
        S(i) = 1;
    end
    if (isempty(n{i}))
        h = bar(fig,0,0,'hist'); 
    else
        h = bar(fig,xout{i},n{i}./S(i),'hist'); 
    end
    set(h,'facecolor',cc(valsDispSp(i),:));
    hold(fig,'on');
end
if (handles.nBins == 0)
    xlim(fig,[-1 maxD+1]);
end
L = floor(min(xall));
U = upper(max(xall));
xTicks = L:round((U-L)/10):U;
set(fig,'XTick',xTicks);
set(fig,'XTickLabel',xTicks);
legend(fig,handles.DataHandles.Rules.AllNames(valsDispSp));
xlabel(fig,'Clone Size');
if (per == 0)
    ylabel(fig,'# of Clones');
else
    ylabel(fig,'% of Clones');
end
title(fig,['Clones Histogram (total of ' num2str(length(handles.DataHandles.Runs)) ' runs)']);


function plotPopulationSize(handles, figHandle)

DataHanldes = handles.DataHandles;
if (get(handles.checkboxAvg,'Value') == 1)
    drawBars = 1;
else
    drawBars = 0;
end

if (figHandle == 0)
    figure;
    figHandle = gca;
end

Tall = DataHanldes.RunsData.Tall;
M = DataHanldes.RunsData.Xall;
L = DataHanldes.RunsData.XallL;
U = DataHanldes.RunsData.XallU;
valsSp = get(DataHanldes.listboxPopSizeSp,'Value');
colors = DataHanldes.colors;
if (drawBars == 1)
    for i=1:length(valsSp)
        ind = valsSp(i);
        h(i) = errorbar(figHandle,Tall,M(:,ind),L(:,ind),U(:,ind),'Color',colors(ind,:),'LineWidth',1);
        hold(figHandle,'on');
        plot(figHandle,Tall,M(:,ind),'k','Color',(colors(ind,:))*0.75);
    end
else
    for i=1:length(valsSp)
        ind = valsSp(i);
        h(i) = plot(figHandle,Tall,M(:,ind),'k','Color',(colors(ind,:)));
        hold(figHandle,'on');
    end
end
xlabel(figHandle,'Time');
ylabel(figHandle,'Population Size');
legend(h,DataHanldes.Rules.AllNames(valsSp));
xlim(figHandle,[Tall(1) Tall(end)]);
if (drawBars == 1)
    title(figHandle, 'Average Population Size (error bars are Min/Max values over all runs)');
else
    title(figHandle, 'Average Population Size');
end
hold(figHandle,'off');


% --- Outputs from this function are returned to the command line.
function varargout = TimeBar_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function updateHistogram(handles,fig)
op = get(handles.listboxFigType,'Value');

if (fig == 1)
    fig = handles.axesBar;
else
    figure;
    fig = gca;
end
if (op == 1) % 'Clones Histogram'
    updateClonesHistogram(handles,fig);
end

if (op == 2) % 'Rules Histogram'
    updateRulesHistogram(handles,fig)
end

if (op == 3) % 'Internal States Histogram'
    updateISHistogram(handles,fig);
end

if (get(handles.checkboxAutoHist,'Value'))
    X = get(fig,'xlim');
    M = get(fig,'ylim');
    set(handles.editBins,'String',10);
    set(handles.editxmin,'String',X(1));
    set(handles.editxmax,'String',X(2));
    set(handles.editymin,'String',M(1));
    set(handles.editymax,'String',M(2));
end
set(fig,'xlim',[str2num(get(handles.editxmin,'String')) str2num(get(handles.editxmax,'String'))]);
set(fig,'ylim',[str2num(get(handles.editymin,'String')) str2num(get(handles.editymax,'String'))]);



% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
op = get(handles.listboxFigType,'Value');
if (op == 2)
    vals = get(handles.listbox1,'Value');
    mark = [];
    c = 1;
    for i=1:length(handles.DataHandles.Rules.Prod)
        len = length(handles.DataHandles.Rules.Prod{i}.StringSingle);
        if (ismember(i,vals))
            mark = [mark c:c+len-1];
        end
        c = c+len;
    end
    set(handles.listbox2,'Value',mark);
end

if (op == 3)
    val = get(handles.listbox1,'Value');
    set(handles.listbox2,'String',handles.DataHandles.Rules.Prod{val}.InternalStatesNames);
    set(handles.listbox2,'Value',1);
end

updateHistogram(handles,1);

function updateBarFigure(handles)
val = get(handles.sliderTime,'Value');
t = round(val*length(handles.Time));
if (t == 0)
    t = 1;
end
set(handles.textTime,'String',['Time: ' num2str(handles.Time(t))]);

i = get(handles.listbox1,'Value');
j = get(handles.listbox2,'Value');
numbins = str2num(get(handles.editBins,'String'));
[X,M] = handles.hFunc(handles.DataHandles,handles.Time(t),i,j,numbins);
bar(handles.axesBar,X,M);
if (get(handles.checkboxAutoHist,'Value'))
    set(handles.editxmin,'String',X(1));
    set(handles.editxmax,'String',X(end));
    set(handles.editymin,'String',min(M));
    set(handles.editymax,'String',max(M));
end
set(handles.axesBar,'xlim',[str2num(get(handles.editxmin,'String')) str2num(get(handles.editxmax,'String'))]);
set(handles.axesBar,'ylim',[str2num(get(handles.editymin,'String')) str2num(get(handles.editymax,'String'))]);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

updateHistogram(handles,1);

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderTime_Callback(hObject, eventdata, handles)
% hObject    handle to sliderTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = get(handles.sliderTime,'Value');
t = round(val*length(handles.Time));
if (t == 0)
    t = 1;
end
handles.selT = t;
set(handles.textTime,'String',['Time: ' num2str(handles.Time(t))]);
if (get(handles.checkboxLine,'Value') == 1)
    handles.XData = [handles.Time(t) handles.Time(t)];
    set(handles.hLine, 'XData', handles.XData);
    drawnow;
end

guidata(hObject, handles);
updateHistogram(handles,1);


% --- Executes during object creation, after setting all properties.
function sliderTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editBins_Callback(hObject, eventdata, handles)
% hObject    handle to editBins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBins as text
%        str2double(get(hObject,'String')) returns contents of editBins as a double
str = get(hObject,'String');
val = str2num(str);
if (isempty(val))
    set(hObject,'String',10);
else
    set(hObject,'String',round(val));
end
handles.nBins = str2num(get(hObject,'String'));
updateHistogram(handles,1);
guidata(hObject, handles);

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



function editymin_Callback(hObject, eventdata, handles)
% hObject    handle to editymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editymin as text
%        str2double(get(hObject,'String')) returns contents of editymin as a double
str = get(hObject,'String');
val = str2num(str);
if (isempty(val))
    set(hObject,'String',10);
else
    set(hObject,'String',val);
end
updateHistogram(handles,1);

% --- Executes during object creation, after setting all properties.
function editymin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editymax_Callback(hObject, eventdata, handles)
% hObject    handle to editymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editymax as text
%        str2double(get(hObject,'String')) returns contents of editymax as a double
str = get(hObject,'String');
val = str2num(str);
if (isempty(val))
    set(hObject,'String',10);
else
    set(hObject,'String',val);
end
updateHistogram(handles,1);

% --- Executes during object creation, after setting all properties.
function editymax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editxmax_Callback(hObject, eventdata, handles)
% hObject    handle to editxmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editxmax as text
%        str2double(get(hObject,'String')) returns contents of editxmax as a double
str = get(hObject,'String');
val = str2num(str);
if (isempty(val))
    set(hObject,'String',10);
else
    set(hObject,'String',val);
end
updateHistogram(handles,1);

% --- Executes during object creation, after setting all properties.
function editxmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editxmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editxmin_Callback(hObject, eventdata, handles)
% hObject    handle to editxmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editxmin as text
%        str2double(get(hObject,'String')) returns contents of editxmin as a double
str = get(hObject,'String');
val = str2num(str);
if (isempty(val))
    set(hObject,'String',10);
else
    set(hObject,'String',val);
end
updateHistogram(handles,1);

% --- Executes during object creation, after setting all properties.
function editxmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editxmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxAutoHist.
function checkboxAutoHist_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxAutoHist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxAutoHist
if (get(hObject,'Value') == 0)
    set(handles.editBins,'Enable','on');
    set(handles.editxmin,'Enable','on');
    set(handles.editxmax,'Enable','on');
    set(handles.editymin,'Enable','on');
    set(handles.editymax,'Enable','on');
    handles.nBins = str2num(get(handles.editBins,'String'));
else
    set(handles.editBins,'Enable','off');
    set(handles.editxmin,'Enable','off');
    set(handles.editxmax,'Enable','off');
    set(handles.editymin,'Enable','off');
    set(handles.editymax,'Enable','off');
    handles.nBins = 0;
end
updateHistogram(handles,1);
guidata(hObject, handles);

% --- Executes on selection change in listboxFigType.
function listboxFigType_Callback(hObject, eventdata, handles)
% hObject    handle to listboxFigType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxFigType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxFigType
op = get(handles.listboxFigType,'Value');

if (op == 1) % 'Clones Histogram'
    set(handles.text1,'String','Originating Species');
    set(handles.listbox1,'String', handles.DataHandles.Rules.StartNames);
    set(handles.listbox1,'Max',1);
    set(handles.listbox1,'Value',1);

    set(handles.text2,'String','Clones Types');
    set(handles.listbox2,'String', handles.DataHandles.Rules.AllNames);
    set(handles.listbox2,'Max',2);
    set(handles.listbox2,'Value',1);
end

if (op == 2) % 'Rules Histogram'
    set(handles.text1,'String','Species');
    set(handles.listbox1,'String', handles.DataHandles.Rules.StartNames);
    set(handles.listbox1,'Max',2);
    set(handles.listbox1,'Value',1:length(handles.DataHandles.Rules.StartNames));
    
    set(handles.text2,'String','Rules');
    list = handles.DataHandles.Rules.Prod{1}.StringSingle;
    for i=2:length(handles.DataHandles.Rules.Prod)
        list = [list handles.DataHandles.Rules.Prod{i}.StringSingle];
    end
    list = regexprep(list,'_[0-9\.]*','');
    list = regexprep(list,'->[0-9\.]*','->');
    set(handles.listbox2,'String', list);
    set(handles.listbox2,'Max',2);
    set(handles.listbox2,'Value',1:length(list));
end

if (op == 3) % 'Internal States Histogram'
    set(handles.text1,'String','Species');
    set(handles.listbox1,'String', handles.DataHandles.Rules.StartNames);
    set(handles.listbox1,'Max',1);
    set(handles.listbox1,'Value',1);
    
    set(handles.text2,'String','Internal States');
    set(handles.listbox2,'String',handles.DataHandles.Rules.Prod{1}.InternalStatesNames);
    set(handles.listbox2,'Max',1);
    set(handles.listbox2,'Value',1);
end

updateHistogram(handles,1);

% --- Executes during object creation, after setting all properties.
function listboxFigType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxFigType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listboxPopSizeSp.
function listboxPopSizeSp_Callback(hObject, eventdata, handles)
% hObject    handle to listboxPopSizeSp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxPopSizeSp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxPopSizeSp
plotPopulationSize(handles,handles.axesPopSize);
handles.hLine = line(handles.XData, handles.YData,'Color','k','LineWidth',5);
set(handles.hLine,'Parent',handles.axesPopSize);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listboxPopSizeSp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxPopSizeSp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxLine.
function checkboxLine_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxLine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxLine
if (get(handles.checkboxLine,'Value') == 1)
    handles.XData = [handles.Time(handles.selT) handles.Time(handles.selT)];
else
    handles.XData = [-1 -1];
end

set(handles.hLine, 'XData', handles.XData);
guidata(hObject, handles);

drawnow;


% --- Executes on button press in checkboxAvg.
function checkboxAvg_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxAvg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxAvg
plotPopulationSize(handles,handles.axesPopSize);    


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotPopulationSize(handles,0);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updateHistogram(handles,0);


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
updateHistogram(handles,1);
