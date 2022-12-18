% determine which item in the popup menu was selected

v = get(handles.popupmenu);

% delete the objects that already exist.  in this case, the handles.button and

% handles.axes field are always used to store the handles for the currently 

% existing objects

delete(handles.button)

delete(handles.axes);

% create new objects, based on the selection

switch v

case 1

     % create Button 1

     handles.button = uicontrol('style','pushbutton',...

     % create Axes 1

     handles.axes = axes(...

case 2

     % create Button 2

     handles.button = uicontrol('style','pushbutton',...

     % create Axes 2

     handles.axes = axes(...

end

% store the 'handles' structure that contains the new handle values

guidata(handles.figure(handles)