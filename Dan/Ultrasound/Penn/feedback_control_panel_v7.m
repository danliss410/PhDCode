function varargout = feedback_control_panel_v7(varargin)
% feedback_control_panel_v7 MATLAB code for feedback_control_panel_v7.fig
%      feedback_control_panel_v7, by itself, creates a new feedback_control_panel_v7 or raises the existing
%      singleton*.
%
%      H = feedback_control_panel_v7 returns the handle to a new feedback_control_panel_v7 or the handle to
%      the existing singleton*.
%
%      feedback_control_panel_v7('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in feedback_control_panel_v7.M with the given input arguments.
%
%     \feedback_control_panel_v7('Property','Value',...) creates a new feedback_control_panel_v7 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before feedback_control_panel_v7_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to feedback_control_panel_v7_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help feedback_control_panel_v7

% Last Modified by GUIDE v2.5 23-Jul-2019 10:56:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @feedback_control_panel_v7_OpeningFcn, ...
                   'gui_OutputFcn',  @feedback_control_panel_v7_OutputFcn, ...
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


% --- Executes just before feedback_control_panel_v7 is made visible.
function feedback_control_panel_v7_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to feedback_control_panel_v7 (see VARARGIN)

% Choose default command line output for feedback_control_panel_v7
handles.output = hObject;

if ~isfield(handles, 'initCheck')
    handles.initCheck = 1;
    % figure out search path for save location
    SpecDir = pwd;
    dropind = strfind(SpecDir, '\Box');
    handles.searchPath = strcat(SpecDir(1:dropind-1), '\Box Sync\MotionLab\Data\');
    % NI params
    handles.devices = daq.getDevices;
    handles.devID = handles.devices(1).ID;
    % channel names
    handles.signals{1} = 'Torque';
    handles.signals{2} = 'Velocity';
    handles.signals{3} = 'Position';
    handles.signals{4} = 'Cortex';
    % structure for ROM limits we'll need
    handles.ROM_LIMS.Away = NaN;
    handles.ROM_LIMS.Neutral = NaN;
    handles.ROM_LIMS.Toward = NaN;
    % countdown graphics
    handles.pushpng = imread('push.png');
    handles.onepng = imread('one.png');
    handles.twopng = imread('two.png');
    handles.threepng = imread('three.png');
    % put the graphics on individual axes to cycle through later
    imshow(handles.pushpng, 'Parent', handles.cppush)
    imshow(handles.onepng, 'Parent', handles.cpone)
    imshow(handles.twopng, 'Parent', handles.cptwo)
    imshow(handles.threepng, 'Parent', handles.cpthree)
    % hide those jawns for now
    set(handles.cppush, 'Visible', 'off')
    set(handles.cpone, 'Visible', 'off')
    set(handles.cptwo, 'Visible', 'off')
    set(handles.cpthree, 'Visible', 'off')

    set(get(handles.cppush, 'Children'), 'Visible', 'off')
    set(get(handles.cpone, 'Children'), 'Visible', 'off')
    set(get(handles.cptwo, 'Children'), 'Visible', 'off')
    set(get(handles.cpthree, 'Children'), 'Visible', 'off')
    % looping jawns for later
    handles.rpbs = {'setaway_tb'; 'setneutral_tb'; 'settoward_tb'};
    handles.rets = {'away_et'; 'neutral_et'; 'toward_et'};
    handles.rstrs = {'Away'; 'Neutral'; 'Toward'};
    % let's initialize our connections
    % computer names we care about
    handles.computer = getenv('COMPUTERNAME');
    handles.cortexcomp = 'PennMedicine-HP';
    handles.us01comp = 'MJ05Q5XU';
%     handles.us01comp = 'R90JUM6E';
    handles.us02comp = 'MJ04EXKC';
    % prep the tcpip connections
    handles.TCP_NAMES = {'tcp_us01'; 'tcp_us02'};
    handles.tcp_us01 = tcpip(handles.us01comp, 65001, 'NetworkRole', 'client');
    handles.tcp_us02 = tcpip(handles.us02comp, 65002, 'NetworkRole', 'client');
    % load in cortex libraries
    loadlibrary('Cortex_SDK.dll', 'MatlabCortex.h');
    handles.cortex_tname = [];
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes feedback_control_panel_v7 wait for user response (see UIRESUME)
% uiwait(handles.feedback_control_panel_v7);


% --- Outputs from this function are returned to the command line.
function varargout = feedback_control_panel_v7_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in constart_tb.
function constart_tb_Callback(hObject, eventdata, handles)
% hObject    handle to constart_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
go = get(hObject, 'Value');
c{1} = 'cpthree'; c{2} = 'cptwo'; c{3} = 'cpone'; c{4} = 'cppush';
if go
    for i = 1:4
        g = c{i};
        set(get(handles.(g), 'Children'), 'Visible', 'on')
        if i < 4
            pause(1)
            set(get(handles.(g), 'Children'), 'Visible', 'off')
        else
            set(hObject, 'UserData', 1)
        end
    end
end
guidata(feedback_control_panel_v7, handles)


% --- Executes on button press in starttrial_tb.
function starttrial_tb_Callback(hObject, eventdata, handles)
% hObject    handle to starttrial_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tnames = get(handles.trialselect, 'String');
tval = get(handles.trialselect, 'Value');
tnum = get(handles.tnumedit, 'String');
trial = tnames{tval};
handles.us_tname = sprintf('%s_%s', trial, tnum);

if contains(trial, 'isokintetic')
    velval = num2str(trial(end-2:end));
else
    velval = 0;
end
velstr = num2str(velval);
set(handles.tveltxt, 'String', strrep(strcat(velstr, '_deg/s'), '_', ' '))

if contains(trial, 'Choose')
    set(hObject, 'Value', 0)
else
    set(handles.constart_tb, 'Enable', 'on')
    set(handles.stoptrial_pb, 'Enable', 'on')
    set(hObject, 'Enable', 'off')
    
    cla(handles.torax)
    hold(handles.torax, 'on')
    
    SendStartSignal(handles);
    
    s = daq.createSession('ni');
    for i = 1:4
        sname = handles.signals{i};
        channel = i - 1;
        handles.(trial).ch.(sname) = addAnalogInputChannel(s, handles.devID, channel, 'Voltage');
        handles.(trial).ch.(sname).Name = sname;
        handles.(trial).ch.(sname).TerminalConfig = 'SingleEnded';
    end
    
    s.Rate = 1000;
    
    pl = addlistener(s, 'DataAvailable', @(src, event) CaptureTrialData_v7(src, event, handles));
    
    s.IsContinuous = true;
    s.startBackground();
    
    while s.IsRunning
        pause(0.5);
        CHECK = get(hObject, 'Value');
        if CHECK == 0
            set(handles.constart_tb, 'Value', 0)
            saveytime = get(handles.stoptrial_pb, 'UserData');
            break
        end
    end
    
    while saveytime == 1
        pause(0.5)
        saveytime = get(handles.stoptrial_pb, 'UserData');
    end
    s.stop()
    delete(pl)
    release(s)
    
    guidata(feedback_control_panel_v7, handles)
end


function tnumedit_Callback(hObject, eventdata, handles)
% hObject    handle to tnumedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tnumedit as text
%        str2double(get(hObject,'String')) returns contents of tnumedit as a double


% --- Executes during object creation, after setting all properties.
function tnumedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tnumedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stoptrial_pb.
function stoptrial_pb_Callback(hObject, eventdata, handles)
% hObject    handle to stoptrial_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
recording = get(handles.starttrial_tb, 'Value');

if recording == 1
    set(handles.starttrial_tb, 'Value', 0)
    set(handles.starttrial_tb, 'Enable', 'on')
    
    set(handles.constart_tb, 'Value', 0)
    set(handles.constart_tb, 'Enable', 'off')
    
    set(hObject, 'Enable', 'off')
    
    set(handles.trialselect, 'Enable', 'on')
    set(handles.tnumedit, 'Enable', 'on')
    tstr = get(handles.tnumedit, 'String');
    tnum = str2double(tstr) + 1;
    set(handles.tnumedit, 'String', sprintf('%02d', tnum))
    
    % set userdata to 1 for saveytime
    set(hObject, 'UserData', 1)
    SendStopSignal(handles);
    guidata(feedback_control_panel_v7, handles)
end


% --- Executes on selection change in trialselect.
function trialselect_Callback(hObject, eventdata, handles)
% hObject    handle to trialselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
trials = get(hObject, 'String');
tval = get(hObject, 'Value');

cor = get(handles.cortex_tb, 'Value');

tname = trials{tval};

if tval == 1
    set(handles.tnumedit, 'Enable', 'off', 'String', '01')
    set(handles.starttrial_tb, 'Enable', 'off')
    set(handles.stoptrial_pb, 'Enable', 'off')
    set(handles.constart_tb, 'Enable', 'off')
    send2cortex = 'SetOutputName=';
else
    send2cortex = sprintf('SetOutputName=%s_', tname);
    TrialNameCheck(tname, handles);
    set(handles.tnumedit, 'Enable', 'on')
    set(handles.starttrial_tb, 'Enable', 'on')
    if contains(tname, '_RE') || contains(tname, 'LF') || contains(tname, '_fatigue_R')
        set(handles.rks_rb, 'Value', 1);
    elseif contains(tname, '_LE') || contains(tname, 'RF') || contains(tname, '_fatigue_L')
        set(handles.lks_rb, 'Value', 1);
    end
end

if cor
    str = 'NULL';
    mResponse = libpointer('voidPtrPtr', [int8(str) 0]);
    mBytes = libpointer('int32Ptr', 0);
    [ret, ~, ~, ~] = calllib('Cortex_SDK', 'Cortex_Request', send2cortex, mResponse, mBytes);
    if ret ~= 0
        disp('Could not rename Cortex trial name');
    end
end
guidata(feedback_control_panel_v7, handles)

% Hints: contents = cellstr(get(hObject,'String')) returns trialselect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from trialselect


% --- Executes during object creation, after setting all properties.
function trialselect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialselect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setsid_pb.
function setsid_pb_Callback(hObject, eventdata, handles)
% hObject    handle to setsid_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.savePath = uigetdir(handles.searchPath, 'Select subject''s Biodex data folder');

pstr = handles.savePath;
if contains(pstr, 'Pilot\')
    pri = strfind(pstr, 'Pilot\');
else
    pri = strfind(pstr, 'Data\');
end

sli = strfind(pstr(pri:end), '\');
for i = 1:length(sli)
    sst(i,1) = pri + sli(i);
    if i < length(sli)
        ssp(i,1) = pri + sli(i+1) - 2;
    else
        ssp(i,1) = length(pstr);
    end
end
biocheck = pstr(sst(4):ssp(4));
if strcmp(biocheck, 'Biodex')
    handles.project = pstr(sst(1):ssp(1));
    handles.subID = pstr(sst(2):ssp(2));
    handles.session = pstr(sst(3):ssp(3));
else
    handles.subID = 0;
end

if handles.subID == 0
    set(handles.subid_st, 'String', 'Selection failed')
    set(handles.trialselect, 'Enable', 'off')
else
    set(handles.subid_st, 'String', handles.subID)
    set(handles.trialselect, 'Enable', 'on')
    set(handles.setROM_et, 'Enable', 'on')
end

if contains(handles.subID, 'GAP')
    handles.projectTrials = textread('GAP_trials.txt', '%s', 'delimiter', '\n');
    set(handles.trialselect, 'String', handles.projectTrials);
elseif contains(handles.subID, 'CS')
    handles.projectTrials = textread('ACL_trials.txt', '%s', 'delimiter', '\n');
    set(handles.trialselect, 'String', handles.projectTrials);
elseif contains(handles.subID, 'OCP')
    handles.projectTrials = textread('OCP_trials.txt', '%s', 'delimiter', '\n');
    set(handles.trialselect, 'String', handles.projectTrials);
elseif contains(handles.subID, 'IDD')
    handles.projectTrials = textread('IDD_trials.txt', '%s', 'delimiter', '\n');
    set(handles.trialselect, 'String', handles.projectTrials);
end

guidata(feedback_control_panel_v7, handles)


% --- Executes on button press in rks_rb.
function rks_rb_Callback(hObject, eventdata, handles)
% hObject    handle to rks_rb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rks_rb


% --- Executes on button press in setROM_tb.
function setROM_tb_Callback(hObject, eventdata, handles)
% hObject    handle to setROM_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of setROM_tb
butt = get(hObject, 'Value');
if butt
    spath = handles.savePath;
    matp = fullfile(spath, 'ROM_vals.mat');
    
    aval = get(handles.away_et, 'String');
    nval = get(handles.neutral_et, 'String');
    tval = get(handles.toward_et, 'String');
    
    ROM_vals.Away = aval;
    ROM_vals.Neutral = nval;
    ROM_vals.Towards = tval;
    
    save(matp, 'ROM_vals');
    handles.ROM_vals = ROM_vals;
    
    set(hObject, 'Value', 0);
    
    guidata(feedback_control_panel_v7, handles)
    
%     if isfield(handles, 'subROM')
%         for n = 1:3
%             pb = handles.rpbs{n}; et = handles.rets{n};
%             set(handles.(pb), 'Value', 0, 'Enable', 'on')
%             set(handles.(et), 'Enable', 'on')
%         end
%         set(handles.confirmROM_pb, 'Enable', 'on');
%         cla(handles.torax)
%         hold(handles.torax, 'on')
%         
%         s = daq.createSession('ni');
%         trial = 'set_ROM';
%         for i = 1:3
%             sname = handles.signals{i};
%             channel = i - 1;
%             handles.(trial).ch.(sname) = addAnalogInputChannel(s, handles.devID, channel, 'Voltage');
%             handles.(trial).ch.(sname).Name = sname;
%             handles.(trial).ch.(sname).TerminalConfig = 'SingleEnded';
%         end
% 
%         s.Rate = 1000;
% 
%         pl = addlistener(s, 'DataAvailable', @(src, event) CaptureROMData(src, event, handles));
% 
%         s.IsContinuous = true;
%         s.startBackground();
% 
%         while s.IsRunning
%             pause(0.5);
%             CHECK = get(handles.setROM_tb, 'Value');
%             if CHECK == 0
%                 for n = 1:3
%                     pb = handles.rpbs{n}; et = handles.rets{n};
%                     set(handles.(pb), 'Value', 0, 'Enable', 'off')
%                     set(handles.(et), 'Enable', 'off')
%                 end
%                 saveytime = get(handles.confirmROM_pb, 'UserData');
%                 break
%             end
%         end
% 
%         while saveytime == 1
%             pause(0.5)
%             saveytime = get(handles.confirmROM_pb, 'UserData');
%         end
%         s.stop()
%         delete(pl)
%         release(s)
%         guidata(feedback_control_panel_v7, handles)
%     end
end


% --- Executes on button press in confirmROM_pb.
function confirmROM_pb_Callback(hObject, eventdata, handles)
% hObject    handle to confirmROM_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
recording = get(handles.setROM_tb, 'Value');

if recording
    set(handles.setROM_tb, 'Value', 0)
%     set(handles.setROM_tb, 'Enable', 'off')
    
    for n = 1:3
        pb = handles.rpbs{n}; et = handles.rets{n};
        set(handles.(pb), 'Value', 0, 'Enable', 'off')
        set(handles.(et), 'Enable', 'off')
    end
    
    set(hObject, 'Enable', 'off')
    
    % set userdata to 1 for saveytime
    set(hObject, 'UserData', 1)
end


% --- Executes on button press in setaway_tb.
function setaway_tb_Callback(hObject, eventdata, handles)
% hObject    handle to setaway_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
go = get(hObject, 'Value');
if go
    for n = 2:3
        pb = handles.rpbs{n}; et = handles.rets{n};
        set(handles.(pb), 'Value', 0, 'Enable', 'off')
        set(handles.(et), 'Enable', 'off')
    end
    
    set(handles.totROM_st, 'UserData', 1);
    set(hObject, 'UserData', 1);
    
    wv = get(hObject, 'UserData');
    while wv
        pause(0.5)
        wv = get(hObject, 'UserData');
    end

    for n = 2:3
        pb = handles.rpbs{n}; et = handles.rets{n};
        set(handles.(pb), 'Value', 0, 'Enable', 'on')
        set(handles.(et), 'Enable', 'on')
    end
end


% --- Executes on button press in setneutral_tb.
function setneutral_tb_Callback(hObject, eventdata, handles)
% hObject    handle to setneutral_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
go = get(hObject, 'Value');
if go
    for n = [1,3]
        pb = handles.rpbs{n}; et = handles.rets{n};
        set(handles.(pb), 'Value', 0, 'Enable', 'off')
        set(handles.(et), 'Enable', 'off')
    end
    
    set(handles.totROM_st, 'UserData', 2)
    set(hObject, 'UserData', 1)
    
    wv = get(hObject, 'UserData');
    while wv
        pause(0.5)
        wv = get(hObject, 'UserData');
    end
    
    for n = [1,3]
        pb = handles.rpbs{n}; et = handles.rets{n};
        set(handles.(pb), 'Value', 0, 'Enable', 'on')
        set(handles.(et), 'Enable', 'on')
    end
end


% --- Executes on button press in settoward_tb.
function settoward_tb_Callback(hObject, eventdata, handles)
% hObject    handle to settoward_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
go = get(hObject, 'Value');
if go
    for n = 1:2
        pb = handles.rpbs{n}; et = handles.rets{n};
        set(handles.(pb), 'Value', 0, 'Enable', 'off')
        set(handles.(et), 'Enable', 'off')
    end
    
    set(handles.totROM_st, 'UserData', 3)
    set(hObject, 'UserData', 1)
    
    wv = get(hObject, 'UserData');
    while wv
        pause(0.5)
        wv = get(hObject, 'UserData');
    end

    for n = 1:2
        pb = handles.rpbs{n}; et = handles.rets{n};
        set(handles.(pb), 'Value', 0, 'Enable', 'on')
        set(handles.(et), 'Enable', 'on')
    end
end


function away_et_Callback(hObject, eventdata, handles)
% hObject    handle to away_et (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of away_et as text
%        str2double(get(hObject,'String')) returns contents of away_et as a double
rnum = str2double(get(hObject, 'String'));
if isnan(rnum)
    set(hObject, 'String', 'SET')
else
    handles.ROM_LIMS.Away = rnum;
    romCheck = [NaN; NaN; NaN];
    for n = 1:3
        et = handles.rstrs{n};
        romCheck(n,1) = handles.ROM_LIMS.(et);
    end
    if ~any(isnan(romCheck))
        set(handles.setROM_tb, 'Enable', 'on');
    end
    guidata(feedback_control_panel_v7, handles);
end


function neutral_et_Callback(hObject, eventdata, handles)
% hObject    handle to neutral_et (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neutral_et as text
%        str2double(get(hObject,'String')) returns contents of neutral_et as a double
rnum = str2double(get(hObject, 'String'));
if isnan(rnum)
    set(hObject, 'String', 'SET')
else
    handles.ROM_LIMS.Neutral = rnum;
    romCheck = [NaN; NaN; NaN];
    for n = 1:3
        et = handles.rstrs{n};
        romCheck(n,1) = handles.ROM_LIMS.(et);
    end
    if ~any(isnan(romCheck))
        set(handles.setROM_tb, 'Enable', 'on');
    end
    guidata(feedback_control_panel_v7, handles);
end


function toward_et_Callback(hObject, eventdata, handles)
% hObject    handle to toward_et (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of toward_et as text
%        str2double(get(hObject,'String')) returns contents of toward_et as a double
rnum = str2double(get(hObject, 'String'));
if isnan(rnum)
    set(hObject, 'String', 'SET')
else
    handles.ROM_LIMS.Toward = rnum;
    romCheck = [NaN; NaN; NaN];
    for n = 1:3
        et = handles.rstrs{n};
        romCheck(n,1) = handles.ROM_LIMS.(et);
    end
    if ~any(isnan(romCheck))
        set(handles.setROM_tb, 'Enable', 'on');
    end
    guidata(feedback_control_panel_v7, handles);
end


% --- Executes on button press in us02_tb.
function us02_tb_Callback(hObject, eventdata, handles)
% hObject    handle to us02_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
butt = get(hObject, 'Value');

if butt
    try
        fopen(handles.tcp_us02);
    catch ME
        if strcmp(ME.identifier, 'instrument:fopen:opfailed')
            set(hObject, 'Value', 0);
            set(hObject, 'String', 'RETRY');
            set(handles.us02_st, 'String', 'US01: Client is not running');
        else
            set(hObject, 'Value', 0);
            set(hObject, 'String', 'RETRY');
            set(handles.us02_st, 'String', 'US01: Unable to connect to client');
        end
        return
    end
    set(hObject, 'String', 'DISCONNECT');
    set(handles.us02_st, 'String', 'US01: Connected');
else
    if strcmp(handles.tcp_us02.Status, 'open')
        fprintf(handles.tcp_us02, 'later nerd');
        fclose(handles.tcp_us02);
    end
    set(hObject, 'String', 'DISCONNECT');
    set(handles.us02_st, 'String', 'US01: Disconnected');
end


% --- Executes on button press in us01_tb.
function us01_tb_Callback(hObject, eventdata, handles)
% hObject    handle to us01_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
butt = get(hObject, 'Value');

if butt
    try
        fopen(handles.tcp_us01);
    catch ME
        if strcmp(ME.identifier, 'instrument:fopen:opfailed')
            set(hObject, 'Value', 0);
            set(hObject, 'String', 'RETRY');
            set(handles.us01_st, 'String', 'US01: Client is not running');
        else
            set(hObject, 'Value', 0);
            set(hObject, 'String', 'RETRY');
            set(handles.us01_st, 'String', 'US01: Unable to connect to client');
        end
        return
    end
    set(hObject, 'String', 'DISCONNECT');
    set(handles.us01_st, 'String', 'US01: Connected');
else
    if strcmp(handles.tcp_us01.Status, 'open')
        fprintf(handles.tcp_us01, 'later nerd');
        fclose(handles.tcp_us01);
    end
    set(hObject, 'String', 'CONNECT');
    set(handles.us01_st, 'String', 'US01: Disconnected');
end



% --- Executes on button press in cortex_tb.
function cortex_tb_Callback(hObject, eventdata, handles)
% hObject    handle to cortex_tb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
bs = get(hObject, 'Value');
if bs
    ret = calllib('Cortex_SDK', 'Cortex_Initialize', handles.computer, 'PennMedicine-HP', '0', '0', '-1');
    if ret ~= 0
        disp('unable to initialize cortex connection, renaming will not be possible')
        set(hObject, 'Value', 0);
        return
    end
    hostVals = get(lib.sHostInfo);
    
    handles.mHostInfo = libstruct('sHostInfo', hostVals);
    [ret, handles.mHostInfo] = calllib('Cortex_SDK', 'Cortex_GetHostInfo', handles.mHostInfo);
    if ret ~= 0
        disp('unable to connect to cortex, renaming will not occur');
        set(hObject, 'Value', 0);
        return
    else
        set(hObject, 'String', 'Disconnect');
        set(handles.cortex_st, 'String', 'Cortex: Connected');
    end
else
    calllib('Cortex_SDK', 'Cortex_Exit');
    set(hObject, 'String', 'Connect');
    set(handles.cortex_st, 'String', 'Cortex: Disconnected');
end

guidata(feedback_control_panel_v7, handles)


function setROM_et_Callback(hObject, eventdata, handles)
% hObject    handle to setROM_et (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of setROM_et as text
%        str2double(get(hObject,'String')) returns contents of setROM_et as a double
rnum = str2double(get(hObject, 'String'));

romw = 'The ROM you entered is not a valid number. Please enter an integer and try again.';
romb = 'The ROM you entered is quite large, are you sure that''s correct?';
if isnan(rnum)
    romjawn = warndlg(romw, 'BAD ROM');
    uiwait(romjawn);
    set(hObject, 'String', 'SET');
    set(handles.setROM_tb, 'Enable', 'off');
    return
elseif rnum > 100
    check = questdlg(romb, 'ROM of Unusual Size', 'No');
    switch check
        case 'Yes'
            handles.subROM = rnum;
            set(handles.setROM_tb, 'Enable', 'on');
        case 'No'
            set(hObject, 'String', 'SET');
            return
        case 'Cancel'
            return
    end
else
    handles.subROM = rnum;
    for n = 1:3
        et = handles.rets{n};
        set(handles.(et), 'Enable', 'on');
    end
%     set(handles.setROM_tb, 'Enable', 'on');
end
guidata(feedback_control_panel_v7, handles)



% --- Executes during object creation, after setting all properties.
function setROM_et_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setROM_et (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function feedback_control_panel_v7_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to feedback_control_panel_v7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isfield(handles, 'initCheck')
    calllib('Cortex_SDK', 'Cortex_Exit');
    unloadlibrary('Cortex_SDK');

    fclose(handles.tcp_us01);
    fclose(handles.tcp_us02);
end

delete(hObject);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Global GUI Scripts ------------------------------------------------ %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Sends the start signals to any TCP connected computers
function SendStartSignal(handles)
for i = 1:length(handles.TCP_NAMES)
    tn = handles.TCP_NAMES{i};
    if strcmp(handles.(tn).Status, 'open')
        fprintf(handles.(tn), 'go time');
        resp = 0;
        while ~resp
            if handles.(tn).BytesAvailable > 1
                rec = fscanf(handles.(tn));
                le = regexp(rec, '\n');
%                 fprintf('%s', rec)
                if strcmp(rec(1:le-1), 'gimme the jawn')
                    resp = 1;
                end
            end
        end
        fprintf(handles.(tn), handles.us_tname);
    end
end

% --- Sends the stop signals to any TCP connected computers
function SendStopSignal(handles)
for i = 1:length(handles.TCP_NAMES)
    tn = handles.TCP_NAMES{i};
    if strcmp(handles.(tn).Status, 'open')
        fprintf(handles.(tn), 'woah nelly');
    end
end


% --- Check to see if any mat files for a given trial already exist
function TrialNameCheck(tname, handles)
spath = handles.savePath;

mdir = dir(fullfile(spath, [tname, '*.mat']));
if isempty(mdir)
    set(handles.tnumedit, 'String', '01')
else
    prev = length(mdir);
    ntn = prev + 1;
    set(handles.tnumedit, 'String', sprintf('%02d', ntn));
end
