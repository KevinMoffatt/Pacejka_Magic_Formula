function varargout = Pacejka_Plot_Tool(varargin)
% PACEJKA_PLOT_TOOL M-file for Pacejka_Plot_GUI.fig
% PACEJKA_PLOT_TOOL, by itself, creates a new PACEJKA_PLOT_TOOL or raises the
%      existing singleton*.
%
% H = PACEJKA_PLOT_TOOL returns the handle to a new PACEJKA_PLOT_TOOL or the handle
%      to the existing singleton*.
%
% PACEJKA_PLOT_TOOL('CALLBACK',hObject,eventData,handles,...) calls the local
% function named CALLBACK in PACEJKA_PLOT_TOOL.M with the given input arguments. %
% PACEJKA_PLOT_TOOL('Property','Value',...) creates a new PACEJKA_PLOT_TOOL or
% raises the existing singleton*. Starting from the left, property value pairs are
% applied to the GUI before Pacejka_Plot_Tool_OpeningFcn gets called. An
% unrecognized property name or invalid value makes property application
% stop. All inputs are passed to Pacejka_Plot_Tool_OpeningFcn via varargin. %
% *See GUI Options on GUIDE's Tools menu. Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help Pacejka_Plot_Tool
% Last Modified by GUIDE v2.5 14-Sep-2010 9:35:14
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name', mfilename, ...
'gui_Singleton', gui_Singleton, ... 'gui_OpeningFcn', @Pacejka_Plot_Tool_OpeningFcn, ... 'gui_OutputFcn', @Pacejka_Plot_Tool_OutputFcn, ... 'gui_LayoutFcn', [] , ...
'gui_Callback', []);
if nargin && ischar(varargin{1}) gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
[varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
% --- Executes just before Pacejka_Plot_GUI is made visible.
function Pacejka_Plot_Tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject handle to figure
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
% varargin command line arguments to Pacejka_Plot_GUI (see VARARGIN)
% Choose default command line output for Pacejka_Plot_GUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% Set up the initial plot - only do when we are invisible % so window can get raised using Pacejka_Plot_GUI.
if strcmp(get(hObject,'Visible'),'off')
% Find tire data files in current directory to populate list box
initial_dir = pwd; load_listbox(initial_dir,handles)
% Check if list was populated from current directory list_entries = get(handles.lstFn, 'String');
if isempty(list_entries)
        % See if tire data is located in Tire Data folder
        tempPath = fliplr(pwd);
        [~, rem] = strtok(tempPath, '\');
        new_dir = [fliplr(rem) 'Tire Data\'];
        load_listbox(new_dir, handles);
        % If list is still empty, ask user for location
list_entries = get(handles.lstFn, 'String'); if isempty(list_entries)
h = msgbox('Select a tire data file.','modal'); uiwait(h);
% Prompt user to choose file/folder where data is located btnChangePath_Callback(hObject, eventdata, handles);
else
popPlotType_Callback(hObject, eventdata, handles); end
else
% Tire data was found, plot selected data

        % Plot selected data
popPlotType_Callback(hObject, eventdata, handles); end
end
degrees = radtodeg(str2double(get(handles.txtGamma, 'String'))); text_deg = sprintf('(%2.1f deg)',degrees);
set(handles.lblDeg, 'String',text_deg);
% --- Outputs from this function are returned to the command line.
function varargout = Pacejka_Plot_Tool_OutputFcn(hObject, eventdata, handles)
% varargout
% hObject
% eventdata
% handles
% cell array for returning output args (see VARARGOUT); handle to figure
% reserved - to be defined in a future version of MATLAB structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes on button press in btnChangePath.
function btnChangePath_Callback(hObject, eventdata, handles)
% hObject handle to btnChangePath (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB % handles structure with handles and user data (see GUIDATA)
% Gets a user-selected file using standard open dialog
[fn,path,FilterIndex] = uigetfile('*.tir','Select a tire data file');
% Load list box with *.tir files in selected folder
load_listbox(path, handles);
% Make the user-selected file become the selected file in the listbox
fn_index = strmatch(fn,get(handles.lstFn,'String')); set(handles.lstFn, 'Value', fn_index);
% Plot selected file
popPlotType_Callback(hObject, eventdata, handles);
% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject handle to FileMenu (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB % handles structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject handle to OpenMenuItem (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB % handles structure with handles and user data (see GUIDATA) file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end
% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject handle to PrintMenuItem (see GCBO)

% eventdata reserved - to be defined in a future version of MATLAB % handles structure with handles and user data (see GUIDATA) printdlg(handles.figure1)
% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject handle to CloseMenuItem (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB % handles structure with handles and user data (see GUIDATA) 
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
return; end
delete(handles.figure1)
function filename = getFn(handles)
% Get first selected value from list box
list_entries = get(handles.lstFn, 'String'); index_selected = get(handles.lstFn, 'Value');
dir_path = get(handles.txtPath, 'String');
filename = fullfile(dir_path,list_entries{index_selected(1)});
% --- Executes on selection change in popPlotType.
function popPlotType_Callback(hObject, eventdata, handles)
% hObject    handle to popPlotType (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns popPlotType contents as cell array
% contents{get(hObject,'Value')} returns selected item from popPlotType
% Get selected value from popup box
popup_sel_index = get(handles.popPlotType, 'Value');
% Get selected values from list box
list_entries = get(handles.lstFn, 'String'); index_selected = get(handles.lstFn, 'Value');
% Get current path from text box
dir_path = get(handles.txtPath, 'String');
for i = 1:length(index_selected)
% Construct file name from path and list box selection
curName = list_entries{index_selected(i)}; fn = fullfile(dir_path,curName);
% Parse Fz string/s into double
Fz_text = get(handles.txtFz, 'String');
Fz = str2double(regexp(Fz_text, '[0-9.e+-\s]*[^;]','match'));
% Get gamma from text box and convert to double
gamma = str2double(get(handles.txtGamma, 'String'));



% Calculate kappa and alpha increments from user supplied max and min
kappa = calcIncrement(handles.txtKappaMin, handles.txtKappaMax, handles); 
alpha = calcIncrement(handles.txtAlphaMin, handles.txtAlphaMax, handles);
% Number of steps
n = str2double(get(handles.txtStep, 'String'));
% Make input matrices the same dimensions (i.e. 1x3 and 30x1 to 3x30)
Fz = make_square(Fz, n, ';');
kappa = make_square(kappa, size(Fz,2), ' '); 
alpha = make_square(alpha, size(Fz,2), ' ');
% Select pure or combined slip based on USE_MODE in tire file
S = ImportTireData(fn);
use_mode = gvar('USE_MODE',S);
if use_mode == 3
    % Calculate Fx and Fy for pure slip
    x = Fx(kappa,Fz,gamma,fn);
    y = Fy(alpha,Fz,gamma,fn);
elseif use_mode == 4
    % Calculate Fx and Fy for combined slip
    x = Fx(kappa,Fz,gamma,fn,alpha);
    y = Fy(alpha,Fz,gamma,fn,kappa);
else
msgbox(['Unrecognized USE_MODE in tire data file. USE_MODE = ' use_mode]) 
end
% Calculate moments
[Mx, My, Mz] = MomentCalc(fn, Fz, x, y, gamma, alpha);
% Plot forces and moments based on user-selected plot type
xlabel_text = 'slip (% or rad)';
switch popup_sel_index
    case 1 % Fx and Fy
        plot1 = plot(kappa,x,'Color','b');
        hold on;
        plot2 = plot(alpha,y,'Color','g');
        xlabel(xlabel_text)
        ylabel('Force (N)')
        % Set line type and legend entries
        formatExpr = '%s (Fz = %2.3g kN)';
        for j = 1:size(Fz,2)
            if j == 2     % dashed
                set(plot1(j),'LineStyle','--')
                set(plot2(j),'LineStyle','--')
            elseif j == 3 % dotted
                set(plot1(j),'LineStyle',':')
                set(plot2(j),'LineStyle',':')
            elseif j == 4 % dash-dot
                set(plot1(j),'LineStyle','-.')
                set(plot2(j),'LineStyle','-.')
            end
            set(plot1(j),'DisplayName',sprintf(formatExpr,'Fx',Fz(1,j)/1000)); set(plot2(j),'DisplayName',sprintf(formatExpr,'Fy',Fz(1,j)/1000));
end
        legend(handles.axes1,'show');
    case 2 % Mx, My, and Mz
    plot1 = plot(alpha,Mx,'Color','r');
    hold on;
    plot2 = plot(alpha,My,'Color','m');
    plot3 = plot(alpha,Mz,'Color','c');
    xlabel(xlabel_text)
    ylabel('Moment (N m)')
    % Set line type and legend entries
    formatExpr = '%s (Fz = %2.3g kN)';
    for j = 1:size(Fz,2)
        if j == 2      % dashed
            set(plot1(j),'LineStyle','--')
            set(plot2(j),'LineStyle','--')
            set(plot3(j),'LineStyle','--')
        elseif j == 3  % dotted
            set(plot1(j),'LineStyle',':')
            set(plot2(j),'LineStyle',':')
            set(plot3(j),'LineStyle',':')
        elseif j == 4  % dash-dot
            set(plot1(j),'LineStyle','-.')
            set(plot2(j),'LineStyle','-.')
            set(plot3(j),'LineStyle','-.')
        end
        set(plot1(j),'DisplayName',sprintf(formatExpr,'Mx',Fz(1,j)/1000)); set(plot2(j),'DisplayName',sprintf(formatExpr,'My',Fz(1,j)/1000)); set(plot3(j),'DisplayName',sprintf(formatExpr,'Mz',Fz(1,j)/1000));
end
    legend(handles.axes1,'show');
case 3 % Fx only
plot1 = plot(kappa,x,'Color','b');hold on; ylabel('Force (N)')
xlabel(xlabel_text)
    % Set line type and legend entries
    formatExpr = 'Fz = %2.3g kN';
    for j = 1:size(Fz,2)
if j == 2
% dashed
            set(plot1(j),'LineStyle','--')
        elseif j == 3
% dotted
            set(plot1(j),'LineStyle',':')
        elseif j == 4
% dash-dot
            set(plot1(j),'LineStyle','-.')
        end
set(plot1(j),'DisplayName',sprintf(formatExpr,Fz(1,j)/1000)); end
    legend(handles.axes1,'show');
case 4 % Fy only
plot1 = plot(alpha,y,'Color','g');hold on; ylabel('Force (N)')
xlabel(xlabel_text)
    % Set line type and legend entries
    formatExpr = 'Fz = %2.3g kN';
    for j = 1:size(Fz,2)
        if j == 2      % dashed
            set(plot1(j),'LineStyle','--')

        elseif j == 3  % dotted
            set(plot1(j),'LineStyle',':')
        elseif j == 4  % dash-dot
            set(plot1(j),'LineStyle','-.')
end
set(plot1(j),'DisplayName',sprintf(formatExpr,Fz(1,j)/1000)); end
    legend(handles.axes1,'show');
case 5 % Mx only
plot1 = plot(alpha,Mx,'Color','r');hold on; xlabel(xlabel_text)
ylabel('Moment (N m)')
    % Set line type and legend entries
    formatExpr = 'Fz = %2.3g kN';
    for j = 1:size(Fz,2)
if j == 2
% dashed
            set(plot1(j),'LineStyle','--')
        elseif j == 3
% dotted
            set(plot1(j),'LineStyle',':')
        elseif j == 4
% dash-dot
            set(plot1(j),'LineStyle','-.')
        end
set(plot1(j),'DisplayName',sprintf(formatExpr,Fz(1,j)/1000)); end
    legend(handles.axes1,'show');
case 6 % My only
plot1 = plot(alpha,My,'Color','m');hold on; xlabel(xlabel_text)
ylabel('Moment (N m)')
    % Set line type and legend entries
    formatExpr = 'Fz = %2.3g kN';
    for j = 1:size(Fz,2)
        if j == 2      % dashed
            set(plot1(j),'LineStyle','--')
        elseif j == 3  % dotted
            set(plot1(j),'LineStyle',':')
        elseif j == 4  % dash-dot
            set(plot1(j),'LineStyle','-.')
end
set(plot1(j),'DisplayName',sprintf(formatExpr,Fz(1,j)/1000)); end
    legend(handles.axes1,'show');
case 7 % Mz only
plot1 = plot(alpha,Mz,'Color','c');hold on; xlabel(xlabel_text)
ylabel('Moment (N m)')
    % Set line type and legend entries
    formatExpr = 'Fz = %2.3g kN';
    for j = 1:size(Fz,2)
        if j == 2        % dashed
            set(plot1(j),'LineStyle','--')
        elseif j == 3    % dotted
            set(plot1(j),'LineStyle',':')
        elseif j == 4    % dash-dot
            set(plot1(j),'LineStyle','-.')

end
set(plot1(j),'DisplayName',sprintf(formatExpr,Fz(1,j)/1000)); end
    legend(handles.axes1,'show');
case 8 % All forces and moments
hFxPlot = plot(kappa,x,'Color','b'); hold on;
hFyPlot = plot(alpha,y,'Color','g'); hMxPlot = plot(alpha,Mx,'Color','r'); hMyPlot = plot(alpha,My,'Color','m'); hMzPlot = plot(alpha,Mz,'Color','c');
    xlabel(xlabel_text)
    ylabel('Force (N) / Moment (N m)')
% Group together so
hFxGroup = hggroup;
hFyGroup = hggroup;
hMxGroup = hggroup;
hMyGroup = hggroup;
hMzGroup = hggroup;
multiple lines do not show on legend
set(hFxPlot,'Parent',hFxGroup)
set(hFyPlot,'Parent',hFyGroup)
set(hMxPlot,'Parent',hMxGroup)
set(hMyPlot,'Parent',hMyGroup)
set(hMzPlot,'Parent',hMzGroup)
% Include these hggroups in the legend:
set(get(get(hFxGroup,'Annotation'),'LegendInformation'),'IconDisplayStyle','on');
set(get(get(hFyGroup,'Annotation'),'LegendInformation'),'IconDisplayStyle','on');
set(get(get(hMxGroup,'Annotation'),'LegendInformation'),'IconDisplayStyle','on');
set(get(get(hMyGroup,'Annotation'),'LegendInformation'),'IconDisplayStyle','on');
set(get(get(hMzGroup,'Annotation'),'LegendInformation'),'IconDisplayStyle','on');
% Show legend
legend('Fx','Fy','Mx','My','Mz')
% Change line size of multiple Fz plots
for j = 1:size(Fz,2)
    if j == 2 % dashed
set(hFxPlot(j),'LineStyle','--') 
set(hFyPlot(j),'LineStyle','--') 
set(hMxPlot(j),'LineStyle','--') 
set(hMyPlot(j),'LineStyle','--') 
set(hMzPlot(j),'LineStyle','--')
    elseif j == 3 % dotted
        set(hFxPlot(j),'LineStyle',':')
        set(hFyPlot(j),'LineStyle',':')
        set(hMxPlot(j),'LineStyle',':')
        set(hMyPlot(j),'LineStyle',':')
        set(hMzPlot(j),'LineStyle',':')
elseif j == 4 % dash-dot set(hFxPlot(j),'LineStyle','-.') set(hFyPlot(j),'LineStyle','-.') set(hMxPlot(j),'LineStyle','-.')

set(hMyPlot(j),'LineStyle','-.')
set(hMzPlot(j),'LineStyle','-.') 
    end
end
hold off;
end
end

function trans_var = calcIncrement(hMin, hMax, handles)
% calcIncrement returns an array with the number of
% txtStep (Resolution) between the text box of that % and the text box of that handle hMax specifies.
% Input:
% increments specified by
% handle hMin specifies
% (see GUIDATA)
% hMin
% hMax
% handles
% handle to textbox with minimum value
% handle to textbox with maximum value
% structure with handles and user data
% Get values for Min and Max
Min = str2double(get(hMin, 'String')); Max = str2double(get(hMax,'String'));
% Number of steps
n = str2double(get(handles.txtStep, 'String'));
% Increment size
inc = (Max - Min)/(n-1);
increm_var = Min:inc:Max;
% Transposes array
trans_var = increm_var';

function square = make_square(unsquare, n, delim)
% make_square changes a 1x3 matrix to a nx3 matrix if delim = ';'
% make_square changes an 30x1 matrix to a 30xn matrix if delim = ' ' (or % anything else)
square = [];
if delim == ';'
    for i = 1:n
        square = [square; unsquare];
    end
else % delim = ' '
    for i = 1:n
        square = [square unsquare];
    end
end

% --- Executes during object creation, after setting all properties.
function popPlotType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popPlotType (see GCBO)
if ispc && isequal(get(hObject,'BackgroundColor'),get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white'); 
end
% Set plot type options

set(hObject, 'String', {'Fx & Fy', 'Mx, My, & Mz', 'Fx', 'Fy', 'Mx', 'My', 'Mz', 'All'});
function txtLowB_Callback(hObject, eventdata, handles)
% handles structure with handles and user data (see GUIDATA)
popPlotType_Callback(hObject, eventdata, handles);
% --- Executes during object creation, after setting all properties. function txtLowB_CreateFcn(hObject, eventdata, handles)
% hObject handle to txtLowB (see GCBO)
if ispc && isequal(get(hObject,'BackgroundColor'),get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white'); 
end
set(hObject, 'String', '-0.4');
function txtUpperB_Callback(hObject, eventdata, handles)
% handles structure with handles and user data (see GUIDATA)
popPlotType_Callback(hObject, eventdata, handles);
% --- Executes during object creation, after setting all properties.
function txtUpperB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtUpperB (see GCBO)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white'); 
end
set(hObject, 'String', '0.4');
function txtStep_Callback(hObject, eventdata, handles)
% handles structure with handles and user data (see GUIDATA)
popPlotType_Callback(hObject, eventdata, handles);
function txtStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtStep (see GCBO)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white'); 
end
% Set Default String
set(hObject, 'String', '30');
function lstFn_Callback(hObject, eventdata, handles)
% hObject handle to lstFn (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB % handles structure with handles and user data (see GUIDATA)
% Set automatically updated force if checked
if get(handles.chkUpdate, 'Value') == get(handles.chkUpdate, 'Max') 
    S = ImportTireData(getFn(handles));
FzMin = gvar('FZMIN',S);
FzMax = gvar('FZMAX',S);

FzAvg = (FzMax+FzMin)/2;
FzRange = sprintf('%d;%d;%d',FzMin,FzAvg,FzMax); 
set(handles.txtFz, 'String', FzRange);
end
% Refresh plot
popPlotType_Callback(hObject, eventdata, handles);
% --- Executes during object creation, after setting all properties.
function lstFn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lstFn (see GCBO)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white'); 
end
function load_listbox(dir_path, handles)
dir_struct = dir(fullfile(dir_path,'*.tir')); 
[sorted_names,sorted_index] = sortrows({dir_struct.name}'); 
set(handles.lstFn,'String',sorted_names,...
'Value',1) 
set(handles.txtPath,'String',dir_path)
% --- Executes during object creation, after setting all properties.
function txtPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtPath (see GCBO)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white'); 
end
function txtGamma_Callback(hObject, eventdata, handles)
% handles structure with handles and user data (see GUIDATA)
% Update lblDeg
degrees = radtodeg(str2double(get(handles.txtGamma, 'String'))); text_deg = sprintf('(%2.1f deg)',degrees);
set(handles.lblDeg, 'String',text_deg);
popPlotType_Callback(hObject, eventdata, handles);
function txtGamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtGamma (see GCBO)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white'); end
% --- Executes on button press in chkUpdate.
function chkUpdate_Callback(hObject, eventdata, handles)
% hObject handle to chkUpdate (see GCBO)
% eventdata reserved - to be defined in a future version of MATLAB % handles structure with handles and user data (see GUIDATA) lstFn_Callback(hObject, eventdata, handles);
function txtAlphaMin_Callback(hObject, eventdata, handles)

% handles structure with handles and user data (see GUIDATA)
set(handles.chkUpdate, 'Value', get(handles.chkUpdate, 'Min')) 
popPlotType_Callback(hObject, eventdata, handles);
% --- Executes during object creation, after setting all properties.
function txtAlphaMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtAlphaMin (see GCBO)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white'); 
end
function txtAlphaMax_Callback(hObject, eventdata, handles)
% handles structure with handles and user data (see GUIDATA)
set(handles.chkUpdate, 'Value',get(handles.chkUpdate, 'Min')) 
popPlotType_Callback(hObject, eventdata, handles);
function txtAlphaMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtAlphaMax (see GCBO)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white'); 
end
function txtKappaMin_Callback(hObject, eventdata, handles)
% handles structure with handles and user data (see GUIDATA)
set(handles.chkUpdate, 'Value', get(handles.chkUpdate, 'Min')) 
popPlotType_Callback(hObject, eventdata, handles);
function txtKappaMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtKappaMin (see GCBO)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white'); 
end
function txtKappaMax_Callback(hObject, eventdata, handles)
% handles structure with handles and user data (see GUIDATA)
set(handles.chkUpdate, 'Value',get(handles.chkUpdate, 'Min')) 
popPlotType_Callback(hObject, eventdata, handles);
function txtKappaMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtKappaMax (see GCBO)
if ispc && isequal(get(hObject,'BackgroundColor'),get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white'); 
end
function txtFz_Callback(hObject, eventdata, handles)
% handles structure with handles and user data (see GUIDATA)
set(handles.chkUpdate, 'Value',get(handles.chkUpdate, 'Min')) 
popPlotType_Callback(hObject, eventdata, handles);
function txtFz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtFz (see GCBO)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
set(hObject,'BackgroundColor','white'); 
end
