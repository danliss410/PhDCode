function varargout = us01_terminal_v1(varargin)
% US01_TERMINAL_V1 MATLAB code for us01_terminal_v1.fig
%      US01_TERMINAL_V1, by itself, creates a new US01_TERMINAL_V1 or raises the existing
%      singleton*.
%
%      H = US01_TERMINAL_V1 returns the handle to a new US01_TERMINAL_V1 or the handle to
%      the existing singleton*.
%
%      US01_TERMINAL_V1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in US01_TERMINAL_V1.M with the given input arguments.
%
%      US01_TERMINAL_V1('Property','Value',...) creates a new US01_TERMINAL_V1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before us01_terminal_v1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to us01_terminal_v1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help us01_terminal_v1

% Last Modified by GUIDE v2.5 26-Jun-2019 08:53:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @us01_terminal_v1_OpeningFcn, ...
                   'gui_OutputFcn',  @us01_terminal_v1_OutputFcn, ...
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


% --- Executes just before us01_terminal_v1 is made visible.
function us01_terminal_v1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to us01_terminal_v1 (see VARARGIN)

% Choose default command line output for us01_terminal_v1
handles.output = hObject;

% computer and user specific saving information
if ~isfield(handles, 'initCheck')
    handles.initCheck = 1;
    SpecDir = pwd;
    
    if exist('C:\Users\hullfist\Box Sync\MotionLab\Ultrasound\', 'dir')
        handles.username = 'hullfist';
        handles.searchPath = 'C:\Users\hullfist\Box Sync\MotionLab\Ultrasound\';
        SpecDir = handles.searchPath;
    else
        if contains(SpecDir, '\Box Sync')
            slashind = strfind(SpecDir, '\Users\');
            dropind = strfind(SpecDir, '\Box');
            handles.username = SpecDir(slashind+7:dropind-1);
            handles.searchPath = strcat(SpecDir(1:dropind-1), '\Box Sync\MotionLab\Data\');
        elseif contains(SpecDir, '\Desktop')
            slashind = strfind(SpecDir, '\Users\');
            dropind = strfind(SpecDir, '\Desktop');
            handles.username = SpecDir(slashind+7:dropind-1);
            handles.searchPath = 'C:\TEMP_ULTRASOUND';
        end
    end
    handles.CurrentDir = SpecDir;
    handles.TrialNames = fullfile(SpecDir, 'Trial Names');

    % echowave control parameters
    handles.echowavePath = 'C:\Program Files (x86)\TELEMED\Echo Wave II';
    handles.echowaveexe = fullfile(handles.echowavePath,'EchoWave.exe');
    % get current savepath for echowave
    if ~contains(SpecDir, '\Box Sync\')
        handles.echoSearch = 'C:\TEMP_ULTRASOUND';
        handles.searchPath = 'C:\TEMP_ULTRASOUND';
    else
        handles.echoSearch = handles.searchPath;
    end
    % NET controls
    [handles.asm, handles.cmd] = controlEchowave;
    
    % TCPIP CONNECTION TO CONTROL
    handles.controlcomp = 'PC08YUV2';
%     handles.us01comp = 'MJ04EXKC';
    handles.tcp_us01 = tcpip(handles.controlcomp, 65001, 'NetworkRole', 'server');
    
    handles.ControlTimer = timer();
    handles.ControlTimer.Period = 1;
    handles.ControlTimer.ExecutionMode = 'fixedSpacing';
    handles.ControlTimer.BusyMode = 'Queue';
    handles.ControlTimer.TimerFcn = {@StatusChecker, handles};
    conParams.recording = 0;
    conParams.fullTrialName = '';
    conParams.tvdSavePath = '';
    conParams.probeName = '';
    handles.ControlTimer.UserData = conParams;
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes us01_terminal_v1 wait for user response (see UIRESUME)
% uiwait(handles.us01_terminal_v1_fig);


% --- Outputs from this function are returned to the command line.
function varargout = us01_terminal_v1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in settvddir_tb.
function settvddir_tb_Callback(hObject, eventdata, handles)
% hObject    handle to settvddir_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of settvddir_tb
blah = uigetdir(handles.echoSearch, 'Please select Echowave''s current save directory.');
conParams = handles.ControlTimer.UserData;

if blah ~= 0
    handles.tvdSavePath = blah;
    conParams.tvdSavePath = blah;
    handles.ControlTimer.UserData = conParams;
    set(handles.subID_et, 'Enable', 'on');
else
    set(hObject, 'Value', 0)
    return
end

if contains(blah, 'TEMP_ULTRASOUND')
    tul = length('TEMP_ULTRASOUND\');
    tui = strfind(blah, 'TEMP_ULTRASOUND\');
    pstr = blah(tui+tul:end);
    slashi = strfind(pstr, '\');
    if length(slashi) == 2
        subID = pstr(1:slashi(1,1)-1);
        set(handles.subID_et, 'String', subID);
        set(handles.setsubID_tb, 'Enable', 'on')
    end
else
    if contains(blah, 'MotionLab\Ultrasound\')
        tul = length('Ultrasound\');
        tui = strfind(blah, 'Ultrasound\');
        pstr = blah(tui+tul:end);
        slashi = strfind(pstr, '\');
        if length(slashi) == 3
            subID = pstr(slashi(1)+1:slashi(2)-1);
            set(handles.subID_et, 'String', subID);
            set(handles.setsubID_tb, 'Enable', 'on')
        elseif length(slashi) == 4 && contains(blah, 'Pilot')
            subID = pstr(slashi(2)+1:slashi(3)-1);
            set(handles.subID_et, 'String', subID);
            set(handles.setsubID_tb, 'Enable', 'on')
        end
    end
end

guidata(us01_terminal_v1, handles);


function subID_et_Callback(hObject, eventdata, handles)
% hObject    handle to subID_et (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subID_et as text
%        str2double(get(hObject,'String')) returns contents of subID_et as a double
substr = get(hObject, 'String');

if ~contains(substr, 'Enter')
    set(handles.setsubID_tb, 'Enable', 'on')
else
    set(handles.setsubID_tb, 'Enable', 'off')
end
guidata(us01_terminal_v1, handles);


% --- Executes during object creation, after setting all properties.
function subID_et_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subID_et (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setsubID_tb.
function setsubID_tb_Callback(hObject, eventdata, handles)
% hObject    handle to setsubID_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of setsubID_tb
val = get(hObject, 'Value');

if val == 1
    handles.CurrentSubID = get(handles.subID_et, 'String');
    set(handles.settvddir_tb, 'Enable', 'off')
    set(handles.subID_et, 'Enable', 'off')
    if boolean(handles.cmd.IsRunState())
        set(handles.pause_pb, 'Enable', 'on')
        set(handles.resume_pb, 'Enable', 'off')
    else
        set(handles.pause_pb, 'Enable', 'off')
        set(handles.resume_pb, 'Enable', 'on')
    end
else
    set(handles.settvddir_tb, 'Enable', 'on')
    set(handles.subID_et, 'Enable', 'on')
end

guidata(us01_terminal_v1, handles);



% --- Executes on button press in pause_pb.
function pause_pb_Callback(hObject, eventdata, handles)
% hObject    handle to pause_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if boolean(handles.cmd.IsRunState())
    handles.cmd.FreezeRun();
    set(handles.pause_pb, 'Enable', 'off')
    set(handles.resume_pb, 'Enable', 'on')
    set(handles.savetrial_pb, 'Enable', 'on')
    set(handles.cleartrial_pb, 'Enable', 'on')
end

guidata(us01_terminal_v1, handles);


% --- Executes on button press in resume_pb.
function resume_pb_Callback(hObject, eventdata, handles)
% hObject    handle to resume_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~boolean(handles.cmd.IsRunState())
    handles.cmd.FreezeRun();
    set(handles.pause_pb, 'Enable', 'on')
    set(handles.resume_pb, 'Enable', 'off')
    set(handles.savetrial_pb, 'Enable', 'off')
    set(handles.cleartrial_pb, 'Enable', 'off')
end


% --- Executes on button press in savetrial_pb.
function savetrial_pb_Callback(hObject, eventdata, handles)
% hObject    handle to savetrial_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% tvdn = handles.fullTrialName;
tvdn = handles.ControlTimer.UserData.conParams.fullTrialName;

if ~boolean(handles.cmd.IsRunState())
    set(handles.savetrial_pb, 'Enable', 'off')
    set(handles.cleartrial_pb, 'Enable', 'off')
    set(handles.resume_pb, 'Enable', 'off')
    
    handles.cmd.WmCopyDataCmd(sprintf('echowave.exe^#^-save_cine^#^tvd^#^%s', tvdn));
    handles.cmd.WmCopyDataCmd('echowave.exe^#^-clear_cine');
end

set(handles.resume_pb, 'Enable', 'on')

guidata(us01_terminal_v1, handles);



% --- Executes on button press in cleartrial_pb.
function cleartrial_pb_Callback(hObject, eventdata, handles)
% hObject    handle to cleartrial_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~boolean(handles.cmd.IsRunState())
    set(handles.savetrial_pb, 'Enable', 'off')
    set(handles.cleartrial_pb, 'Enable', 'off')
    
    set(handles.resume_pb, 'Enable', 'off')
    
    handles.cmd.WmCopyDataCmd('echowave.exe^#^-clear_cine');
    
    set(handles.resume_pb, 'Enable', 'on')
end

guidata(us01_terminal_v1, handles);


% --- Executes on button press in control_connect_tb.
function control_connect_tb_Callback(hObject, eventdata, handles)
% hObject    handle to control_connect_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bs = get(hObject, 'Value');
if bs
    % open the tcp connection with the control computer
    try
        fopen(handles.tcp_us01);
    catch ME
        if strcmp(ME.identifier, 'instrument:fopen:opfailed')
            set(hObject, 'Value', 0);
            set(hObject, 'String', 'RETRY');
            set(handles.connect_status, 'String', 'Control was not running');
        else
            set(hObject, 'Value', 0);
            set(hObject, 'String', 'RETRY');
            set(handles.connect_status, 'String', 'Unable to connect to control');
        end
        % don't do anything else if we can't connect
        return
    end
    set(handles.connect_status, 'String', 'Starting timer function');
    % if everything we worked we can now switch functionality
    set(hObject, 'String', 'DISCONNECT');
    % let's start a timed function to check for the ready signal
    try
        start(handles.ControlTimer);
    catch
%         stop(handles.ControlTimer);
%         delete(handles.ControlTimer);
        set(handles.connect_status, 'String', 'Couldn''t start timer');
        return
    end
    set(handles.connect_status, 'String', 'ALL GOOD');
else
    if strcmp(handles.tcp_us01.Status, 'open')
        fprintf(handles.tcp_us01, 'later nerd');
        fclose(handles.tcp_us01);
    end
    set(hObject, 'String', 'CONNECT');
    set(handles.connect_status, 'String', 'Disconnected');
    stop(handles.ControlTimer);
%     delete(handles.ControlTimer);
end
    
guidata(us01_terminal_v1, handles);


% --- Executes on selection change in probe_select_pm.
function probe_select_pm_Callback(hObject, eventdata, handles)
% hObject    handle to probe_select_pm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns probe_select_pm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from probe_select_pm
conParams = handles.ControlTimer.UserData;

ps = get(hObject, 'String');
pv = get(hObject, 'Value');

pstr = ps{pv};
if ~contains(pstr, 'Select')
    conParams.probeName = pstr;
    set(handles.control_connect_tb, 'Enable', 'on')
else
    conParams.probeName = '';
    set(handles.control_connect_tb, 'Enable', 'off')
end
handles.ControlTimer.UserData = conParams;


% --- Executes during object creation, after setting all properties.
function probe_select_pm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to probe_select_pm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close us01_terminal_v1_fig.
function us01_terminal_v1_fig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to us01_terminal_v1_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isfield(handles, 'initCheck')
    fclose(handles.tcp_us01);
end

delete(handles.ControlTimer);

delete(hObject);

% STATUS CHECK CALLBACK FUNCTION FOR LISTENING TO TCPIP COMMANDS
function StatusChecker(mTimer, ~, handles)
% Checks to see if there's a command string available on the TCP connection
% and then performs the appropriate operations base on the command
cb = handles.tcp_us01.BytesAvailable;
conParams = mTimer.UserData;
if cb > 1
    rec = fscanf(handles.tcp_us01);
    le = regexp(rec, '\n');
    cstr = rec(1:le-1);
    switch cstr
        case 'go time'
            handles.cmd.FreezeRun();
            conParams.recording = 1;
            fprintf(handles.tcp_us01, 'gimme the jawn');
        case 'woah nelly'
            handles.cmd.FreezeRun();
            tvdn = conParams.fullTrialName;
            handles.cmd.WmCopyDataCmd(sprintf('echowave.exe^#^-save_cine^#^tvd^#^%s', tvdn));
            handles.cmd.WmCopyDataCmd('echowave.exe^#^-clear_cine');
            conParams.recording = 0;
        case 'later nerd'
            fclose(handles.tcp_us01);
            set(handles.control_connect_tb, 'String', 'Connect', 'Value', 0);
            set(handles.connect_status, 'String', 'Connection closed by control');
            stop(mTimer);
%             delete(mTimer);
            return
        otherwise
            if conParams.recording == 1
                if strcmp(cstr(end-2), '_')
                    tname = sprintf('%s.tvd', cstr);
                    pname = conParams.probeName;
                    fulltname = fullfile(conParams.tvdSavePath, tname);
                    conParams.fullTrialName = fulltname;
                    set(handles.trial_name_st, 'String', sprintf('%s_%s', pname, tname));
                end
            end
    end
end
mTimer.UserData = conParams;
guidata(us01_terminal_v1, handles);
