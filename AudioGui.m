function varargout = AudioGui(varargin)
% AUDIOGUI MATLAB code for AudioGui.fig
%      AUDIOGUI, by itself, creates a new AUDIOGUI or raises the existing
%      singleton*.
%
%      H = AUDIOGUI returns the handle to a new AUDIOGUI or the handle to
%      the existing singleton*.
%
%      AUDIOGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUDIOGUI.M with the given input arguments.
%
%      AUDIOGUI('Property','Value',...) creates a new AUDIOGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AudioGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AudioGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AudioGui

% Last Modified by GUIDE v2.5 30-Nov-2017 13:43:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AudioGui_OpeningFcn, ...
                   'gui_OutputFcn',  @AudioGui_OutputFcn, ...
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


% --- Executes just before AudioGui is made visible.
function AudioGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AudioGui (see VARARGIN)

% Choose default command line output for AudioGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AudioGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AudioGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in fileread.
function fileread_Callback(hObject, eventdata, handles)
% hObject    handle to fileread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.mp3','Select an mp3 to use:');
[Y,fs] = audioread([path file]);
handles.freqSam=fs;
handles.dataSound=Y;
guidata(hObject, handles);


% --- Executes on button press in playbutton.
function playbutton_Callback(hObject, eventdata, handles)
% hObject    handle to playbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
multiplier = 1;

if (isfield(handles, 'freqSam')) %If there's an audio file already read
    if(handles.HalfSampleRate.Value == 1)   %Various checks for Sample Rate
        multiplier = 0.5;
    elseif(handles.DoubleSample.Value == 1)
        multiplier = 2;
    end

    %Various checks for filters
    if(handles.lowpass.Value==1)
        hlpf = fdesign.lowpass('Fp,Fst,Ap,Ast', 300, 500, 0.5, 50, handles.freqSam);
        handles.D = design(hlpf);

    elseif(handles.bandpass.Value==1)
        hlpf = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2', 600, 700, 1500, 2500, 0.7, 70, 0.7, handles.freqSam);
        handles.D = design(hlpf);

    elseif(handles.highpass.Value==1)
        hlpf = fdesign.highpass('Fst,Fp,Ast,Ap', 1500, 2000, 50, 0.5, handles.freqSam);
        handles.D = design(hlpf);
        
    else
        hlpf = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2', 1, 2, 20000, 20001, 0.7, 70, 0.7, handles.freqSam);
        handles.D = design(hlpf);
    end
    
    sound(filter(handles.D, handles.dataSound), (handles.freqSam*multiplier));
    
else
    errordlg('Make sure you have read a sound file.', 'Not Enough Data');
end


% --- Executes on button press in SampleOriginal.
function SampleOriginal_Callback(hObject, eventdata, handles)
% hObject    handle to SampleOriginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SampleOriginal


% --- Executes on button press in DoubleSample.
function DoubleSample_Callback(hObject, eventdata, handles)
% hObject    handle to DoubleSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DoubleSample


% --- Executes on button press in HalfSampleRate.
function HalfSampleRate_Callback(hObject, eventdata, handles)
% hObject    handle to HalfSampleRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HalfSampleRate



% --- Executes during object creation, after setting all properties.
function frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in lowpass.
function lowpass_Callback(hObject, eventdata, handles)
% hObject    handle to lowpass (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lowpass


% --- Executes on button press in echo.
function echo_Callback(hObject, eventdata, handles)
% hObject    handle to echo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of echo


% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pause(length(handles.DataSound)/(handles.freqSam))
