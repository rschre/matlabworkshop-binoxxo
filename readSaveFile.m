function [values, size] = readSaveFile(path)

lines = readlines(path);
size = str2double(lines(1));
data = char(lines(2:size+1));

values = strings(size);

for i=1:size
    for j=1:size
        values(i,j) = replace(data(i,j),"-","");
    end
end

end