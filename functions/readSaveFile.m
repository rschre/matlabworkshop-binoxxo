%==========================================================================
% Funktion um gespeicherte Spielstände zu laden
%   Name: readSaveFile.m
%   Bearbeiter: Raffael Schreiber
%   Version: V1.0
%   Datum: 25.12.2022
%==========================================================================
% Zweck:
% Liest ein binoxxo-save-file aus dem mitgegebenen pfad und parsed die
% Daten, damit sie für die Grid-Klasse verständlich sind.
%==========================================================================
% Args:
% - path: Absoluter Pfad zum Save-File
% Returns:
% values: string-array: Den eingelesenen Spielstand aus der Datei
% size: double: Die Spielfeldgrösse
%==========================================================================
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