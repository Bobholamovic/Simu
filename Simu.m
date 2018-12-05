function varargout = Simu(varargin)
% SIMU MATLAB code for Simu.fig
%      SIMU, by itself, creates a new SIMU or raises the existing
%      singleton*.
%
%      H = SIMU returns the handle to a new SIMU or the handle to
%      the existing singleton*.
%
%      SIMU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMU.M with the given input arguments.
%
%      SIMU('Property','Value',...) creates a new SIMU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Simu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Simu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Simu

% Last Modified by GUIDE v2.5 14-Dec-2017 13:59:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Simu_OpeningFcn, ...
                   'gui_OutputFcn',  @Simu_OutputFcn, ...
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


% --- Executes just before Simu is made visible.
function Simu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Simu (see VARARGIN)

% Choose default command line output for Simu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% % 清空上次图片
% !del /q PIC_SET?.png
% !del /q PIC_MAIN?.png

% 保存时保留背景色
set(gcf,'inverthardcopy','off')

% 定义常量，初始化变量
% 帧头
global FH
FH = [0,1,1,1,1,1,1,0];
% 当前选择的波形图类型
global pt;
% 时钟脉冲宽度（可用于调节绘图精度）
global ELA;
% 当前主界面图片编号
global pic_no_main;
% 当前设置界面图片编号
global pic_no_set;

pt = [1,1];
ELA = 50;
pic_no_main = 0;
pic_no_set = 0;

%
% 为模拟示波器，实现不同坐标轴横坐标（时间）同步，即刻度完全对正
% 只需保证坐标轴范围和取点间隔完全相同
% 不同坐标轴取点间隔均为1（默认），为使得坐标轴范围内全部填充波形
% 需不断重复周期直到满屏
% 当前坐标轴所需重复的周期数=可显示最大点数（因为间隔是1）/一个周期点数
% 可显示最大点数与初始设置值和当前放大比例有关
% 一个周期点数 = 当前信号码元脉宽*一周期内码元总数
%
% 最大屏幕宽度（最大点数）
global width;
% 屏幕宽度初始值
global WIDTH_INIT;

% 时钟速率设置部分可拓展
% 基带时钟波特率（K）
base_clock = 32;
% 编码时钟波特率（K）
enc_clock = 64;
% 不带帧头编码信号长度
% 由于为（7,4)汉明码或循环码，基带数据为16位，4*7=28
enc_len = 28*enc_clock/base_clock;
% 初始最大码元数设置为一个带帧头的完整编码信号周期长度
MAX_NUM_INIT = enc_len+length(FH);
% 初始最大码元周期设置为时钟信号的二分频（根据本实验实际情况）
MAX_ELE_PERIOD = 2*ELA;
% 最大点数=最大码元个数*最大码元周期
WIDTH_INIT = MAX_NUM_INIT*MAX_ELE_PERIOD;
width = WIDTH_INIT;
% 基带数据，限定为16位
setappdata(hObject,'base_sig',zeros(1,16));
% 加错开关值，限定为4*7=28位
setappdata(hObject,'err_val',zeros(1,28));
% 基带时钟
setappdata(hObject,'base_clo',[0,1]);
% 编码类型
% 0为汉明码，1为循环码
setappdata(hObject,'coding_type',0);
% 编码数据帧
setappdata(hObject,'enc_fra',[1,zeros(1,enc_clock-1)]);
% 编码数据（带帧头）
setappdata(hObject,'enc_sig',[FH,zeros(1,enc_len)]);
% 加错编码数据
setappdata(hObject,'enc_sig_e',getappdata(hObject,'enc_sig'));
% 译码纠错输出
setappdata(hObject,'dec_sig_ce',zeros(1,16));
% 译码未纠错输出
setappdata(hObject,'dec_sig_e',zeros(1,16));
% 不带帧头编码信号长度
setappdata(hObject,'enc_len',enc_len);

% 更新波形图
DrawFcn(handles.axes1,pt(1),handles);
DrawFcn(handles.axes2,pt(2),handles);

% UIWAIT makes Simu wait for user response (see UIRESUME)
% uiwait(handles.figure_main);


% --- Outputs from this function are returned to the command line.
function varargout = Simu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_set.
function pushbutton_set_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 参数设置
% 通过设置对话框获取基带数据和加错开关值
[base_sig,err_val] = Set(getappdata(gcbf,'base_sig'),getappdata(gcbf,'err_val')); 
% 更新数据
setappdata(gcbf,'base_sig',base_sig);
setappdata(gcbf,'err_val',err_val);
UpdateFcn(handles);

function UpdateFcn(handles)
% 更新数据及图像
global FH;
global pt;
% 编码类型
coding_type = getappdata(gcbf,'coding_type');
% 编码
enc_sig = EncodeFcn(coding_type,handles);
% 加错
enc_sig_e = xor(enc_sig,getappdata(gcbf,'err_val')); 
% 调整编码长度并添加帧头
enc_len = getappdata(gcbf,'enc_len');
enc_sig_fra = [FH,repmat(enc_sig,1,ceil(enc_len/length(enc_sig)))];
enc_sig_e_fra = [FH,repmat(enc_sig_e,1,ceil(enc_len/length(enc_sig_e)))];

if ~coding_type
    % 纠错译码
    dec_sig_ce = Hamming_DecodeFcn(1,enc_sig_e_fra,handles);
    % 未纠错译码
    dec_sig_e = Hamming_DecodeFcn(0,enc_sig_e_fra,handles);
else
    % 纠错译码
    dec_sig_ce = Cyclic_DecodeFcn(1,enc_sig_e_fra,handles);
    % 未纠错译码
    dec_sig_e = Cyclic_DecodeFcn(0,enc_sig_e_fra,handles);
end

% 更新数据
setappdata(gcbf,'enc_sig',enc_sig_fra);
setappdata(gcbf,'enc_sig_e',enc_sig_e_fra);
setappdata(gcbf,'dec_sig_ce',dec_sig_ce);
setappdata(gcbf,'dec_sig_e',dec_sig_e);

% 更新波形图
DrawFcn(handles.axes1,pt(1),handles);
DrawFcn(handles.axes2,pt(2),handles);


function enc_sig = EncodeFcn(ct,handles)
% 编码函数
% ct为编码类型
% 返回值为编码数据
% 生成矩阵
if ~ct
    % 编码类型为汉明码
    G = [1 0 0 0 1 1 1;...
         0 1 0 0 1 1 0;...
         0 0 1 0 1 0 1;...
         0 0 0 1 0 1 1];
else
    % 编码类型为循环码
    G = [1 0 0 0 1 1 0;...
         0 1 0 0 0 1 1;...
         0 0 1 0 1 1 1;...
         0 0 0 1 1 0 1];
end
base_sig = getappdata(handles.figure_main,'base_sig'); % 基带数据
base_sig = transpose(reshape(base_sig,4,4));
enc_sig = (base_sig*G)';
enc_sig = mod(enc_sig,2);   % 模2运算
enc_sig = enc_sig(:)';

function dec_sig = Hamming_DecodeFcn(ce,enc_sig,handles)
% 汉明码译码函数
% enc_sig为编码数据
% ce为1时启动纠错，0时不纠错
% 返回值为译码数据
global FH;
% 错码对照表
ERR_TABLE = {'111','110','101','011','100','010','001'};
% 去帧头
enc = enc_sig(length(FH)+1:end);
% 取一周期（前4*7个）
enc = enc(1:28);
enc = reshape(enc,7,4);   % 接收数据
if ce
    % 计算校正子
    S1 = xor(xor(xor(enc(1,:),enc(2,:)),enc(3,:)),enc(5,:));   
    S2 = xor(xor(xor(enc(1,:),enc(2,:)),enc(4,:)),enc(6,:));   
    S3 = xor(xor(xor(enc(1,:),enc(3,:)),enc(4,:)),enc(7,:));
    S = [S1;S2;S3]';
    for i = 1:size(enc,2)
        % S每一行转换为字符串，去空格后查表
        ind = find(strcmp(strrep(num2str(S(i,:)),' ',''),ERR_TABLE));
        if ~isempty(ind)
            enc(ind,i) = ~enc(ind,i);
        end
    end
end
enc = enc(1:4,1:4);
dec_sig = enc(:)';

function dec_sig = Cyclic_DecodeFcn(ce,enc_sig,handles)
% 循环码译码函数
% enc_sig为编码数据
% ce为1时启动纠错，0时不纠错
% 返回值为译码数据
global FH;
% 错码图样表
ERR_TABLE = {'110','011','111','101','100','010','001'};
% 去帧头
enc = enc_sig(length(FH)+1:end);
% 取一周期（前4*7个）
enc = enc(1:28);
enc = reshape(enc,7,4);   % 接收数据
% 若启动纠错
if ce
    g = [1 1 0 1];  % 生成多项式g(x)
    g = g(find(g==1,1):end);    % 去除开头的0
    N = length(g);   % 获取除数长度
    
    % 对接收数据的每一列判断是否整除g(x)
    for i = 1:size(enc,2)
        R_col = enc(:,i)';   % 取第i列
        R_col = R_col(find(R_col==1,1):end);    % 去除开头的0
        M = length(R_col);  % 获取被除数长度
        % 比较M、N大小
        if M < N
            % 若被除数位数小于除数，说明不够除
            % 被除数即为余数，若其位数小于3位则将其补为3位（由于错误图样为3位）
            re = [zeros(1,3-length(R_col)),R_col];
        else
            % g(x)模二除R_col
            sub = R_col(1:N);   % 取首个子段
            quo = 1;   % 商
            re = xor(sub,g);    % 余数
            for n = N+1:M
                % 更新子段，去掉首位，取被除数中下一位
                sub = [re(2:end),R_col(n)];
                % 若子段首项为1则商处应取1，否则取0
                % 若取1则执行异或运算（模二减），否则余数等于当前子段
                quo = [quo,sub(1)]; % 商
                re = sub.*~sub(1)+xor(sub,g).*sub(1);  % 余数
            end
            % 去除余数第1位0，此时余数必定为N-1位
            re = re(2:end);
        end
        % 根据余数查表找到对应的错误图样
        ind = find(strcmp(strrep(num2str(re),' ',''),ERR_TABLE));
        % 修正
        if ~isempty(ind)
            enc(ind,i) = ~enc(ind,i);
        end
    end
end
enc = enc(1:4,1:4);
dec_sig = enc(:)';


function DrawFcn(h_axes,i,handles)
% 显示波形图
% h_axes为坐标轴句柄
% i为波形图类型号，如下：
% -----------------
% i     波形图类型
% -----------------
% 1     基带数据
% 2     基带时钟
% 3     编码数据帧
% 4     编码输出
% 5     加错数据
% 6     译码纠错
% 7     译码未纠错
% -----------------
% 
global width;
global ELA;
ela_ele = ELA*2;   % 将时钟信号二分频后作为除时钟信号外其余码元脉宽
elapse = ela_ele;   % 当前信号对应脉宽
switch i
    case 1
        % 基带数据
        sig = getappdata(handles.figure_main,'base_sig');
    case 2
        % 基带时钟
        sig = getappdata(handles.figure_main,'base_clo');
        elapse = ELA;  % 时钟脉宽
    case 3
        % 编码数据帧
        sig = getappdata(handles.figure_main,'enc_fra');
    case 4
        % 编码输出
        sig = getappdata(handles.figure_main,'enc_sig');
    case 5
        % 加错数据
        sig = getappdata(handles.figure_main,'enc_sig_e');
    case 6
        % 纠错译码
        sig = getappdata(handles.figure_main,'dec_sig_ce');
    case 7
        % 未纠错译码
        sig = getappdata(handles.figure_main,'dec_sig_e');
end
% 不断重复周期直到满屏
sig = repmat(sig,1,ceil(width/(elapse*length(sig))));
% 选中当前坐标轴进行绘图
axes(h_axes);
% 按设置参数拓展信号脉宽
sig = reshape(repmat(sig,elapse,1),1,elapse*numel(sig));
h_wave = plot(1:length(sig),sig);
% 设置波形颜色，坐标轴1为黄色，坐标轴2为绿色
if h_axes == handles.axes1
    set(h_wave,'color','y');
else
    set(h_wave,'color','g');
end
% 不显示刻度
set(gca,'xtick',[],'ytick',[]);
% 底色设为黑色
set(gca,'color','black');
% 限定坐标轴范围
% 屏幕高度，脉冲高度均为1，且均为单极性，将屏幕高度设为脉冲高度两倍
ylim([0,2]);
% 屏幕宽度（视野）
xlim([0,width]);



% --- Executes when user attempts to close figure_main.
function figure_main_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
rmappdata(hObject,'base_sig');
rmappdata(hObject,'base_clo');
rmappdata(hObject,'enc_fra');
rmappdata(hObject,'enc_sig');
rmappdata(hObject,'enc_sig_e');
rmappdata(hObject,'dec_sig_e');
rmappdata(hObject,'dec_sig_ce');
rmappdata(hObject,'coding_type');
rmappdata(hObject,'err_val');
rmappdata(hObject,'enc_len');
delete(hObject);


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pt;
tag_cgd = get(hObject,'tag');
pt(1) = str2double(tag_cgd(end));   % 取tag末位数字
DrawFcn(handles.axes1,pt(1),handles);

% --- Executes when selected object is changed in uibuttongroup5.
function uibuttongroup5_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup5 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pt;
tag_cgd = get(hObject,'tag');
pt(2) = str2double(tag_cgd(end));
DrawFcn(handles.axes2,pt(2),handles);


% --- Executes on button press in radiobutton31.
function radiobutton31_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton31
setappdata(handles.figure_main,'coding_type',0);
UpdateFcn(handles);

% --- Executes on button press in radiobutton32.
function radiobutton32_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton32
setappdata(handles.figure_main,'coding_type',1);
UpdateFcn(handles);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% 拖动滚动条
global width;   % 屏幕宽度（视野）
global WIDTH_INIT;  % 初始视野
global pt;  % 波形图类型
slider_val = get(hObject,'value');  % 滑块当前值
% 滚动范围在[-1,1]
% 按以5为底的指数改变视野大小，使得变化范围在[1/5,5]
width = WIDTH_INIT*exp(slider_val);
% 重绘
DrawFcn(handles.axes1,pt(1),handles);
DrawFcn(handles.axes2,pt(2),handles);
    

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbotton_save.
function pushbotton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbotton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 保存图片
global pic_no_main;
try
    saveas(gcf,['.\\Pic_Main',num2str(pic_no_main),'.png']);
    pic_no_main = pic_no_main + 1;
    msgbox('图片保存成功！');
catch
    msgbox('图片保存失败！');
end
