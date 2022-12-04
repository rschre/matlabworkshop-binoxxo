grid = Grid(6);

grid.values(1,:) = "X";
grid.values(2,:) = "O";
grid.values(:,2) = "X";
grid.values(3,:) = "O";
grid.values(4,:) = "X";
grid.values(:,4) = "O";
grid.values(5,:) = "O";
grid.values(6,:) = "X";

disp(grid.values)