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

% % ����ϴ�ͼƬ
% !del /q PIC_SET?.png
% !del /q PIC_MAIN?.png

% ����ʱ��������ɫ
set(gcf,'inverthardcopy','off')

% ���峣������ʼ������
% ֡ͷ
global FH
FH = [0,1,1,1,1,1,1,0];
% ��ǰѡ��Ĳ���ͼ����
global pt;
% ʱ�������ȣ������ڵ��ڻ�ͼ���ȣ�
global ELA;
% ��ǰ������ͼƬ���
global pic_no_main;
% ��ǰ���ý���ͼƬ���
global pic_no_set;

pt = [1,1];
ELA = 50;
pic_no_main = 0;
pic_no_set = 0;

%
% Ϊģ��ʾ������ʵ�ֲ�ͬ����������꣨ʱ�䣩ͬ�������̶���ȫ����
% ֻ�豣֤�����᷶Χ��ȡ������ȫ��ͬ
% ��ͬ������ȡ������Ϊ1��Ĭ�ϣ���Ϊʹ�������᷶Χ��ȫ����䲨��
% �費���ظ�����ֱ������
% ��ǰ�����������ظ���������=����ʾ����������Ϊ�����1��/һ�����ڵ���
% ����ʾ���������ʼ����ֵ�͵�ǰ�Ŵ�����й�
% һ�����ڵ��� = ��ǰ�ź���Ԫ����*һ��������Ԫ����
%
% �����Ļ��ȣ���������
global width;
% ��Ļ��ȳ�ʼֵ
global WIDTH_INIT;

% ʱ���������ò��ֿ���չ
% ����ʱ�Ӳ����ʣ�K��
base_clock = 32;
% ����ʱ�Ӳ����ʣ�K��
enc_clock = 64;
% ����֡ͷ�����źų���
% ����Ϊ��7,4)�������ѭ���룬��������Ϊ16λ��4*7=28
enc_len = 28*enc_clock/base_clock;
% ��ʼ�����Ԫ������Ϊһ����֡ͷ�����������ź����ڳ���
MAX_NUM_INIT = enc_len+length(FH);
% ��ʼ�����Ԫ��������Ϊʱ���źŵĶ���Ƶ�����ݱ�ʵ��ʵ�������
MAX_ELE_PERIOD = 2*ELA;
% ������=�����Ԫ����*�����Ԫ����
WIDTH_INIT = MAX_NUM_INIT*MAX_ELE_PERIOD;
width = WIDTH_INIT;
% �������ݣ��޶�Ϊ16λ
setappdata(hObject,'base_sig',zeros(1,16));
% �Ӵ���ֵ���޶�Ϊ4*7=28λ
setappdata(hObject,'err_val',zeros(1,28));
% ����ʱ��
setappdata(hObject,'base_clo',[0,1]);
% ��������
% 0Ϊ�����룬1Ϊѭ����
setappdata(hObject,'coding_type',0);
% ��������֡
setappdata(hObject,'enc_fra',[1,zeros(1,enc_clock-1)]);
% �������ݣ���֡ͷ��
setappdata(hObject,'enc_sig',[FH,zeros(1,enc_len)]);
% �Ӵ��������
setappdata(hObject,'enc_sig_e',getappdata(hObject,'enc_sig'));
% ����������
setappdata(hObject,'dec_sig_ce',zeros(1,16));
% ����δ�������
setappdata(hObject,'dec_sig_e',zeros(1,16));
% ����֡ͷ�����źų���
setappdata(hObject,'enc_len',enc_len);

% ���²���ͼ
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
% ��������
% ͨ�����öԻ����ȡ�������ݺͼӴ���ֵ
[base_sig,err_val] = Set(getappdata(gcbf,'base_sig'),getappdata(gcbf,'err_val')); 
% ��������
setappdata(gcbf,'base_sig',base_sig);
setappdata(gcbf,'err_val',err_val);
UpdateFcn(handles);

function UpdateFcn(handles)
% �������ݼ�ͼ��
global FH;
global pt;
% ��������
coding_type = getappdata(gcbf,'coding_type');
% ����
enc_sig = EncodeFcn(coding_type,handles);
% �Ӵ�
enc_sig_e = xor(enc_sig,getappdata(gcbf,'err_val')); 
% �������볤�Ȳ����֡ͷ
enc_len = getappdata(gcbf,'enc_len');
enc_sig_fra = [FH,repmat(enc_sig,1,ceil(enc_len/length(enc_sig)))];
enc_sig_e_fra = [FH,repmat(enc_sig_e,1,ceil(enc_len/length(enc_sig_e)))];

if ~coding_type
    % ��������
    dec_sig_ce = Hamming_DecodeFcn(1,enc_sig_e_fra,handles);
    % δ��������
    dec_sig_e = Hamming_DecodeFcn(0,enc_sig_e_fra,handles);
else
    % ��������
    dec_sig_ce = Cyclic_DecodeFcn(1,enc_sig_e_fra,handles);
    % δ��������
    dec_sig_e = Cyclic_DecodeFcn(0,enc_sig_e_fra,handles);
end

% ��������
setappdata(gcbf,'enc_sig',enc_sig_fra);
setappdata(gcbf,'enc_sig_e',enc_sig_e_fra);
setappdata(gcbf,'dec_sig_ce',dec_sig_ce);
setappdata(gcbf,'dec_sig_e',dec_sig_e);

% ���²���ͼ
DrawFcn(handles.axes1,pt(1),handles);
DrawFcn(handles.axes2,pt(2),handles);


function enc_sig = EncodeFcn(ct,handles)
% ���뺯��
% ctΪ��������
% ����ֵΪ��������
% ���ɾ���
if ~ct
    % ��������Ϊ������
    G = [1 0 0 0 1 1 1;...
         0 1 0 0 1 1 0;...
         0 0 1 0 1 0 1;...
         0 0 0 1 0 1 1];
else
    % ��������Ϊѭ����
    G = [1 0 0 0 1 1 0;...
         0 1 0 0 0 1 1;...
         0 0 1 0 1 1 1;...
         0 0 0 1 1 0 1];
end
base_sig = getappdata(handles.figure_main,'base_sig'); % ��������
base_sig = transpose(reshape(base_sig,4,4));
enc_sig = (base_sig*G)';
enc_sig = mod(enc_sig,2);   % ģ2����
enc_sig = enc_sig(:)';

function dec_sig = Hamming_DecodeFcn(ce,enc_sig,handles)
% ���������뺯��
% enc_sigΪ��������
% ceΪ1ʱ��������0ʱ������
% ����ֵΪ��������
global FH;
% ������ձ�
ERR_TABLE = {'111','110','101','011','100','010','001'};
% ȥ֡ͷ
enc = enc_sig(length(FH)+1:end);
% ȡһ���ڣ�ǰ4*7����
enc = enc(1:28);
enc = reshape(enc,7,4);   % ��������
if ce
    % ����У����
    S1 = xor(xor(xor(enc(1,:),enc(2,:)),enc(3,:)),enc(5,:));   
    S2 = xor(xor(xor(enc(1,:),enc(2,:)),enc(4,:)),enc(6,:));   
    S3 = xor(xor(xor(enc(1,:),enc(3,:)),enc(4,:)),enc(7,:));
    S = [S1;S2;S3]';
    for i = 1:size(enc,2)
        % Sÿһ��ת��Ϊ�ַ�����ȥ�ո����
        ind = find(strcmp(strrep(num2str(S(i,:)),' ',''),ERR_TABLE));
        if ~isempty(ind)
            enc(ind,i) = ~enc(ind,i);
        end
    end
end
enc = enc(1:4,1:4);
dec_sig = enc(:)';

function dec_sig = Cyclic_DecodeFcn(ce,enc_sig,handles)
% ѭ�������뺯��
% enc_sigΪ��������
% ceΪ1ʱ��������0ʱ������
% ����ֵΪ��������
global FH;
% ����ͼ����
ERR_TABLE = {'110','011','111','101','100','010','001'};
% ȥ֡ͷ
enc = enc_sig(length(FH)+1:end);
% ȡһ���ڣ�ǰ4*7����
enc = enc(1:28);
enc = reshape(enc,7,4);   % ��������
% ����������
if ce
    g = [1 1 0 1];  % ���ɶ���ʽg(x)
    g = g(find(g==1,1):end);    % ȥ����ͷ��0
    N = length(g);   % ��ȡ��������
    
    % �Խ������ݵ�ÿһ���ж��Ƿ�����g(x)
    for i = 1:size(enc,2)
        R_col = enc(:,i)';   % ȡ��i��
        R_col = R_col(find(R_col==1,1):end);    % ȥ����ͷ��0
        M = length(R_col);  % ��ȡ����������
        % �Ƚ�M��N��С
        if M < N
            % ��������λ��С�ڳ�����˵��������
            % ��������Ϊ����������λ��С��3λ���䲹Ϊ3λ�����ڴ���ͼ��Ϊ3λ��
            re = [zeros(1,3-length(R_col)),R_col];
        else
            % g(x)ģ����R_col
            sub = R_col(1:N);   % ȡ�׸��Ӷ�
            quo = 1;   % ��
            re = xor(sub,g);    % ����
            for n = N+1:M
                % �����ӶΣ�ȥ����λ��ȡ����������һλ
                sub = [re(2:end),R_col(n)];
                % ���Ӷ�����Ϊ1���̴�Ӧȡ1������ȡ0
                % ��ȡ1��ִ��������㣨ģ�������������������ڵ�ǰ�Ӷ�
                quo = [quo,sub(1)]; % ��
                re = sub.*~sub(1)+xor(sub,g).*sub(1);  % ����
            end
            % ȥ��������1λ0����ʱ�����ض�ΪN-1λ
            re = re(2:end);
        end
        % ������������ҵ���Ӧ�Ĵ���ͼ��
        ind = find(strcmp(strrep(num2str(re),' ',''),ERR_TABLE));
        % ����
        if ~isempty(ind)
            enc(ind,i) = ~enc(ind,i);
        end
    end
end
enc = enc(1:4,1:4);
dec_sig = enc(:)';


function DrawFcn(h_axes,i,handles)
% ��ʾ����ͼ
% h_axesΪ��������
% iΪ����ͼ���ͺţ����£�
% -----------------
% i     ����ͼ����
% -----------------
% 1     ��������
% 2     ����ʱ��
% 3     ��������֡
% 4     �������
% 5     �Ӵ�����
% 6     �������
% 7     ����δ����
% -----------------
% 
global width;
global ELA;
ela_ele = ELA*2;   % ��ʱ���źŶ���Ƶ����Ϊ��ʱ���ź���������Ԫ����
elapse = ela_ele;   % ��ǰ�źŶ�Ӧ����
switch i
    case 1
        % ��������
        sig = getappdata(handles.figure_main,'base_sig');
    case 2
        % ����ʱ��
        sig = getappdata(handles.figure_main,'base_clo');
        elapse = ELA;  % ʱ������
    case 3
        % ��������֡
        sig = getappdata(handles.figure_main,'enc_fra');
    case 4
        % �������
        sig = getappdata(handles.figure_main,'enc_sig');
    case 5
        % �Ӵ�����
        sig = getappdata(handles.figure_main,'enc_sig_e');
    case 6
        % ��������
        sig = getappdata(handles.figure_main,'dec_sig_ce');
    case 7
        % δ��������
        sig = getappdata(handles.figure_main,'dec_sig_e');
end
% �����ظ�����ֱ������
sig = repmat(sig,1,ceil(width/(elapse*length(sig))));
% ѡ�е�ǰ��������л�ͼ
axes(h_axes);
% �����ò�����չ�ź�����
sig = reshape(repmat(sig,elapse,1),1,elapse*numel(sig));
h_wave = plot(1:length(sig),sig);
% ���ò�����ɫ��������1Ϊ��ɫ��������2Ϊ��ɫ
if h_axes == handles.axes1
    set(h_wave,'color','y');
else
    set(h_wave,'color','g');
end
% ����ʾ�̶�
set(gca,'xtick',[],'ytick',[]);
% ��ɫ��Ϊ��ɫ
set(gca,'color','black');
% �޶������᷶Χ
% ��Ļ�߶ȣ�����߶Ⱦ�Ϊ1���Ҿ�Ϊ�����ԣ�����Ļ�߶���Ϊ����߶�����
ylim([0,2]);
% ��Ļ��ȣ���Ұ��
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
pt(1) = str2double(tag_cgd(end));   % ȡtagĩλ����
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
% �϶�������
global width;   % ��Ļ��ȣ���Ұ��
global WIDTH_INIT;  % ��ʼ��Ұ
global pt;  % ����ͼ����
slider_val = get(hObject,'value');  % ���鵱ǰֵ
% ������Χ��[-1,1]
% ����5Ϊ�׵�ָ���ı���Ұ��С��ʹ�ñ仯��Χ��[1/5,5]
width = WIDTH_INIT*exp(slider_val);
% �ػ�
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
% ����ͼƬ
global pic_no_main;
try
    saveas(gcf,['.\\Pic_Main',num2str(pic_no_main),'.png']);
    pic_no_main = pic_no_main + 1;
    msgbox('ͼƬ����ɹ���');
catch
    msgbox('ͼƬ����ʧ�ܣ�');
end
