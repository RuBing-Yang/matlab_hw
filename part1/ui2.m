function varargout = ui2(varargin)
% UI2 MATLAB code for ui2.fig
%      UI2, by itself, creates a new UI2 or raises the existing
%      singleton*.
%
%      H = UI2 returns the handle to a new UI2 or the handle to
%      the existing singleton*.
%
%      UI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI2.M with the given input arguments.
%
%      UI2('Property','Value',...) creates a new UI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ui2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ui2

% Last Modified by GUIDE v2.5 01-Dec-2021 11:19:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ui2_OpeningFcn, ...
                   'gui_OutputFcn',  @ui2_OutputFcn, ...
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


% --- Executes just before ui2 is made visible.
function ui2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ui2 (see VARARGIN)

% Choose default command line output for ui2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ui2 wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ui2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
disp('in varargout');
varargout{1} = handles.type;
disp(varargout{1})
delete(handles.figure1);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    disp('in button1');
    handles.type = 0;
    guidata(hObject,handles);
    data = guidata(hObject)
    uiresume(handles.figure1);
    %varargout{1} = 0;
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
    disp('in button2');
    handles.type = 1;
    guidata(hObject,handles);
    data = guidata(hObject)
    uiresume(handles.figure1);
    %varargout{1} = 1;
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
    im = imread('sudo.jpg');
    imshow(im);
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
handles.output = hObject;

handles.type = 0;

% Update handles structure
guidata(hObject, handles);
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function pushbutton2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.output = hObject;

handles.type = 0;

% Update handles structure
guidata(hObject, handles);
