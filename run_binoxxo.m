main_menu = binoxxo_menu;

main_menu.UIFigure.Visible = "on";

try
    while main_menu.UIFigure.Visible == "on"
        pause(0.5)
    end
catch
    disp("Menu Window Terminated")
end

% try
if main_menu.gridSize == 6
    game = binoxxo_app;
end
% catch
%     disp("Game terminated");
% end


% if app.backToMenu == true
%     movegui(main_menu.UIFigure, "center");
%     main_menu.UIFigure.Visible = "on";
% end
% 
% while main_menu.UIFigure.Visible == "on"
%     pause(0.5)
% end
% 
% disp("app closed")