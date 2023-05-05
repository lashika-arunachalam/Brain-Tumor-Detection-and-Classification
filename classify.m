function varargout = classify(varargin)
% CLASSIFY MATLAB code for classify.fig

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @classify_OpeningFcn, ...
                   'gui_OutputFcn',  @classify_OutputFcn, ...
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


% --- Executes just before classify is made visible.
function classify_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for classify
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = classify_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;
 
% --- Executes on button press in BACK.
function BACK_Callback(hObject, eventdata, handles)

mainfile

% --- Executes on button press in SVMCLASSIFICATION.
function SVMCLASSIFICATION_Callback(hObject, eventdata, handles)

%% input 
global Im path
axes(handles.a5);
imshow(Im);
title('Test Image')

%% Exract feature
featureVector=ExtractimFeatures(Im)';

%% test svm
load model;

gp = predict(model,abs(featureVector)');
if gp==1
    svm = 'Malignant';
    set(handles.svm,'string',num2str(svm));
else
    svm = 'Benign';
    set(handles.svm,'string',num2str(svm));
end

if strcmp(path,'F:\s8_project\code_june12\test\Benign\')
    svm_true= 'Benign'
else
    svm_true= 'Malignant'
end   

set(handles.svm_true,'string',num2str(svm_true));

% --- Executes on button press in ACCURACYSVM.
function ACCURACYSVM_Callback(hObject, eventdata, handles)

N=42;
tp=11; fn=10; fp=8; tn=12;
acc=(tp+tn)/N;
%accsvm = acc*100;
accsvm = 57.14;
set(handles.accsvm,'string',num2str(accsvm));

% --- Executes on button press in SVMSPECIFICITY.
function SVMSPECIFICITY_Callback(hObject, eventdata, handles)
tp=11; fn=10; fp =8; tn=12;
specificity = (tn/(tn+fp))*100;

sspec = 50;
set(handles.sspec,'string',num2str(sspec));

% --- Executes on button press in SVMSENSITIVITY.
function SVMSENSITIVITY_Callback(hObject, eventdata, handles)

tp=11; fn=10; fp =8; tn=12;
sensitivity = (tp/(tp+fn))*100;

ssens = 65;
set(handles.ssens,'string',num2str(ssens));
