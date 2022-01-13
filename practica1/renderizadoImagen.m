function fRender = renderizadoImagen(nvertices, vertXY, M, N, fRender, ncuadro)
%renderizadoImagen Funcion que construye la renderizacion de la imagen

% Obtener los vectores de coordenadas X Y.
vectorXesquinas = vertXY(:,1);
vectorYesquinas = vertXY(:,2);
vectorXY = [vectorXesquinas vectorYesquinas]';

% Almacenar el cuadro del que se copiaran los valores de intensidad
imagen_a_leer = sprintf('im%d.jpg', ncuadro + 1);
fCuadroOriginal = imread(imagen_a_leer);

% Obtener los parametros del cuadro original para calcular la homografia
[M_fCuadroOriginal, N_fCuadroOriginal, C_fCuadroOriginal] = size(fCuadroOriginal);
vIN = vectorXY;
vOUT = [1 1 N_fCuadroOriginal N_fCuadroOriginal; 1 M_fCuadroOriginal M_fCuadroOriginal 1];
matriz_homografia = HomographySolve(vIN, vOUT);

% Obtener minimos y maximos en eje X e Y, para limitar la busqueda de
% puntos posibles en el interior del poligono.
xMinCuadro = max(min(vertXY(:,1)), 1);
xMaxCuadro = min(max(vertXY(:,1)), N);
yMinCuadro = max(min(vertXY(:,2)), 1);
yMaxCuadro = min(max(vertXY(:,2)), M);

% Bucle que recorre cada punto dentro de los limites calculados,
% comprobando si se encuentra dentro del poligono, y creando el render.
for a = yMinCuadro : yMaxCuadro
    for b = xMinCuadro : xMaxCuadro
        % Para cada punto dentro de los limites:
        
        dentro = -1;        % Si dentro es -1, se encuentra fuera del poligono. Si dentro es 1, se encuentra dentro.
        coordXpunto = b;    % El punto a verificar
        coordYpunto = a;
        
        
        % El algoritmo para comprobar que un punto se encuentra de un
        % trapecio se obtiene de la siguiente web:
        % https://wrf.ecse.rpi.edu/Research/Short_Notes/pnpoly.html
        % A continuacion se ha "traducido" a matlab el codigo original C.
        j = nvertices;
        for i = 1: nvertices
            if ( ((vectorYesquinas(i) > coordYpunto) ~= (vectorYesquinas(j) > coordYpunto)) &&...
                    (coordXpunto < (vectorXesquinas(j)-vectorXesquinas(i)) * ...
                    (coordYpunto-vectorYesquinas(i)) / (vectorYesquinas(j)-vectorYesquinas(i)) + vectorXesquinas(i)) )
                dentro = -dentro;
            end
            j = i;
        end
        
        % Si se confirma que el pixel comprobado se encuentro dentro del
        % poligono de la imagen, se pasa a operar, realizando la operacion
        % de homografia y copiando los valores de la imagen original en la
        % vista de la camara.
        if (dentro == 1)
            for z = 1:3
                % Calcular que punto del cuadro original se corresponde con
                % el comprobado
                pCuadroOriginal = matriz_homografia * [b a 1]';
                pCuadroOriginal = pCuadroOriginal(1:2) / pCuadroOriginal(3);
                pCuadroOriginal = round(pCuadroOriginal);
                % Saturar el indice de busqueda en el cuadro original
                if pCuadroOriginal(1) > N_fCuadroOriginal
                    pCuadroOriginal(1) = N_fCuadroOriginal;
                elseif pCuadroOriginal(1) < 1
                    pCuadroOriginal(1) = 1;
                end
                if pCuadroOriginal(2) > M_fCuadroOriginal
                    pCuadroOriginal(2) = M_fCuadroOriginal;
                elseif pCuadroOriginal(2) < 1
                    pCuadroOriginal(2) = 1;
                end
                % Copiar los valores del cuadro original al pixel de la
                % imagen de la camara
                fRender(a, b, z) = fCuadroOriginal(pCuadroOriginal(2), pCuadroOriginal(1), z);
            end
        end
    end
end
end