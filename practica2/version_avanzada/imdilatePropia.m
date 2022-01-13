function fTratar = imdilatePropia(fTratar, plantilla)
%imdilatePropia Funcion que realiza la misma funcionalidad que imdilate.
%   Recibe la imagen a tratar y el elemento "strel" de tipo disco con el
%   que se realizara la operacion morfologica.

% Copiar la imagen a tratar, para no sobreescribirla.
fAux = fTratar;

% Obtener tamano de la imagen a tratar
[nFilas, nColumnas, ~] = size(fTratar);

% Obtener radio de la plantilla.
nFilasPlantilla = length(plantilla(1,:));
nColumnasPlantilla = nFilasPlantilla;
radioPlantilla =  (nFilasPlantilla - 1) / 2;

% Para evitar comprobar con aquellos valores iguales a 0, se hara un
% pre-procesado de la plantilla, y se almacenan los pares de valores XY
% para los que la plantilla es igual a 1. El vector "aComprobar" contendra
% aquellos valores de fila/columna en los que la plantilla es un 1.
aComprobar = [];
indice = 1;
for i = 1:nFilasPlantilla
    for j = 1:nColumnasPlantilla
        if plantilla(j, i) == 1
            aComprobar(indice, 1) = j;
            aComprobar(indice, 2) = i;
            indice = indice + 1;
        end
    end
end
tamComprobar = indice - 1;


% Se comprueba en aquellos pixeles que esten a mas de un radio de distancia
% del borde
for filas = 1 : nFilas
    for columnas = 1 : nColumnas
        % Se coge la esquina superior izquierda de la plantilla superpuesta
        % al pixel que se comprueba.
        filaOrigen = filas - radioPlantilla - 1;
        columOrigen = columnas - radioPlantilla - 1;
        if fTratar(filas, columnas) == 1
            % Se recorre el vector "aComprobar"
            for indComprobar = 1:tamComprobar
                % Obtener el valor que habrá que sumar al pixel superior
                % izquierdo obtenido en "filaOrigen" y "columOrigen".
                sumFila = aComprobar(indComprobar, 1);
                sumColum = aComprobar(indComprobar, 2);
                
                if (filaOrigen + sumFila > 0) && (filaOrigen + sumFila <= nFilas) ...
                       && (columOrigen + sumColum > 0) && (columOrigen + sumColum <= nColumnas)
                
                
                    fAux(filaOrigen + sumFila, columOrigen + sumColum) = 1;
                end
            end
        end
        
    end
end
fTratar = fAux;

end

