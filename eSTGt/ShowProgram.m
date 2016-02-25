function varargout = ShowProgram(varargin)
% SHOWPROGRAM MATLAB code for ShowProgram.fig
%      SHOWPROGRAM, by itself, creates a new SHOWPROGRAM or raises the existing
%      singleton*.
%
%      H = SHOWPROGRAM returns the handle to a new SHOWPROGRAM or the handle to
%      the existing singleton*.
%
%      SHOWPROGRAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOWPROGRAM.M with the given input arguments.
%
%      SHOWPROGRAM('Property','Value',...) creates a new SHOWPROGRAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ShowProgram_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ShowProgram_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ShowProgram

% Last Modified by GUIDE v2.5 06-Aug-2013 12:00:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ShowProgram_OpeningFcn, ...
                   'gui_OutputFcn',  @ShowProgram_OutputFcn, ...
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


% --- Executes just before ShowProgram is made visible.
function ShowProgram_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ShowProgram (see VARARGIN)

% Choose default command line output for ShowProgram
handles.output = hObject;
handles.ProgramString = varargin{1};

A =cellfun(@(x) [x ';' char(10)],handles.ProgramString,'UniformOutput',false);
str = horzcat(A{:});

set(handles.editProgram,'String',str);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ShowProgram wait for user response (see UIRESUME)
% uiwait(handles.figureProgram);


% --- Outputs from this function are returned to the command line.
function varargout = ShowProgram_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editProgram_Callback(hObject, eventdata, handles)
% hObject    handle to editProgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editProgram as text
%        str2double(get(hObject,'String')) returns contents of editProgram as a double


% --- Executes during object creation, after setting all properties.
function editProgram_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editProgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figureProgram is resized.
function figureProgram_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figureProgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Pos = get(handles.figureProgram,'Position');
set(handles.editProgram,'Position',[0 0 Pos(3) Pos(4)]);
