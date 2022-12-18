mock_grid

[file,path] = uiputfile("./save_files/*.txt");

if(file)
    disp(file)
    rows = grid.getRows();
    writelines([grid.size; rows], strcat(path,file))
else
    disp("no file")
end

save_file = readlines(strcat(path, file));
length = str2double(save_file(1));

for i=1:length
    disp(save_file(i+1))
end