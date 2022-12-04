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

            gridFilled = ~any(strcmp(obj.values, ""), "all");

            errorList = strings(0);
            gridHasErrors = false;

            if not(gridFilled)
                uialert(app.UIFigure,"Fill out all fields before checking", "Input incomplete")
                return
            end

            % Section which handles triplets
            [tripletRows, tripletCols] = checkTriplets(obj, expression);
            if not(isempty(tripletRows))
                errorList(end+1) = "Triplet on row number: "+tripletRows;
                gridHasErrors = true;
            end
            if not(isempty(tripletCols))
                errorList(end+1) = "Triplet on column number: "+tripletCols;
                gridHasErrors = true;
            end

            % Section which handles equal number of every symbol

            % Section which handles row or columns duplicates

            if gridHasErrors
                uialert(app.UIFigure, errorList, "Input incorrect")
            else
                uialert(app.UIFigure,"You did it!", "Success", "Icon", "success")
            end

        end

        function [tripletRows, tripletCols] = checkTriplets(obj, expression)
            tripletRows = [];
            tripletCols = [];
            
            % Join every row to a single string, check regex
            for i = 1:obj.size
                row = obj.values(i,:).join("");
                res = regexp(row, expression);
                if(length(res) >= 1)
                    tripletRows(end+1) = i; %#ok<AGROW> 
                end
            end

            % Same for columns
            for i = 1:obj.size
                col = obj.values(:,i).join("");
                res = regexp(col, expression);
                if(length(res) >= 1)
                    tripletCols(end+1) = i; %#ok<AGROW> 
                end
            end
        end

        function [duplicateRows, duplicateCols] = checkDuplicates(obj)
            cols = strings(0);
            rows = strings(0);
            duplicateRows = [];
            duplicateCols = [];
            
            % Join every row to a single string, save in rows
            for i = 1:obj.size
                row = obj.values(i,:).join("");
                rows(end+1) = row;
            end

            % Same for columns
            for i = 1:obj.size
                col = obj.values(:,i).join("");
                cols(end+1) = col;
            end
            
            for i = 1:obj.size
                if sum(contains(rows, rows(i)))>1
                    duplicateRows(end+1) = i;
                end
                if sum(contains(cols, cols(i)))>1
                    duplicateCols(end+1) = i;
                end
            end
        end
    end
end