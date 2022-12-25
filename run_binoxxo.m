

% Initializations
% -----------------
addpath('ui','functions','classes');
main_menu = binoxxo_menu; % main menu UI
movegui(main_menu.UIFigure, "center");
main_menu.UIFigure.Visible = "on";
save_path = "./save_files/included/"; % where the predefined games are located

% Main Execution
% -----------------
try
    % Wait for choice in main menu
    while main_menu.UIFigure.Visible == "on"
        pause(0.5)
    end
catch
    disp("Menu Window Terminated") % graceful exit, if main menu is closed
end

% Choose different UI, depending on the selected game size (6x6 or 8x8)
if main_menu.gridSize == 6
    % Switch between difficulty for included games
    % or load from personal save file
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
    game = binoxxo_app(values); % Open game UI with corresponding values

elseif main_menu.gridSize == 8
    % Switch between difficulty for included games
    % or load from personal save file
    switch main_menu.difficulty
        case "easy"
            values = readSaveFile(save_path+"8_easy.txt");
        case "medium"
            values = readSaveFile(save_path+"8_medium.txt");
        case "hard"
            values = readSaveFile(save_path+"8_hard.txt");
        case "manual"
            values = main_menu.fileValues;
    end
    game = binoxxo_app_8(values); % Open game UI with corresponding values
end
movegui(game.UIFigure, "center");