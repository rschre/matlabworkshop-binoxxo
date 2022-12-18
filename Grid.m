classdef Grid
   properties
      size {mustBeNumeric}
      values 
      options 
   end

    methods        
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

        function cols = getColumns(obj)
            cols = strings(obj.size,1);
            for i = 1:obj.size
                cols(i) = obj.values(:,i).join("");
            end
        end

        function rows = getRows(obj)
            rows = strings(obj.size,1);
            for i = 1:obj.size
                rows(i) = obj.values(i,:).join("");
            end
        end

        function verifyGrid(obj, app)
            expression = "(X{3,})|(O{3,})"; % Matches 3 or more of either X or O in a row

            gridFilled = ~any(strcmp(obj.values, ""), "all"); % True if grid doesn't containt empty values

            errorList = strings(0);
            gridHasErrors = false;

            if not(gridFilled)
                uialert(app.UIFigure,"Fill out all fields before checking", "Input incomplete")
                return
            end

            cols = obj.getColumns();
            rows = obj.getRows();

            % Section which handles triplets
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

            if gridHasErrors
                uialert(app.UIFigure, errorList, "Input incorrect")
            else
                uialert(app.UIFigure,"You did it!", "Success", "Icon", "success")
            end

        end

        function [tripletRows, tripletCols] = checkTriplets(obj, expression, rows, cols)
            tripletRows = [];
            tripletCols = [];
            
            % Join every row to a single string, check with regex for
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

        function saveToFile(obj)
            [file,path] = uiputfile("./save_files/*.txt");
            if(file)
                disp(file)
                rows = obj.getRows();
                writelines([obj.size; rows], strcat(path,file));
            end
        end
    end
end