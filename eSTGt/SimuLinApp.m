function varargout = SimuLinApp(varargin)
% SIMULINAPP MATLAB code for SimuLinApp.fig
%      SIMULINAPP, by itself, creates a new SIMULINAPP or raises the existing
%      singleton*.
%
%      H = SIMULINAPP returns the handle to a new SIMULINAPP or the handle to
%      the existing singleton*.
%
%      SIMULINAPP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMULINAPP.M with the given input arguments.
%
%      SIMULINAPP('Property','Value',...) creates a new SIMULINAPP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SimuLinApp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SimuLinApp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SimuLinApp

% Last Modified by GUIDE v2.5 31-Jul-2014 12:37:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SimuLinApp_OpeningFcn, ...
                   'gui_OutputFcn',  @SimuLinApp_OutputFcn, ...
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


% --- Executes just before SimuLinApp is made visible.
function SimuLinApp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SimuLinApp (see VARARGIN)

% Choose default command line output for SimuLinApp
handles.output = hObject;
datacursormode(handles.output);
set(handles.uitableRules,'Data',{});
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SimuLinApp wait for user response (see UIRESUME)
% uiwait(handles.figureSimuLin);


% --- Outputs from this function are returned to the command line.
function varargout = SimuLinApp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Load_Rules_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Rules (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isfield(handles,'Runs'))
    choice = questdlg(['Loading new rules will erase existing session. Continue?'],'','Yes','No','No');
    if (strcmp(choice,'No'))
        return;
    end
end

[FileName,PathName] = uigetfile('*.xml','Select the Rules file');

if (FileName ~= 0)
    if (isfield(handles,'Runs'))
        handles = rmfield(handles,'Runs');
        handles = rmfield(handles,'RunsData');
        set(handles.listboxRunsAn,'String','');
        set(handles.listboxSpecies,'String','');
        set(handles.listboxTrees,'String','');
        cla(handles.axesPopSize,'reset');
    end
    
    Rules = ParseeSTGProgram([PathName FileName]);
    handles.colors=distinguishable_colors(100,'w');
    set(0,'DefaultAxesColorOrder',handles.colors);
    handles.Rules = Rules;
    handles.RunsData.Seeds = [];
    handles.RunsData.Tall = [];
    handles.RunsData.NumRuns = 0;
    handles.ProgramPathName = PathName;
    handles.ProgramFileName = FileName;
    
    updateRulesTable(handles);

    set(handles.buttonAdd,'Enable','on');
    set(handles.buttonDelete,'Enable','on');
    set(handles.buttonEdit,'Enable','on');
    set(handles.editSimTime,'Enable','on');
    
    set(handles.figureSimuLin, 'Name', ['eSTGt - Stochastic Simulator (' FileName ')']);
    
    guidata(hObject,handles);
end



function updateRulesTable(handles)

uCell = cell(length(handles.Rules.StartNames),4);
uCell(:,1) = handles.Rules.StartNames';
uCell(:,2) = cellfun(@(x) (x.String),handles.Rules.Prod, 'UniformOutput',false)';
uCell(:,3) = num2cell(ones(length(handles.Rules.StartNames),1)');

% check if time parameter exist
if (isfield(handles.Rules,'SimTime'))
    set(handles.editSimTime,'String',handles.Rules.SimTime);
end

% check if seed parameter exist
if (isfield(handles.Rules,'Seed'))
    set(handles.editSeed,'String',handles.Rules.Seed);
end

% check if initial population parameter exist
if (isfield(handles.Rules,'InitPop'))
    uCell(:,3) = num2cell(handles.Rules.InitPop(1:length(handles.Rules.StartNames)));
end

for i=1:length(handles.Rules.Prod)
   if (isfield(handles.Rules.Prod{i},'InternalStatesNames'))
       for j=1:length(handles.Rules.Prod{i}.InternalStatesNames) 
           Name = handles.Rules.Prod{i}.InternalStatesNames{j};
           uCell{i,4} = [uCell{i,4} Name '(' num2str(handles.Rules.Prod{i}.InternalStates.(Name).DupNum) '), '];
       end
       uCell{i,4} = uCell{i,4}(1:end-2);
   end
end
set(handles.uitableRules,'Data',uCell);

set(handles.editUpdateFunc,'String',func2str(handles.Rules.funcHandle));
set(handles.buttonRun,'Enable','on');
set(handles.buttonMultRun,'Enable','on');


function editSeed_Callback(hObject, eventdata, handles)
% hObject    handle to editSeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSeed as text
%        str2double(get(hObject,'String')) returns contents of editSeed as a double
str = get(hObject,'String');
num = str2num(str);
if isempty(num)
    set(hObject,'String','0');
else
    set(hObject,'String',round(num));
end


% --- Executes during object creation, after setting all properties.
function editSeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonRun.
function buttonRun_Callback(hObject, eventdata, handles)
% hObject    handle to buttonRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = runSim(handles);
guidata(hObject,handles);

function handles = runSim(handles)

switch get(get(handles.RadioGrpSeed,'SelectedObject'),'Tag')
    case 'radioRand', 
        seed = randi(1000000,1);
        while (ismember(seed,handles.RunsData.Seeds))
            seed = randi(1000000,1);
        end
        set(handles.editSeed,'String',seed);
    case 'radioNum', 
        seed = str2num(get(handles.editSeed,'String'));
        if (ismember(seed,handles.RunsData.Seeds))
            warndlg('Specified seed already exists!','','modal');
            return;
        end
end

s = RandStream('mcg16807','Seed',seed);
RandStream.setGlobalStream(s);

set(handles.buttonStop,'Enable','on');
set(handles.buttonRun,'Enable','off');
set(handles.buttonMultRun,'Enable','off');
set(handles.checkboxStop,'Value',0);

Rules = handles.Rules;
TimeSpan = [0 str2num(get(handles.editSimTime,'String'))];
updating_fcn = Rules.funcHandle;
handles.RunsData.NumRuns = handles.RunsData.NumRuns + 1;
NumRuns = handles.RunsData.NumRuns;
RunName = ['Run' num2str(NumRuns)];
OutputRun = RunSimuLin(Rules,Rules.InitPop,TimeSpan,updating_fcn,handles,RunName);
if (get(handles.checkboxStop,'Value') == 1)
    handles.RunsData.NumRuns = handles.RunsData.NumRuns - 1;
    return;
end

handles.Runs(NumRuns) = OutputRun;
[RunsDataTmp, RunsTmp] = updateSimRun(handles.RunsData, handles.Runs(NumRuns));
handles.RunsData = RunsDataTmp;
handles.Runs(NumRuns) = RunsTmp;

handles.RunsData.Seeds = [handles.RunsData.Seeds seed];
set(handles.editSimTime,'String',OutputRun.T(end));

handles = updateRun(handles);


function handles = updateRun(handles)
% add run to list of runs
list = cell(1,length(handles.Runs));
for i=1:length(handles.Runs)
    list{i} = handles.Runs(i).Name;
end
set(handles.listboxRunsAn,'String',list);
set(handles.listboxRunsAn,'Value',length(list));
set(handles.listboxSpecies,'String',handles.Rules.AllNames);
set(handles.listboxSpecies,'Value',1:length(handles.Rules.AllNames));

handles = updateListboxTrees(handles);

set(handles.pushPlotTrees,'Enable','on');
set(handles.checkboxView,'Enable','on');
set(handles.checkboxMerge,'Enable','on');

set(handles.buttonRun,'Enable','on');
set(handles.buttonMultRun,'Enable','on');
set(handles.buttonStop,'Enable','off');
set(handles.editSimTime,'Enable','inactive');
set(handles.editUpdateFunc,'Enable','inactive');
set(handles.buttonAdd,'Enable','off');
set(handles.buttonDelete,'Enable','off');
set(handles.buttonEdit,'Enable','off');
set(handles.matFileEx,'Enable','on');
set(handles.ExportTrees,'Enable','on');
set(handles.ExportInternalStates,'Enable','on');
plotPopulationSize(handles,0);

function handles = updateListboxTrees(handles)
valsRun = 1:length(get(handles.listboxRunsAn,'String'));
valsSp = 1:length(handles.Rules.StartNames);

c=1;
list = [];
listTreesInds = [];
for r=1:length(valsRun)
    valR = valsRun(r);
    for s=1:length(valsSp)
        valS = valsSp(s);
        for i=1:handles.Rules.InitPop(valS)
            name = [handles.Runs(valR).Name '_' handles.Rules.StartNames{valS} '_Tree' num2str(i)];
            list{c} = name;
            listTreesInds{c} = [valR valS i];
            c = c+1;
        end
    end
end

set(handles.listboxTrees,'String',list);
set(handles.listboxTrees,'Value',1:length(list));
handles.updateMergedPopTrees = 1;
handles.listTreesInds = listTreesInds;

function handles = updateSelectionListboxTrees(handles)

valsRun = get(handles.listboxRunsAn,'Value');
valsSp = get(handles.listboxSpecies,'Value');

c=1;
list = [];
listTreesIndsSel = [];
for r=1:length(valsRun)
    valR = valsRun(r);
    for s=1:length(valsSp)
        valS = valsSp(s);
        if (valS <= length(handles.Rules.InitPop))
            for i=1:handles.Rules.InitPop(valS)
                name = [handles.Runs(valR).Name '_' handles.Rules.StartNames{valS} '_Tree' num2str(i)];
                list{c} = name;
                listTreesIndsSel{c} = [valR valS i];
                c = c+1;
            end
        end    
    end
end

if (isempty(list))
    set(handles.listboxTrees,'Value',[]);
else
    [a b] = ismember(list',get(handles.listboxTrees,'String'));
    set(handles.listboxTrees,'Value',b);
end
handles.listTreesIndsSel = listTreesIndsSel;

% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function editSimTime_Callback(hObject, eventdata, handles)
% hObject    handle to editSimTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSimTime as text
%        str2double(get(hObject,'String')) returns contents of editSimTime as a double
str = get(hObject,'String');
num = str2num(str);
if isempty(num)
    set(hObject,'String','10');
else
    set(hObject,'String',num);
end




% --- Executes during object creation, after setting all properties.
function editSimTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSimTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function uitableRules_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitableRules (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when entered data in editable cell(s) in uitableRules.
function uitableRules_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitableRules (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

% update initial population size
if (eventdata.Indices(2) == 3)
    handles.Rules.InitPop(eventdata.Indices(1)) = eventdata.NewData;
end

guidata(hObject,handles);
    
% --- Executes during object creation, after setting all properties.
function radioNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radioNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function radioRand_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radioRand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function Plot_Generated_Trees_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Generated_Trees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listboxTrees.
function listboxTrees_Callback(hObject, eventdata, handles)
% hObject    handle to listboxTrees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxTrees contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxTrees
inds = get(hObject,'Value');
for i=1:length(inds)
    ind = inds(i);
    Node = handles.Runs(handles.listTreesInds{ind}(1)).Nodes{handles.listTreesInds{ind}(2)}(handles.listTreesInds{ind}(3));
    size(i) = getNumNodesTree(handles.Rules,handles.Runs(handles.listTreesInds{ind}(1)).NameInds,handles.Runs(handles.listTreesInds{ind}(1)).Nodes,Node);
end

set(handles.textStatus,'String',['Total # of nodes: ' num2str(sum(size))]);

% --- Executes during object creation, after setting all properties.
function listboxTrees_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxTrees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushPlotTrees.
function pushPlotTrees_Callback(hObject, eventdata, handles)
% hObject    handle to pushPlotTrees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inds = get(handles.listboxTrees,'value');

if (length(inds) > 10)
    choice = questdlg(['You have seleceted ' num2str(length(inds)) ' trees, plotting all of them may take some time. Continue with plotting?'],'','Yes','No','No');
    if (strcmp(choice,'No'))
        return;
    end
end

set(handles.textStatus,'String','Generating Trees...');
drawnow;

if (get(handles.checkboxView,'Value'))
    MergedTrees = cell(1,length(inds));
end
for i=1:length(inds)
    ind = inds(i);
    Node = handles.Runs(handles.listTreesInds{ind}(1)).Nodes{handles.listTreesInds{ind}(2)}(handles.listTreesInds{ind}(3));
    if (isfield(Node,'PhyTree') && ~isempty(Node.PhyTree))
        PhyTree = handles.Runs(handles.listTreesInds{ind}(1)).Nodes{handles.listTreesInds{ind}(2)}(handles.listTreesInds{ind}(3)).PhyTree;
    else
        PhyTree = generateTree(handles.Rules,handles.Runs(handles.listTreesInds{ind}(1)).Nodes,Node,handles.Runs(handles.listTreesInds{ind}(1)).NameInds,handles.Runs(handles.listTreesInds{ind}(1)).Name);
        handles.Runs(handles.listTreesInds{ind}(1)).Nodes{handles.listTreesInds{ind}(2)}(handles.listTreesInds{ind}(3)).PhyTree = PhyTree;
    end
    MergedTrees{i} = PhyTree;
    if (get(handles.checkboxMerge,'Value') == 0)
        if (get(handles.checkboxView,'Value'))
            view(PhyTree.tree);
        else
            if (~isempty(PhyTree.tree))
                plot_generated_tree(PhyTree.tree,handles.colors,handles.Rules.AllNames);
            end
        end
    end
end
if (get(handles.checkboxMerge,'Value'))
    MergedTree = MergeTrees(MergedTrees); 
    if (get(handles.checkboxView,'Value'))
        view(MergedTree.tree);
    else
        plot_generated_tree(MergedTree.tree,handles.colors,handles.Rules.AllNames);
    end
end

set(handles.textStatus,'String','Done');
drawnow;

guidata(hObject,handles);


function size = getNumNodesTree(Rules,NameInds,Nodes,Node)
if (length(Node.Children) == 0)
    size = 0;
    return;
end

if (length(Node.Children) == 1)
    if (Node.ChildrenType == 0)
        size = 1;
        return;
    end
end

type = Node.ChildrenType;
for rep=1:length(Node.Children)
    indChild(rep) = NameInds{type(rep)}.(Node.Children{rep});
end

if (length(Node.Children) == 1)
    Node1 = Nodes{type(1)}(indChild(1));
    size = getNumNodesTree(Rules,NameInds,Nodes,Node1);
end

if (length(Node.Children) == 2)
    Node1 = Nodes{type(1)}(indChild(1));
    size1 = getNumNodesTree(Rules,NameInds,Nodes,Node1);
    Node2 = Nodes{type(2)}(indChild(2));
    size2 = getNumNodesTree(Rules,NameInds,Nodes,Node2);
    size = size1+size2;
end


function MergedTree = MergeTrees(MergedTrees)
newick = MergedTrees{1}.Newick;
for i=2:length(MergedTrees)
    newick = ['(' newick ',' MergedTrees{i}.Newick ')DummyRoot' num2str(i-1) ':0'];
end
MergedTree.Newick = newick;
MergedTree.tree = phytreeread(newick);

% --- Executes on button press in pushPlotPopSize.
function pushPlotPopSize_Callback(hObject, eventdata, handles)
% hObject    handle to pushPlotPopSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

vals = get(handles.listboxRunsAn,'Value');
if (get(handles.checkboxPlotSep,'Value') || length(vals) == 1)
    for i=1:length(vals)
        val = vals(i);
        figure;plot(handles.Runs(val).T,handles.Runs(val).X);
        xlabel('Time');
        ylabel('Population Size');
        legend(handles.Rules.StartNames);
    end
else
    Tall = handles.RunsData.Tall;
    M = cumsum(handles.RunsData.Xalldiff)/length(handles.Runs);
    L = M-handles.RunsData.XallMin;
    U = handles.RunsData.XallMax-M;

    valsSp = get(handles.listboxSpecies,'Value');
    cc=hsv(size(M,2));
    figure;
    hold on;
    for i=1:length(valsSp)
        ind = valsSp(i);
        errorbar(Tall,M(:,ind),L(:,ind),U(:,ind),'Color',handles.colors(ind,:));
    end
    for i=1:length(valsSp)
        ind = valsSp(i);
        plot(Tall,M(:,ind),'k','Color',(handles.colors(ind,:))*0.75);
    end
    xlabel('Time');
    ylabel('Population Size');
    legend(handles.Rules.StartNames(valsSp));
    xlim([Tall(1) Tall(end)]);
    title('Average Population Size (error bars are Min/Max values over all runs)');
end



% --- Executes on button press in buttonStop.
function buttonStop_Callback(hObject, eventdata, handles)
% hObject    handle to buttonStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.buttonStop,'Enable','off');
set(handles.checkboxStop,'Value',1);
set(handles.textStatus,'String','Run Stopped');
drawnow;
set(handles.buttonRun,'Enable','on');
set(handles.buttonMultRun,'Enable','on');
set(handles.buttonStop,'Enable','off');

% --- Executes on button press in checkboxStop.
function checkboxStop_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxStop


% --- Executes on button press in buttonAdd.
function buttonAdd_Callback(hObject, eventdata, handles)
% hObject    handle to buttonAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in buttonDelete.
function buttonDelete_Callback(hObject, eventdata, handles)
% hObject    handle to buttonDelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (~isfield(handles,'Indices') || isempty(handles.Indices))
    warndlg('Please select a production rule.');
    return;
end

choice = questdlg(['Are you sure you want to delete the rule?'],'','Yes','No','No');
if (strcmp(choice,'No'))
    return;
end

handles.Rules.Prod(handles.Indices(1)) = [];
handles.Rules.InitPop(handles.Indices(1)) = [];
handles.Rules = prepareRules(handles.Rules);
updateRulesTable(handles);
guidata(hObject,handles);

% --- Executes on button press in buttonEdit.
function buttonEdit_Callback(hObject, eventdata, handles)
% hObject    handle to buttonEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (~isfield(handles,'Indices') || isempty(handles.Indices))
    warndlg('Please select a production rule.');
    return;
end

Output = RulesUpdate(handles);
Res = get(Output);
if (Res.UserData.Cancel == 0)
    handles.Rules = Res.UserData.DataHandles.Rules;
end
handles.Rules = prepareRules(handles.Rules);
updateRulesTable(handles);
guidata(hObject,handles);
delete(Output);

% --- Executes when selected cell(s) is changed in uitableRules.
function uitableRules_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitableRules (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
handles.Indices = eventdata.Indices;
guidata(hObject,handles);

% --- Executes when figureSimuLin is resized.
function figureSimuLin_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figureSimuLin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in buttonDelRun.
function buttonDelRun_Callback(hObject, eventdata, handles)
% hObject    handle to buttonDelRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function RunMenu_Callback(hObject, eventdata, handles)
% hObject    handle to RunMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Run_Single_Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run_Single_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushAnalyzeTrees.
function pushAnalyzeTrees_Callback(hObject, eventdata, handles)
% hObject    handle to pushAnalyzeTrees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = getMergedPopTrees(handles);
guidata(hObject,handles);
TimeHist(handles.Tall,handles.PopTreesHistData,handles.Rules.AllNames);

function handles = getMergedPopTrees(handles)



if (handles.updateMergedPopTrees == 0)
    return;
end
inds = 1:length(get(handles.listboxTrees,'String'));
vec = [];
for i=1:length(inds)
    ind = inds(i);
    K = cell2mat(handles.listTreesInds(ind)');
    K = K(2:3);
    I = find(ismember(handles.Runs(handles.listTreesInds{ind}(1)).Id,K,'rows'));
    res = count_unique(K(:,1));
    stoch{i} = handles.Rules.stoich_matrix(handles.Runs(handles.listTreesInds{ind}(1)).R(I),:);
    T{i} = [handles.Runs(handles.listTreesInds{ind}(1)).T(I)];
    vec = [vec; repmat(i,length(I),1)];
end

[Tall b] = sort(cell2mat(T'));

for i=1:length(inds)
    stoch_all{i} = zeros(length(Tall),size(handles.Rules.stoich_matrix,2));
    stoch_all{i}(vec(b)==i,:) = stoch{i};
    A = zeros(1,size(stoch{i},2));
    A(handles.listTreesInds{inds(i)}(2)) = 1;
    stoch_all{i} = [A; stoch_all{i}];
    PopTrees{i} = cumsum(stoch_all{i});
end

handles.Tall = [0; Tall];
handles.PopTrees = PopTrees;


for j=1:length(handles.Rules.AllNames)
    PopTreesHistData(:,j) = mat2cell(cell2mat(cellfun(@(x) x(:,j),PopTrees,'UniformOutput',false)),ones(size(PopTrees{1},1),1),size(PopTrees,2));
end
handles.PopTreesHistData = PopTreesHistData;
handles.updateMergedPopTrees = 0;



% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_Rules_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Rules (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
docNode = com.mathworks.xml.XMLUtils.createDocument('Program');

ExecParams = docNode.createElement('ExecParams');
docNode.getDocumentElement.appendChild(ExecParams);


SimTime = CreateXMLNode(docNode,'SimTime',num2str(handles.Rules.SimTime));
ExecParams.appendChild(SimTime);

Seed = CreateXMLNode(docNode,'Seed',num2str(get(handles.editSeed,'String')));
ExecParams.appendChild(Seed);

FunHandleName = CreateXMLNode(docNode,'FunHandleName',get(handles.editUpdateFunc,'String'));
docNode.getDocumentElement.appendChild(FunHandleName);

for i=1:length(handles.Rules)
    Rule = docNode.createElement('Rule');
    docNode.getDocumentElement.appendChild(Rule);
    Prod = CreateXMLNode(docNode,'Prod',handles.Rules.Prod{i}.String);
    ExecParams.appendChild(Prod);
end



xmlwrite('tmp.xml',docNode);

function Node = CreateXMLNode(docNode,Name,Val)
Node = docNode.createElement(Name);
Node_Val = docNode.createTextNode(Val);
Node.appendChild(Node_Val);


% --------------------------------------------------------------------
function Export_Callback(hObject, eventdata, handles)
% hObject    handle to Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SimBiologyEx_Callback(hObject, eventdata, handles)
% hObject    handle to SimBiologyEx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SBMLEx_Callback(hObject, eventdata, handles)
% hObject    handle to SBMLEx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listboxRunsAn.
function listboxRunsAn_Callback(hObject, eventdata, handles)
% hObject    handle to listboxRunsAn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxRunsAn contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxRunsAn
handles = updateSelectionListboxTrees(handles);

inds = get(handles.listboxTrees,'Value');
for i=1:length(inds)
    ind = inds(i);
    Node = handles.Runs(handles.listTreesInds{ind}(1)).Nodes{handles.listTreesInds{ind}(2)}(handles.listTreesInds{ind}(3));
    size(i) = getNumNodesTree(handles.Rules,handles.Runs(handles.listTreesInds{ind}(1)).NameInds,handles.Runs(handles.listTreesInds{ind}(1)).Nodes,Node);
end

set(handles.textStatus,'String',['Total # of nodes: ' num2str(sum(size))]);

plotPopulationSize(handles,0);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function listboxRunsAn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxRunsAn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listboxSpecies.
function listboxSpecies_Callback(hObject, eventdata, handles)
% hObject    handle to listboxSpecies (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxSpecies contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxSpecies
handles = updateSelectionListboxTrees(handles);

inds = get(handles.listboxTrees,'Value');
size = 0;
for i=1:length(inds)
    ind = inds(i);
    Node = handles.Runs(handles.listTreesInds{ind}(1)).Nodes{handles.listTreesInds{ind}(2)}(handles.listTreesInds{ind}(3));
    size(i) = getNumNodesTree(handles.Rules,handles.Runs(handles.listTreesInds{ind}(1)).NameInds,handles.Runs(handles.listTreesInds{ind}(1)).Nodes,Node);
end

set(handles.textStatus,'String',['Total # of nodes: ' num2str(sum(size))]);


plotPopulationSize(handles,0);
guidata(hObject,handles);

function updateSelectionListboxIntStates(handles)

vals = [];
c = 1;
valsSp = get(handles.listboxSpecies,'Value');
for i=1:length(handles.Rules.Prod)
    len = length(handles.Rules.Prod{i}.InternalStatesNames);
    if (ismember(i,valsSp))
        vals = [vals c:(c+len-1)];
    end
    c = c+len;
end
set(handles.listboxIntStates,'Value',vals);

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


% --------------------------------------------------------------------
function matFileEx_Callback(hObject, eventdata, handles)
% hObject    handle to matFileEx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = datestr(clock,'dd_mmm_yyyy_HH_MM_SS');
filestr = ['SimuLin_' str];

[filename, pathname] = uiputfile({'*.mat','MATLAB Data Files (*.mat)'},'Save Data File',filestr);

if (filename ~= 0)
    set(handles.textStatus,'String','Saving Data...');
    drawnow;
    Rules = handles.Rules;
    RunsData = handles.RunsData;
    Runs = handles.Runs;
    save([pathname filename],'Rules','RunsData','Runs','-v7.3');
    set(handles.textStatus,'String','Finished Saving Data');
    drawnow;
end


% --- Executes on button press in pushViewTrees.
function pushViewTrees_Callback(hObject, eventdata, handles)
% hObject    handle to pushViewTrees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkboxView.
function checkboxView_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxView (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxView


% --- Executes on button press in checkboxMerge.
function checkboxMerge_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxMerge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxMerge


% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function editUpdateFunc_Callback(hObject, eventdata, handles)
% hObject    handle to editUpdateFunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editUpdateFunc as text
%        str2double(get(hObject,'String')) returns contents of editUpdateFunc as a double


% --- Executes during object creation, after setting all properties.
function editUpdateFunc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editUpdateFunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonUpdateFunc.
function buttonUpdateFunc_Callback(hObject, eventdata, handles)
% hObject    handle to buttonUpdateFunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
edit([handles.ProgramPathName '/' get(handles.editUpdateFunc,'String')]);

% --- Executes on button press in buttonMultRun.
function buttonMultRun_Callback(hObject, eventdata, handles)
% hObject    handle to buttonMultRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer = inputdlg('Enter # of runs to execute:','Multiple Runs',1,{'10'});
if (~isempty(answer))
    num = str2num(answer{1});
    if (isempty(num))
        errordlg('Please enter a numeric value','');
    else
        set(handles.radioRand,'Value',1);
        for i=1:num
            handles = runSim(handles);
            guidata(hObject,handles);
            drawnow;
            if (get(handles.checkboxStop,'Value') == 1)
                return;
            end
        end
    end
end


% --- Executes on button press in checkboxPlotSep.
function checkboxPlotSep_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxPlotSep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxPlotSep


% --- Executes on selection change in listboxIntStates.
function listboxIntStates_Callback(hObject, eventdata, handles)
% hObject    handle to listboxIntStates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxIntStates contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxIntStates


% --- Executes during object creation, after setting all properties.
function listboxIntStates_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxIntStates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

 
function [X,M] = getHistInternalStates(handles,t,i,j,numbins)

histMap = cell(length(handles.Runs),1);
for r=1:length(handles.Runs)
    ind = find(handles.Runs(r).T>=t,1,'first');
    if (isempty(ind))
        ind = length(handles.Runs(r).T);
    end
    liveinds = handles.Runs(r).LiveNodes{ind,i};
    A=handles.Runs(r).Nodes{i}(liveinds);
    vals = [];
    for k=1:length(A) 
        vals{k} = A{k}.InternalStates.(handles.Rules.Prod{i}.InternalStatesNames{j}); 
    end
    histMap{r} = cell2mat(vals);
end   
histMapNE = histMap;
histMapNE(cellfun(@isempty,histMap)) = [];
MI = min(cellfun(@min,histMapNE));
MA = max(cellfun(@max,histMapNE));
X = [MI:(MA-MI)/numbins:MA];
if (isempty(X))
    X = [MI-1 MI MI+1];
end
for r=1:length(handles.Runs)
    [a{r} b{r}] = hist(histMap{r},X);
end
M = mean(cell2mat(a'));

% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Import_Callback(hObject, eventdata, handles)
% hObject    handle to Import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function matFileIm_Callback(hObject, eventdata, handles)
% hObject    handle to matFileIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select MATLAB data file');
handles.colors=distinguishable_colors(100,'w');
set(handles.textStatus,'String','Loading Data...');
drawnow;
load([PathName FileName]);
handles.Runs = Runs;
handles.RunsData = RunsData;
handles.Rules = Rules;
clear Runs RunsData Rules;

updateRulesTable(handles);
handles = updateRun(handles);
set(handles.textStatus,'String','Finished Loading');
drawnow;
guidata(hObject,handles);


% --------------------------------------------------------------------
function SimBiologyIm_Callback(hObject, eventdata, handles)
% hObject    handle to SimBiologyIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SBMLExIm_Callback(hObject, eventdata, handles)
% hObject    handle to SBMLExIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbuttonAllRuns.
function pushbuttonAllRuns_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonAllRuns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isfield(handles,'Runs'))
    TimeBar(handles);
end

% --- Executes on button press in pushbuttonPlotMultRuns.
function pushbuttonPlotMultRuns_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlotMultRuns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotPopulationSize(handles,1);


% --- Executes on button press in pushbuttonProgram.
function pushbuttonProgram_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonProgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ShowProgram(handles.Rules.ProgramString);


% --------------------------------------------------------------------
function ExportTrees_Callback(hObject, eventdata, handles)
% hObject    handle to ExportTrees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

folder_name = uigetdir;

Names = get(handles.listboxTrees,'String');
%inds = get(handles.listboxTrees,'value');
inds = 1:length(Names);

MergedTrees = cell(1,length(inds));

for i=1:length(inds)
    set(handles.textStatus,'String',['Generating Tree ' num2str(i) '/' num2str(length(inds))]);
    drawnow;
    
    ind = inds(i);
    Node = handles.Runs(handles.listTreesInds{ind}(1)).Nodes{handles.listTreesInds{ind}(2)}(handles.listTreesInds{ind}(3));
    if (isfield(Node,'PhyTree') && ~isempty(Node.PhyTree))
        PhyTree = handles.Runs(handles.listTreesInds{ind}(1)).Nodes{handles.listTreesInds{ind}(2)}(handles.listTreesInds{ind}(3)).PhyTree;
    else
        PhyTree = generateTree(handles.Rules,handles.Runs(handles.listTreesInds{ind}(1)).Nodes,Node,handles.Runs(handles.listTreesInds{ind}(1)).NameInds,handles.Runs(handles.listTreesInds{ind}(1)).Name);
        handles.Runs(handles.listTreesInds{ind}(1)).Nodes{handles.listTreesInds{ind}(2)}(handles.listTreesInds{ind}(3)).PhyTree = PhyTree;
    end
    MergedTrees{i} = PhyTree;
    if (get(handles.checkboxMerge,'Value') == 0)
        phytreewrite([folder_name '/' Names{ind} '_Seed_' num2str(handles.RunsData.Seeds(handles.listTreesInds{ind}(1))) '.Newick' ],PhyTree.tree);
    end
    
end
if (get(handles.checkboxMerge,'Value'))
    MergedTree = MergeTrees(MergedTrees); 
    phytreewrite([folder_name '/MergedTrees.Newick' ],PhyTree.tree);
end

set(handles.textStatus,'String','Done');


% --------------------------------------------------------------------
function ExportInternalStates_Callback(hObject, eventdata, handles)
% hObject    handle to ExportInternalStates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

folder_name = uigetdir;

% for each Run
for run = 1:length(handles.Runs)
    % for each node type
    for type = 1:length(handles.Runs(1).Nodes)
        % for each Internal state
        ISNames = fieldnames(handles.Runs(run).Nodes{type}(1).InternalStates);
        for is = 1:length(ISNames)
            % go over all nodes and add the IS
            Table.(ISNames{is}) = [];
            Fname = [folder_name '/Run' num2str(run) '_Seed_' num2str(handles.RunsData.Seeds(run)) '_' handles.Rules.AllNames{type}];
            fp = fopen([Fname  '_Names.txt'],'wt');
            for node=1:length(handles.Runs(run).Nodes{type})
                Table.(ISNames{is}) = [Table.(ISNames{is}); handles.Runs(run).Nodes{type}(node).InternalStates.(ISNames{is})];
                fprintf(fp,'%s\n',handles.Runs(run).Nodes{type}(node).Name);
            end
            fclose(fp);
            
            dlmwrite([Fname '_' ISNames{is} '_Values.txt'],Table.(ISNames{is}));
        end
    end
end


set(handles.textStatus,'String','Done');
