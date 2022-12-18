% Rules UI
% Create UIFigure and hide until all components are created

Rules = uifigure('Visible', 'off');
Rules.Position = [100 100 352 299];
Rules.Name = 'Binoxxo Rules';

% Create TextArea
Rules.TextArea = uitextarea(Rules);
Rules.TextArea.Editable = 'off';
Rules.TextArea.FontSize = 14;
Rules.TextArea.Position = [46 34 271 208];
Rules.TextArea.Value = {'Rule 1: No more than two consecutive Xs or Os may appear in a row or column'; ''; 'Rule 2: The number of X''s and O''s in a row or column must be the same (e.g. 3 X''s and 3 O''s).'; ''; 'Rule 3: No row or column is allowed to be the same as another'};

% Create RulesLabel
Rules.RulesLabel = uilabel(Rules);
Rules.RulesLabel.FontSize = 24;
Rules.RulesLabel.Position = [150 253 66 32];
Rules.RulesLabel.Text = 'Rules';