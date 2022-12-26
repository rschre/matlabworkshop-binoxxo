%==========================================================================
% Eingangspunkt für Binoxxo-Spiel
%   Name: run_binoxxo.m
%   Bearbeiter: Raffael Schreiber
%   Version: V1.0
%   Datum: 25.12.2022
%==========================================================================
% Benötigt Files:
% classes/Grid.m
% functions/readSaveFile.m
% ui/binoxxo_app.mlapp
% ui/binoxxo_app_8.mlapp
% ui/binoxxo_menu.mlapp
% ui/Rules.mlapp
% save_file/included/<SAVE_FILES> (SAVE_FILES: 6_easy.txt, 6_medium.txt,
% 6_hard.txt, 8_easy.txt, 8_medium.txt, 8_hard.txt)
%==========================================================================
% Zweck:
% Öffnet Hauptmenu zur Spielauswahl, je nach Spielauswahl, wird as dazu
% passende GUI geöffnet.
%==========================================================================

% Initializations
% -----------------
addpath('ui','functions','classes');
main_menu = binoxxo_menu; % main menu UI
movegui(main_menu.UIFigure, "center");
main_menu.UIFigure.Visible = "on";
save_path = "./save_files/included/"; % where the predefined games are located
manualGame = false;

% Main Execution
% -----------------
try
    % Wait for choice in main menu
    while main_menu.UIFigure.Visible == "on"
        pause(0.5)
    end
catch
    disp("Menu Window Terminated") % graceful exit, if main menu is closed
    return
end



% Choose different UI, depending on the selected game size (6x6 or 8x8)
if main_menu.gridSize == 6
    % Switch between difficulty for included games
    % or load from personal save file
    try
        switch main_menu.difficulty
            case "easy"
                values = readSaveFile(save_path+"6_easy.txt");
            case "medium"
                values = readSaveFile(save_path+"6_medium.txt");
            case "hard"
                values = readSaveFile(save_path+"6_hard.txt");
            case "manual"
                values = main_menu.fileValues;
                manualGame = true;
        end
        game = binoxxo_app(values, manualGame); % Open game UI with corresponding values
        movegui(game.UIFigure, "center");
    catch ME
        fig = uifigure;
        uialert(fig, "Error loading game, make sure you're not missing files. Sync with https://github.com/rschre/matlabworkshop-binoxxo. You can also check the error message in the MATLAB command window.", "Error loading file",'CloseFcn',@(h,e) close(fig))
        disp("Original error message:")
        disp(ME.message)
    end


elseif main_menu.gridSize == 8
    % Switch between difficulty for included games
    % or load from personal save file
    try
        switch main_menu.difficulty
            case "easy"
                values = readSaveFile(save_path+"8_easy.txt");
            case "medium"
                values = readSaveFile(save_path+"8_medium.txt");
            case "hard"
                values = readSaveFile(save_path+"8_hard.txt");
            case "manual"
                values = main_menu.fileValues;
                manualGame = true;
        end
        game = binoxxo_app_8(values, manualGame); % Open game UI with corresponding values
        movegui(game.UIFigure, "center");
    catch ME
        fig = uifigure;
        uialert(fig, "Error loading game, make sure you're not missing files. Sync with https://github.com/rschre/matlabworkshop-binoxxo. You can also check the error message in the MATLAB command window.", "Error loading file",'CloseFcn',@(h,e) close(fig))
        disp("Original error message:")
        disp(ME.message)
    end
end
