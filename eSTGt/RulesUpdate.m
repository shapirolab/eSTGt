function varargout = RulesUpdate(varargin)
% RULESUPDATE MATLAB code for RulesUpdate.fig
%      RULESUPDATE, by itself, creates a new RULESUPDATE or raises the existing
%      singleton*.
%
%      H = RULESUPDATE returns the handle to a new RULESUPDATE or the handle to
%      the existing singleton*.
%
%      RULESUPDATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RULESUPDATE.M with the given input arguments.
%
%      RULESUPDATE('Property','Value',...) creates a new RULESUPDATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RulesUpdate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RulesUpdate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RulesUpdate

% Last Modified by GUIDE v2.5 24-Jul-2013 14:51:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RulesUpdate_OpeningFcn, ...
                   'gui_OutputFcn',  @RulesUpdate_OutputFcn, ...
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


% --- Executes just before RulesUpdate is made visible.
function RulesUpdate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RulesUpdate (see VARARGIN)

% Choose default command line output for RulesUpdate
handles.output = hObject;
handles.DataHandles = varargin{1};
updateTables(handles);
handles.Cancel = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RulesUpdate wait for user response (see UIRESUME)
uiwait(handles.figureRule);

function updateTables(handles)
ind = handles.DataHandles.Indices(1);
set(handles.editSource,'String',handles.DataHandles.Rules.Prod{ind}.Start);
set(handles.editRate,'String',handles.DataHandles.Rules.Prod{ind}.Rate);
set(handles.editSize,'String',handles.DataHandles.Rules.InitPop(ind));
for i=1:length(handles.DataHandles.Rules.Prod{ind}.End)
    for j=1:length(handles.DataHandles.Rules.Prod{ind}.End{i})
        uCell{i,j} = handles.DataHandles.Rules.Prod{ind}.End{i}{j};
    end
    uCell{i,3} = handles.DataHandles.Rules.Prod{ind}.Probs(i);
end
set(handles.uitableProds,'Data',uCell);

clear uCell;
uCell = {};
if (~isempty(handles.DataHandles.Rules.Prod{ind}.InternalStatesNames))
    for i=1:length(handles.DataHandles.Rules.Prod{ind}.InternalStatesNames)
        uCell{i,1} = handles.DataHandles.Rules.Prod{ind}.InternalStatesNames{i};
        uCell{i,2} = handles.DataHandles.Rules.Prod{ind}.InternalStates.(handles.DataHandles.Rules.Prod{ind}.InternalStatesNames{i}).DupNum;
        uCell{i,3} = handles.DataHandles.Rules.Prod{ind}.InternalStates.(handles.DataHandles.Rules.Prod{ind}.InternalStatesNames{i}).InitVal;
        uCell{i,4} = func2str(handles.DataHandles.Rules.Prod{ind}.InternalStates.(handles.DataHandles.Rules.Prod{ind}.InternalStatesNames{i}).hFunc);
    end
end
set(handles.uitableIS,'Data',uCell);

% --- Outputs from this function are returned to the command line.
function varargout = RulesUpdate_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
set(handles.output,'UserData',handles);
varargout{1} = handles.output;

function editSource_Callback(hObject, eventdata, handles)
% hObject    handle to editSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSource as text
%        str2double(get(hObject,'String')) returns contents of editSource as a double


% --- Executes during object creation, after setting all properties.
function editSource_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSource (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRate_Callback(hObject, eventdata, handles)
% hObject    handle to editRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRate as text
%        str2double(get(hObject,'String')) returns contents of editRate as a double
str = get(hObject,'String');
num = str2num(str);
if isempty(num)
    set(hObject,'String','0');
end

% --- Executes during object creation, after setting all properties.
function editRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSize_Callback(hObject, eventdata, handles)
% hObject    handle to editSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSize as text
%        str2double(get(hObject,'String')) returns contents of editSize as a double
str = get(hObject,'String');
num = str2num(str);
if isempty(num)
    set(hObject,'String','0');
else
    set(hObject,'String',round(num));
end


% --- Executes during object creation, after setting all properties.
function editSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonFinish.
function pushbuttonFinish_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonFinish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = handles.DataHandles.Indices(1);
handles.DataHandles.Rules.Prod{ind}.Start = get(handles.editSource,'String');
handles.DataHandles.Rules.Prod{ind}.Rate = str2num(get(handles.editRate,'String'));
handles.DataHandles.Rules.InitPop(ind) = str2num(get(handles.editSize,'String'));

uCell = get(handles.uitableProds,'Data');
handles.DataHandles.Rules.Prod{ind}.Probs = cell2mat(uCell(:,3))';
if (sum(handles.DataHandles.Rules.Prod{ind}.Probs) ~= 1)
    warndlg('Probabilities should sum to 1');
    return;
end

prodEmpty = sum(cellfun(@isempty,uCell));
if (prodEmpty(1) + prodEmpty(3) > 0)
    warndlg('There is an empty data in the production table');
    return;
end

RuleStr = [get(handles.editSource,'String') '->' num2str(get(handles.editRate,'String'))];
for i=1:size(uCell,1)
    if (isempty(uCell{i,2}))
        RuleStr = [RuleStr '{' uCell{i,1} '}_' num2str(uCell{i,3})];
    else
        RuleStr = [RuleStr '{' uCell{i,1} ',' uCell{i,2} '}_' num2str(uCell{i,3})];
    end
    RuleStr = [RuleStr '|'];
end
RuleStr = RuleStr(1:end-1);

Rule = parseRule(RuleStr);

uCell = get(handles.uitableIS,'Data');
prodEmpty = sum(sum(cellfun(@isempty,uCell)));
if (prodEmpty > 0)
    warndlg('There is an empty data in the Internal States table');
    return;
end


Rule.InternalStates = struct;
Rule.InternalStatesNames = {};
if (~isempty(uCell))
    Rule.InternalStatesNames = uCell(:,1);
    for i=1:length(Rule.InternalStatesNames)
        name = Rule.InternalStatesNames{i};
        Rule.InternalStates.(name).DupNum = uCell{i,2};
        Rule.InternalStates.(name).InitVal = uCell{i,3};
        Rule.InternalStates.(name).hFunc = str2func(uCell{i,4});
    end
end

handles.DataHandles.Rules.Prod{ind} = Rule;
guidata(hObject, handles);

uiresume(handles.figureRule);

% --- Executes on button press in pushbuttonCancel.
function pushbuttonCancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Cancel = 1;
guidata(hObject, handles);
uiresume(handles.figureRule);

% --- Executes on button press in pushbuttonEditFunc.
function pushbuttonEditFunc_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonEditFunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (~isfield(handles,'IndicesIS'))
    warndlg('Please select Internal State.');
    return;
end
uCell = get(handles.uitableIS,'Data');
edit(uCell{handles.IndicesIS(1),4});

% --- Executes when entered data in editable cell(s) in uitableProds.
function uitableProds_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitableProds (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
uCell = get(hObject,'Data');
uCell{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.EditData;

if (eventdata.Indices(2) == 3)
    if (~isnumeric(eventdata.EditData))
        num = str2num(eventdata.EditData);
        if isempty(num)
            num = eventdata.PreviousData;
        end
    else
        num = eventdata.EditData;
    end
    num = max(min(num,1),0);
    uCell{eventdata.Indices(1),eventdata.Indices(2)} = num;
end

if (eventdata.Indices(2) == 2)
    if (strcmp(eventdata.EditData,'0') == 1)
        warndlg('''0'' Indicates a death transition and can be only defined in Target Name #1');
        uCell{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.PreviousData;
    end
end

if (eventdata.Indices(2) == 1)
    if (strcmp(eventdata.EditData,'0') == 1)
        if (ismember(eventdata.EditData,uCell(setdiff(1:end,eventdata.Indices(1)),1)))
            warndlg('''0'' Indicates a death transition and can be only defined once');
        end
        uCell{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.PreviousData;
    end
end

set(hObject,'Data',uCell);


% --- Executes when entered data in editable cell(s) in uitableIS.
function uitableIS_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitableIS (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
uCell = get(hObject,'Data');
num = str2num(eventdata.EditData);
if (isempty(num))
    uCell{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.EditData;
else
    uCell{eventdata.Indices(1),eventdata.Indices(2)} = num;
end
if (eventdata.Indices(2) == 2)
    if (isempty(num) || num <= 0.5)
        uCell{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.PreviousData;
    else
        uCell{eventdata.Indices(1),eventdata.Indices(2)} = round(num);
    end
end

if (eventdata.Indices(2) == 1)
    if (~isempty(num))
        warndlg('Name of Internal State cannot be a number');
        uCell{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.PreviousData;
    elseif (ismember(eventdata.EditData,uCell(setdiff(1:end,eventdata.Indices(1)),1)))
        warndlg('Name already exist');
        uCell{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.PreviousData;
    end
end

set(hObject,'Data',uCell);


% --- Executes when selected cell(s) is changed in uitableIS.
function uitableIS_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitableIS (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
handles.IndicesIS = eventdata.Indices;
guidata(hObject, handles);


% --- Executes on button press in pushbuttonAddIS.
function pushbuttonAddIS_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonAddIS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uCell = get(handles.uitableIS,'Data');

uCell(size(uCell,1)+1,4) = {[]};

set(handles.uitableIS,'Data',uCell);

% --- Executes on button press in pushbuttonDelIS.
function pushbuttonDelIS_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDelIS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (~isfield(handles,'IndicesIS') || isempty(handles.IndicesIS))
    warndlg('Please select an Internal State');
    return;
end

uCell = get(handles.uitableIS,'Data');
uCell(handles.IndicesIS(1),:) = [];
set(handles.uitableIS,'Data',uCell);


% --- Executes on button press in pushbuttonAddProd.
function pushbuttonAddProd_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonAddProd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uCell = get(handles.uitableProds,'Data');

uCell(size(uCell,1)+1,3) = {[]};

set(handles.uitableProds,'Data',uCell);

% --- Executes on button press in pushbuttonDelProd.
function pushbuttonDelProd_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonDelProd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (~isfield(handles,'uitableProds') || isempty(handles.uitableProds))
    warndlg('Please select a production rule');
    return;
end

uCell = get(handles.uitableProds,'Data');
uCell(handles.IndicesProd(1),:) = [];
set(handles.uitableProds,'Data',uCell);

% --- Executes when user attempts to close figureRule.
function figureRule_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figureRule (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
handles.Cancel = 1;
guidata(hObject, handles);
uiresume(handles.figureRule);


% --- Executes when selected cell(s) is changed in uitableProds.
function uitableProds_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitableProds (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
handles.IndicesProd = eventdata.Indices;
guidata(hObject, handles);
