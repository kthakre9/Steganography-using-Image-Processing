function varargout = MAIN_GUI(varargin)
% MAIN_GUI M-file for MAIN_GUI.fig
%      MAIN_GUI, by itself, creates a new MAIN_GUI or raises the existing
%      singleton*.
%
%      H = MAIN_GUI returns the handle to a new MAIN_GUI or the handle to
%      the existing singleton*.
%
%      MAIN_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_GUI.M with the given input arguments.
%
%      MAIN_GUI('Property','Value',...) creates a new MAIN_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MAIN_GUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MAIN_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MAIN_GUI

% Last Modified by GUIDE v2.5 06-Aug-2011 19:25:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MAIN_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MAIN_GUI_OutputFcn, ...
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


% --- Executes just before MAIN_GUI is made visible.
function MAIN_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MAIN_GUI (see VARARGIN)

% Choose default command line output for MAIN_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MAIN_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MAIN_GUI_OutputFcn(hObject, eventdata, handles) 
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
[namefile,pathname]=uigetfile({'*.bmp;*.tif;*.tiff;*.jpg;*.jpeg;*.gif','IMAGE Files (*.bmp,*.tif,*.tiff,*.jpg,*.jpeg,*.gif)'},'Chose GrayScale Image');
I=imread(strcat(pathname,namefile));
P = I;
%--------------------------------------------------------------------------
% imwrite(I,'s_img.jpg');
input_image1=imread([pathname namefile]);
F=input_image1;
axes(handles.axes1);
imshow(F);
title('original image');
[u v w]=size(F);
if w==3
  F=rgb2gray(F);
end

handles.I=I;
handles.F=F;
handles.input_image1=input_image1;
guidata(hObject, handles);

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
I = handles.I;
input_image1=handles.input_image1;
F = handles.F;
input_image=imnoise(input_image1,'speckle',.01);% noise level by .01
%give the number of decomposition level which must be integer and should not exceed 3

n = 3; 
%*****************************************************************************
[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters('haar');

axis image; set(gca,'XTick',[],'YTick',[]); title('Original')
% We will use the 9/7 filters with symmetric extension at the
% boundaries.
wname = 'bior4.4';
warning off
% Compute a 2-level decomposition of the image using the 9/7 filters.
[wc,s] = wavedec2(F,2,wname);

% Extract the level 1 coefficients.
a1 = appcoef2(wc,s,wname,1);         
h1 = detcoef2('h',wc,s,1);           
v1 = detcoef2('v',wc,s,1);           
d1 = detcoef2('d',wc,s,1);           

% Extract the level 2 coefficients.
a2 = appcoef2(wc,s,wname,2);
h2 = detcoef2('h',wc,s,2);
v2 = detcoef2('v',wc,s,2);
d2 = detcoef2('d',wc,s,2);

% Display the decomposition up to level 1 only.
%ncolors = size(map,1);              % Number of colors.
ncolors=55;  % change value as per required brightness
sz = size(F);
cod_a1 = wcodemat(a1,ncolors); cod_a1 = wkeep(cod_a1, sz/2);
cod_h1 = wcodemat(h1,ncolors); cod_h1 = wkeep(cod_h1, sz/2);
cod_v1 = wcodemat(v1,ncolors); cod_v1 = wkeep(cod_v1, sz/2);
cod_d1 = wcodemat(d1,ncolors); cod_d1 = wkeep(cod_d1, sz/2);
axes(handles.axes2);
image([cod_a1,cod_h1;cod_v1,cod_d1]);
% axis image; set(gca,'XTick',[],'YTick',[]); title('Single stage decomposition')
C = cod_a1;
C = I;
%--------------------------------------------------------------------------
cod_a1 = uint8(cod_a1);
imwrite(cod_a1,'test.bmp');
k=imfinfo('test.bmp');
ib=k.Width*k.Height*k.BitDepth/8;
cb=k.FileSize;
compression_ratio=ib/cb
%----------------------------------------
a = size(I);
s1 = a(1);
s2 = a(2);

handles.s1=s1;
handles.s2=s2;
guidata(hObject, handles);
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s1 = handles.s1;
s2 = handles.s2;
[namefile,pathname]=uigetfile({'*.bmp;*.tif;*.tiff;*.jpg;*.jpeg;*.gif','IMAGE Files (*.bmp,*.tif,*.tiff,*.jpg,*.jpeg,*.gif)'},'Chose GrayScale Image');
F15=imread(strcat(pathname,namefile));
imwrite(F15,'sel.jpg');
axes(handles.axes3);
imshow(F15);
title('image to be hide');
F15 = imresize(F15,[s1 s2]);
n = 4; % Number of bits to replace 1 <= n <= 7

handles.F15 = F15;
handles.n = n;
guidata(hObject, handles);



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

I = handles.I;
F15 = handles.F15;
n = handles.n;

[Stego, Extracted] = LSBHide(I, F15, n);
axes(handles.axes4);
imshow(Stego);
title('Stegno Image');

imwrite(Stego,'image_Stego.jpg');
% x = snr(Stego)
%--------------------------------------------------------------------------

[N M] = size(Stego);
   ima=max(Stego(:));
   ima = double(ima);
   imi=min(Stego(:));
   imi=double(imi);
   Stego = double(Stego);
   ims=std(Stego(:));
   
   snr=20*log10((ima-imi)./ims)
   MSE = sqrt((sum(sum((double(Stego)).^2)))/(N*M));
   PSNR = 10*log10(255^2/MSE);
   sprintf('The PSNR is: %5.2fdB.',PSNR(1))
   disp('          ');
   sprintf('The MSE is: %5.2fdB.',MSE(1))

handles.Extracted=Extracted;
guidata(hObject, handles);





% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Extracted=handles.Extracted;


I = handles.I;
F15 = handles.F15;
n = handles.n;

[Stego, Extracted] = LSBHide(I, F15, n);

axes(handles.axes5);
imshow(Extracted)
title('extracted image');

   
   
