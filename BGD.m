function varargout = BGD(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BGD_OpeningFcn, ...
                   'gui_OutputFcn',  @BGD_OutputFcn, ...
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


% --- Executes just before BGD is made visible.
function BGD_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BGD wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BGD_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in BrowseButton.
function BrowseButton_Callback(hObject, eventdata, handles)

ImageDir = uigetdir();
handles.ImageDir = ImageDir;
% Update handles structure
guidata(hObject, handles);
DirPathEditBox_Callback(hObject, eventdata, handles);



function DirPathEditBox_Callback(hObject, eventdata, handles)

if isfield(handles, 'ImageDir')
    set(handles.DirPathEditBox , 'String' , handles.ImageDir );
end

guidata(hObject,handles); %save data to handles

% --- Executes on button press in RunTestButton.
function RunTestButton_Callback(hObject, eventdata, handles)
k = zeros(256,3);
aglArray = [];
if isfield(handles, 'ImageDir')
    srcFiles = dir(strcat(handles.ImageDir,'\','*.png'));
    
    if length(srcFiles) > 0
        for i = 1 : length(srcFiles)
            fileName = strcat(handles.ImageDir,'\',srcFiles(i).name);
            
            I = imread(fileName);
            J = rgb2gray(I);
            %figure, imshow(J);
            K = imhist(J);
            display(length(K));
            k(:,i) = K;
    
            K = K(50:200);
    
            if mean(K) > 50 && mean(K) < 150
                aglArray(length(aglArray)+1) = 1;
            elseif mean(K) > 150 && mean(K) < 256
                aglArray(length(aglArray)+1) = 0;
            else
                aglArray(length(aglArray)+1) = -1;
            end
        end
        plot(handles.GroupAGraph, k(:,1) );
        plot(handles.GroupBGraph, k(:,2) );
        plot(handles.GroupTypeGraph, k(:,3) );
        display(aglArray);
    end
else
    warndlg('Please choose directory of images','Error');
end
