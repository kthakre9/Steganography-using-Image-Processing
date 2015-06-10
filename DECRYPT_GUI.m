function varargout = DECRYPT_GUI(varargin)
% DECRYPT_GUI M-file for DECRYPT_GUI.fig
%      DECRYPT_GUI, by itself, creates a new DECRYPT_GUI or raises the existing
%      singleton*.
%
%      H = DECRYPT_GUI returns the handle to a new DECRYPT_GUI or the handle to
%      the existing singleton*.
%
%      DECRYPT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DECRYPT_GUI.M with the given input arguments.
%
%      DECRYPT_GUI('Property','Value',...) creates a new DECRYPT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MAIN_GUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DECRYPT_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DECRYPT_GUI

% Last Modified by GUIDE v2.5 30-Mar-2013 13:33:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DECRYPT_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DECRYPT_GUI_OutputFcn, ...
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


% --- Executes just before DECRYPT_GUI is made visible.
function DECRYPT_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DECRYPT_GUI (see VARARGIN)

% Choose default command line output for DECRYPT_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DECRYPT_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DECRYPT_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%----------------------------------------

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
closereq


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

I = handles.I;
a = size(I);
s1 = a(1);
s2 = a(2);
F15 = imread('sel.jpg');

F15 = imresize(F15,[s1 s2]);
n = 4; % Number of bits to replace 1 <= n <= 7

[Stego, Extracted] = LSBHide(I, F15, n);

%figure, imshow(Stego);
%title('Stegno Image');
axes(handles.axes2);
imshow(Extracted)
title('extracted image');

% x = snr(Stego)
%--------------------------------------------------------------------------

%    [N M] = size(Stego);
%    ima=max(Stego(:));
%    ima = double(ima);
%    imi=min(Stego(:));
%    imi=double(imi);
%    Stego = double(Stego);
%    ims=std(Stego(:));
%    
%    snr=20*log10((ima-imi)./ims)
%    MSE = sqrt((sum(sum((double(Stego)).^2)))/(N*M));
%    PSNR = 10*log10(255^2/MSE);
%    sprintf('The PSNR is: %5.2fdB.',PSNR(1))
%    disp('          ');
%    sprintf('The MSE is: %5.2fdB.',MSE(1))



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Extracted=handles.Extracted;


 


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I = imread('image_Stego.jpg');

axes(handles.axes1);
imshow(I);
title('Stegno Image');



handles.I=I;
guidata(hObject, handles);

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

closereq
