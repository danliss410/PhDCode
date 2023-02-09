function [ asm, cmd ] = controlEchowave
%CONTROLECHOWAVE Sets up objects for DLL commands
%   Provides the user with asm and cmd objects which can be used to send
%   controls through to the 
% set path to Echo Wave II automation interface client .Net assembly (dll)
if strcmp(computer('arch'), 'win64') == 1 
    asm_path = 'C:\Program Files (x86)\TELEMED\Echo Wave II\Config\Plugins\AutoInt1Client.dll'; % changed cases since that's normally important 11/06/18 1:52PM
else
    asm_path = 'C:\Program Files\TELEMED\Echo Wave II\Config\Plugins\autoint1client.dll';
end
    
% load assembly
asm = NET.addAssembly(asm_path);

% create commands interface object
cmd = AutoInt1Client.CmdInt1();

% connect to started Echo Wave II software
ret = cmd.ConnectToRunningProgram();
if ret ~= 0 % removed paranthesis because it's the current year 11/06/18 1:49PM
    msgbox('Error. Cannot connect to Echo Wave II software. Please make sure that software is running.', 'Error')
    return % used return instead of break since this isn't a loop 11/06/18 1:49PM
%     break;
end

end

