function varargout = Set(varargin)
% SET MATLAB code for Set.fig
%      SET, by itself, creates a new SET or raises the existing
%      singleton*.
%
%      H = SET returns the handle to a new SET or the handle to
%      the existing singleton*.
%
%      SET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SET.M with the given input arguments.
%
%      SET('Property','Value',...) creates a new SET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Set_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Set_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Set

% Last Modified by GUIDE v2.5 04-Dec-2017 21:22:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Set_OpeningFcn, ...
                   'gui_OutputFcn',  @Set_OutputFcn, ...
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


% --- Executes just before Set is made visible.
function Set_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Set (see VARARGIN)

% Choose default command line output for Set
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% 保存时保留背景色
set(gcf,'inverthardcopy','off')

% 设置初值
handles.base_sig = varargin{1};
handles.err_val = varargin{2};
guidata(hObject,handles);

% 修改控件显示初始值
fcn_set_val = @(h,v) set(h,'value',v);
% 16位基带数据
arrayfun(fcn_set_val,handles.base,fliplr(handles.base_sig));
% 每组7个开关
arrayfun(fcn_set_val,handles.e1,fliplr(handles.err_val(1:7)));
arrayfun(fcn_set_val,handles.e2,fliplr(handles.err_val(8:14)));
arrayfun(fcn_set_val,handles.e3,fliplr(handles.err_val(15:21)));
arrayfun(fcn_set_val,handles.e4,fliplr(handles.err_val(22:28)));

% UIWAIT makes Set wait for user response (see UIRESUME)
% uiwait(handles.figure_set);
uiwait(handles.figure_set);

% --- Outputs from this function are returned to the command line.
function varargout = Set_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% 设置两个输出参数为基带信号和加错开关值
varargout{1} = handles.base_sig;
varargout{2} = handles.err_val;
delete(hObject);

% --- Executes on button press in e4.
function e4_Callback(hObject, eventdata, handles)
% hObject    handle to e4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of e4


% --- Executes on button press in e3.
function e3_Callback(hObject, eventdata, handles)
% hObject    handle to e3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of e3


% --- Executes on button press in e2.
function e2_Callback(hObject, eventdata, handles)
% hObject    handle to e2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of e2


% --- Executes on button press in e1.
function e1_Callback(hObject, eventdata, handles)
% hObject    handle to e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of e1


% --- Executes on button press in base.
function base_Callback(hObject, eventdata, handles)
% hObject    handle to base (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of base


% --- Executes on button press in pushbutton_ok.
function pushbutton_ok_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 获取基带数据
% 需要上下翻转一次才为P0-P15
base_sig = flipud(get(handles.base,'value'));
% 获取加错开关
% 同样需要翻转一次
err_val = [flipud(get(handles.e1,'value'));flipud(get(handles.e2,'value'));...
           flipud(get(handles.e3,'value'));flipud(get(handles.e4,'value'))];
% 打开元胞并存入handles
handles.base_sig = arrayfun(@cell2mat,base_sig');
handles.err_val = arrayfun(@cell2mat,err_val');
guidata(hObject,handles);
uiresume(handles.figure_set);

% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure_set);


% --- Executes on selection change in c1.
function c1_Callback(hObject, eventdata, handles)
% hObject    handle to c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns c1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from c1


% --- Executes during object creation, after setting all properties.
function c1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in c2.
function c2_Callback(hObject, eventdata, handles)
% hObject    handle to c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns c2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from c2


% --- Executes during object creation, after setting all properties.
function c2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure_set.
function figure_set_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(hObject);


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 保存图片
global pic_no_set;
try
    saveas(gcf,['.\\Pic_Set',num2str(pic_no_set),'.png']);
    pic_no_set = pic_no_set + 1;
    msgbox('图片保存成功！');
catch
    msgbox('图片保存失败！');
end
