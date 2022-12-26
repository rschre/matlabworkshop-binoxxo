%==========================================================================
% Klasse für Daten und Methoden im Binoxxo-Spiel
%   Name: Grid.m
%   Bearbeiter: Raffael Schreiber
%   Version: V1.0
%   Datum: 25.12.2022
%==========================================================================
% Zweck:
% Enthält die Daten, die auf dem Grid angezeigt werden. Enthält Methoden
% die zur Überprüfung und Speicherung  der eingegebenen Daten verwendet
% werden.
%==========================================================================

classdef Grid
   properties
      size {mustBeNumeric} % size of the field (e.g. 6 für 6x6)
      values % values in Grid, string-array with dims size-x-size
      options % NOT IMPLEMENTED: Switching symbols from X/O to 1/0 etc.
   end

    methods        
        % Spawns the grid with the provided size
        function obj = Grid(size, options)
            if exist("size", "var")
                obj.size = size;
                obj.values = strings(size);
            else
                throw(MException("MATLAB:InputArgUndefined", ...
                    "Grid size must be specified"));
            end
            if exist("options", "var")
                obj.options = options;
            else
                obj.options = ["","O","X"];
            end
        end

        % Returns array with one string per column (e.g. 6x1)
        % If fillEmpty is true, the unfilled files (stored as "" in values)
        % is returned as "-", for saving in files.
        function cols = getColumns(obj, fillEmpty)
            
            % Set default of fillEmpty to false
            if ~exist("fillEmpty", "var")
                fillEmpty = false;
            end
              
            cols = strings(obj.size,1);
            for i = 1:obj.size
                v = obj.values(:,i);
                if fillEmpty 
                    v(v=="") = "-";
                end
                cols(i) = v.join("");
            end
        end

        % Returns array with one string per row (e.g. 6x1)
        % If fillEmpty is true, the unfilled files (stored as "" in values)
        % is returned as "-", for saving in files.
        function rows = getRows(obj, fillEmpty)
            % Set default of fillEmpty to false
            if ~exist("fillEmpty", "var")
                fillEmpty = false;
            end

            rows = strings(obj.size,1);
            for i = 1:obj.size
                v = obj.values(i,:);
                if fillEmpty 
                    v(v=="") = "-";
                end
                rows(i) = v.join("");
            end
        end

        % Gets called upon clicking "Verify Solution"
        % Calls the methods to verify the different rules and prints an
        % alert either containing information about the errors 
        % or a success message.
        function verifyGrid(obj, app)
            expression = "(X{3,})|(O{3,})"; % Matches 3 or more of either X or O in a row

            gridFilled = ~any(strcmp(obj.values, ""), "all"); % True if grid doesn't containt empty values

            errorList = strings(0); % for displaying errors
            gridHasErrors = false; % switch between error/success message

            if not(gridFilled)
                uialert(app.UIFigure,"Fill out all fields before checking", "Input incomplete")
                return
            end

            cols = obj.getColumns(); % get cols as strings (for regex checking)
            rows = obj.getRows(); % get rows as string

            % Section which handles triplets (e.g. XXX or OOO)
            [tripletRows, tripletCols] = checkTriplets(obj, expression, rows, cols);
            if not(isempty(tripletRows))
                errorList = [errorList, "Triplet on row number: "+tripletRows];
                gridHasErrors = true;
            end
            if not(isempty(tripletCols))
                errorList = [errorList, "Triplet on column number: "+tripletCols];
                gridHasErrors = true;
            end

            % Section which handles equal number of every symbol
            [unevenRows, unevenCols] = checkEvenSymbols(obj, rows, cols);
            if not(isempty(unevenRows))
                errorList =[errorList, "Rows don't have the same amount of both symbols: "+unevenRows];
                gridHasErrors = true;
            end
            if not(isempty(unevenCols))
                errorList = [errorList, "Columns don't have the same amount of both symbols: "+unevenCols];
                gridHasErrors = true;
            end

            % Section which handles duplicate rows or columns
            [duplicateRows, duplicateCols] = checkDuplicates(obj, rows, cols);
            if not(isempty(duplicateRows))
                errorList = [errorList, "Rows are not unique: "+duplicateRows];
                gridHasErrors = true;
            end

            if not(isempty(duplicateCols))
                errorList = [errorList, "Columns are not unique: "+duplicateCols];
                gridHasErrors = true;
            end

            % Display info about the filled values
            if gridHasErrors
                uialert(app.UIFigure, errorList, "Input incorrect")
            else
                uialert(app.UIFigure,"You did it!", "Success", "Icon", "success")
            end

        end

        % Checks inputs against the provided expression for triplets
        % (e.g. XXX or OOO)
        % args: 
        % - expression: regular expression to check against
        % - rows: string array with a string per row
        % - cols: string array with a string per col
        % returns:
        % - two arrays, containing the index of rows or columns which
        % contain a triplet
        function [tripletRows, tripletCols] = checkTriplets(obj, expression, rows, cols)
            tripletRows = [];
            tripletCols = [];
            
            % triplets (e.g. "XXX" or "OOO")
            for i = 1:obj.size
                res = regexp(rows(i), expression);
                if(length(res) >= 1)
                    tripletRows(end+1) = i; 
                end
            end

            % Same for columns
            for i = 1:obj.size
                res = regexp(cols(i), expression);
                if(length(res) >= 1)
                    tripletCols(end+1) = i;
                end
            end
        end

        % Checks inputs for umsymetrical amount of symbols (e.g. 4Xs
        % and 2 Os)
        % args: 
        % - rows: string array with a string per row
        % - cols: string array with a string per col
        % returns:
        % - two arrays, containing the index of rows or columns which
        % contain an uneven amount of symbols
        function [unevenRows, unevenCols] = checkEvenSymbols(obj, rows, cols)
            unevenRows = [];
            unevenCols = [];
            
            % Check rows for uneven amount of symbols
            for i = 1:obj.size
                countX = count(rows(i), "X");
                countO = count(rows(i), "O");

                if countX ~= countO
                    unevenRows(end+1) = i; %#ok<*AGROW> 
                end
            end

            % Same for cols
            for i = 1:obj.size
                countX = count(cols(i), "X");
                countO = count(cols(i), "O");

                if countX ~= countO
                    unevenCols(end+1) = i;
                end
            end

        end

        % Checks for duplicate rows or columns
        % args: 
        % - rows: string array with a string per row
        % - cols: string array with a string per col
        % returns:
        % - two arrays, containing the index of rows or columns which
        % are duplicates of another
        function [duplicateRows, duplicateCols] = checkDuplicates(obj, rows, cols)
            duplicateRows = [];
            duplicateCols = [];
            
            % Check for duplicates and add them to return values
            for i = 1:obj.size
                if sum(contains(rows, rows(i)))>1
                    duplicateRows(end+1) = i;
                end
                if sum(contains(cols, cols(i)))>1
                    duplicateCols(end+1) = i;
                end
            end
        end
        
        % Choose a location and save current state of game to a file at
        % selected location
        function saveToFile(obj)
            [file,path] = uiputfile("./save_files/*.txt");
            if(file)
                disp(file)
                rows = obj.getRows(true);
                writelines([obj.size; rows], strcat(path,file));
            end
        end
    end
end