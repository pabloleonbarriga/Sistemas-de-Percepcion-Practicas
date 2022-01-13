%
function fTratar = imerodePropia(fTratar, plantilla)
%imerodePropia Funcion que realiza la misma funcionalidad que imerode.
%   Recibe la imagen a tratar y el elemento "strel" de tipo disco con el
%   que se realizara la operacion morfologica.

% Copiar la matriz original para no reescribirla
fAux = fTratar;

% Obtener tamano de la imagen a tratar
[nFilas, nColumnas, ~] = size(fTratar);

% Obtener radio de la plantilla.
nFilasPlantilla = length(plantilla(:,1));
nColumnasPlantilla = nFilasPlantilla;
radioPlantilla = (nFilasPlantilla - 1) / 2;

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
%
for filas = 1 : nFilas
    for columnas = 1 : nColumnas
        % Se coge la esquina superior izquierda de la plantilla superpuesta
        % al pixel que se comprueba.
        filaOrigen = filas - radioPlantilla - 1;
        columOrigen = columnas - radioPlantilla - 1;
        
        % Inicializar contador de aciertos
        contadorAciertos = 0;
        
        % Tratar unicamente aquellos pixeles que estan a 1
        if fTratar(filas, columnas) ~= 0
            
            % Se recorre el vector "aComprobar"
            for indComprobar = 1:tamComprobar
                % Obtener el valor que habra que sumar al pixel superior
                % izquierdo obtenido en "filaOrigen" y "columOrigen".
                sumFila = aComprobar(indComprobar, 1);
                sumColum = aComprobar(indComprobar, 2);
                
                % Comprobar si el valor del pixel es 1, y aumentar el contador
                % en caso afirmativo. Si no es igual a 1, salir del bucle de
                % comprobacion.
                if (filaOrigen + sumFila > 0) && (filaOrigen + sumFila <= nFilas) ...
                       && (columOrigen + sumColum > 0) && (columOrigen + sumColum <= nColumnas)
                    if fTratar(filaOrigen + sumFila, columOrigen + sumColum) == 1
                        contadorAciertos = contadorAciertos + 1;
                    else
                        break
                    end
                else
                    contadorAciertos = contadorAciertos + 1;
                end
            end
            
            % Dar valor al pixel "padre", en funcion del valor del contador.
            if contadorAciertos == tamComprobar
                fAux(filas, columnas) = 1;
            else
                fAux(filas, columnas) = 0;
            end
        end
    end
end
fTratar = fAux;

end

