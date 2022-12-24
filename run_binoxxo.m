main_menu = binoxxo_menu;

movegui(main_menu.UIFigure, "center");
main_menu.UIFigure.Visible = "on";
save_path = "./save_files/included/";

try
    while main_menu.UIFigure.Visible == "on"
        pause(0.5)
    end
catch
    disp("Menu Window Terminated")
end

if main_menu.gridSize == 6
    switch main_menu.difficulty
        case "easy"
            values = readSaveFile(save_path+"6_easy.txt");
        case "medium"
            values = readSaveFile(save_path+"6_medium.txt");
        case "hard"
            values = readSaveFile(save_path+"6_hard.txt");
        case "manual"
            values = main_menu.fileValues;
    end
    game = binoxxo_app(values);
elseif main_menu.gridSize == 8
    disp("loading 8 sized window")
end
movegui(game.UIFigure, "center");