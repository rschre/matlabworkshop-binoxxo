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

        function verifyGrid(obj, app)
            expression = "(X{3,})|(O{3,})"; % Matches 3 or more of either X or O in a row
            gridCorrect = true;

            disp(obj.values)
            gridFilled = ~any(strcmp(obj.values, ""), "all");

            if not(gridFilled)
                uialert(app.UIFigure,"Fill out all fields before checking", "Input incomplete")
                return
            end

            [colsCorrect, errorCols] = verifyCols(obj, expression);
            if not(colsCorrect)
                disp("Error on column number(s): ");
                uialert(app.UIFigure,"Error on column number: "+errorCols, "Input incorrect")
                disp(errorCols);
                gridCorrect = false;
            end
            
            [rowsCorrect, errorRows] = verifyRows(obj, expression);
            if not(rowsCorrect)
                disp("Error on row number(s): ");
                uialert(app.UIFigure,"Error on row number: "+errorRows, "Input incorrect")
                disp(errorRows);
                gridCorrect = false;
            end

            if gridCorrect
                uialert(app.UIFigure,"You did it!", "Success", "Icon", "success")
                disp("You did it!")
            end

        end

        function [colsCorrect, errorCols] = verifyCols(obj, expression)

            errorCols = [];

            % Join every column to a single string, check regex
            for i = 1:obj.size
                col = obj.values(:,i).join("");
                res = regexp(col, expression);
                if(length(res) >= 1)
                    errorCols(end+1) = i; %#ok<AGROW> 
                end
            end

            if isempty(errorCols)
                colsCorrect = true;
            else 
                colsCorrect = false;
            end
        end
            
        function [rowsCorrect, errorRows] = verifyRows(obj, expression)
        
            errorRows = [];

            % Join every row to a single string, check regex
            for i = 1:obj.size
                row = obj.values(i,:).join("");
                res = regexp(row, expression);
                if(length(res) >= 1)
                    errorRows(end+1) = i; %#ok<AGROW> 
                end
            end

            if isempty(errorRows)
                rowsCorrect = true;
            else 
                rowsCorrect = false;
            end
        end
    end
end