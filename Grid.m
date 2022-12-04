classdef Grid
   properties
      size {mustBeNumeric}
   end
    methods        
        function obj = Grid(size)
            if nargin == 1
                obj.size = size;
            end
        end
    end
end