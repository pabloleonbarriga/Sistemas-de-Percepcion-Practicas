%
function matrix = strelPropia(radio)
%STREL_PROP Crea una plantilla de tipo 'disk' para operaciones morfológicas
%   Se crea una matriz de tipo circular del radio indicado. El tamaño de la
%   matriz viene dado por el radio introducido, más la fila/columna
%   central. Por tanto un radio de 1 creará una matriz de 3x3.


% Variables de número de filas y columnas
nfila = 2*radio + 1;
ncolum = nfila;

% Variable que indica el centro de la matriz
centro = radio + 1;

% Crear matriz y rellenarla en forma de disco. Esto se realiza calculando
% el módulo de la distancia entre el elemento que se quiere definir y el
% centro. Si dicho módulo es menor o igual al radio, el elemento será igual
% a 1. En caso contrario será cero.
matrix = zeros(nfila,ncolum);

for i=1:nfila
    for j=1:ncolum
        dist_x = centro-j;  % Distancia en x, centro - ncolum_actual
        dist_y = centro-i;  % Distancia en y, centro - nfila_actual
        dist_total = sqrt(dist_x^2+dist_y^2);   % Módulo de la distancia
        if dist_total<=radio
            matrix(i,j) = 1;
        end
    end
end
end