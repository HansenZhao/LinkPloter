function varargout = LinkPloter(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LinkPloter_OpeningFcn, ...
                   'gui_OutputFcn',  @LinkPloter_OutputFcn, ...
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


% --- Executes just before LinkPloter is made visible.
function LinkPloter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LinkPloter (see VARARGIN)
disp('Hansen Zhao: zhaohs12@163.com');
disp('Department of Chemistry, Tsinghua University');
% Choose default command line output for LinkPloter
handles.output = hObject;
handles.controller = varargin{1};
varargin{1}.addAxes(handles.axes1,handles.axes2);
handles.curActiveAxes = 1;
handles.isHold = 0;
Tag1_Callback(handles.Tag1,[], handles)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LinkPloter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LinkPloter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in Lb_Region.
function Lb_Region_Callback(hObject, eventdata, handles)
% hObject    handle to Lb_Region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.controller.setVis(get(hObject,'Value'));
% Hints: contents = cellstr(get(hObject,'String')) returns Lb_Region contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Lb_Region


% --- Executes during object creation, after setting all properties.
function Lb_Region_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lb_Region (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Btn_Add.
function Btn_Add_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_Add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.controller.addRegion(handles.curActiveAxes,handles.isHold,get(handles.Lb_Region,'Value'));
set(handles.Lb_Region,'String',handles.controller.sList);
set(handles.cb_isHold,'Value',0);
handles.isHold = 0;
guidata(hObject,handles);


% --- Executes on button press in Btn_Clear.
function Btn_Clear_Callback(hObject, eventdata, handles)
% hObject    handle to Btn_Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.controller.clearRegion(get(handles.Lb_Region,'Value'));
set(handles.Lb_Region,'Value',1)
set(handles.Lb_Region,'String',handles.controller.sList);


% --- Executes on button press in Tag1.
function Tag1_Callback(hObject, eventdata, handles)
% hObject    handle to Tag1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.curActiveAxes = 1;
set(handles.axes1,'Color',LinkerController.ActiveBGColor);
set(handles.Tag1,'BackgroundColor',LinkerController.ActiveTag);
set(handles.axes2,'Color',LinkerController.DeActiveBGColor);
set(handles.Tag2,'BackgroundColor',LinkerController.DeActiveTag);
guidata(hObject, handles);


% --- Executes on button press in Tag2.
function Tag2_Callback(hObject, eventdata, handles)
% hObject    handle to Tag2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.curActiveAxes = 2;
set(handles.axes2,'Color',LinkerController.ActiveBGColor);
set(handles.Tag2,'BackgroundColor',LinkerController.ActiveTag);
set(handles.axes1,'Color',LinkerController.DeActiveBGColor);
set(handles.Tag1,'BackgroundColor',LinkerController.DeActiveTag);	
guidata(hObject, handles);


% --- Executes on button press in cb_showAll.
function cb_showAll_Callback(hObject, eventdata, handles)
% hObject    handle to cb_showAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_showAll
if get(hObject,'Value')
    handles.controller.setVis(-1);
else
    Lb_Region_Callback(handles.Lb_Region,1, handles)
end


% --- Executes on button press in cb_isHold.
function cb_isHold_Callback(hObject, eventdata, handles)
% hObject    handle to cb_isHold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.controller.sList)
    handles.isHold = get(hObject,'Value');
    guidata(hObject,handles);
else
    set(hObject,'Value',0);
end
% Hint: get(hObject,'Value') returns toggle state of cb_isHold


% --- Executes on key release with focus on figure1 and none of its controls.
function figure1_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case 'space'
        Btn_Add_Callback(handles.Btn_Add, [], handles);
    case 'a'
        handles.isHold = 1;
        set(handles.cb_isHold,'Value',1);
        guidata(hObject,handles);
        cb_isHold_Callback(handles.cb_isHold, [], handles);
        Btn_Add_Callback(handles.Btn_Add, [], handles);
    case 'c'
        Btn_Clear_Callback(handles.Btn_Clear, [], handles);
    case '1'
        Tag1_Callback(handles.Tag1, [], handles);
    case '2'
        Tag2_Callback(handles.Tag2, [], handles);
    case 'backquote'
        set(handles.cb_showAll,'Value',not(get(handles.cb_showAll,'Value')));
        cb_showAll_Callback(handles.cb_showAll,[], handles)
    otherwise
        disp(eventdata.Key);
end
