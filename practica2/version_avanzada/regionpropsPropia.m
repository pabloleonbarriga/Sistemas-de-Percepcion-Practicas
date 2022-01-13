function estructuraRP = regionpropsPropia(fTratada)
%regionpropsPropia Funcion que realiza parte de la funcionalidad de la
%funcion nativa de MATLAB "regionprops".

% Obtener tamano de la imagen a tratar
[nFilas, nColumnas, ~] = size(fTratada);

% Recibe la imagen etiquetada con cada objeto individualizado.
nEtiquetas = double(max(max(fTratada)));

for i = 1:nEtiquetas
    fAux = (fTratada == i);     % Se escoge cada etiqueta por separado
    m00 = sum(sum(fAux));       % Momento de orden 0, area
    
    % Variables para los maximos y minimos de la bounding box
    bbXmin = nColumnas; bbXmax = 0;
    bbYmin = nFilas;    bbYmax = 0;
    
    % Calculo de m01 y m10
    m01 = 0; m10 = 0;
    for x = 1 : nColumnas
        for y = 1 : nFilas
            
            % Si el pixel esta a 1, comprobar maximos y minimos
            if (fAux(y, x) == 1)
                if y < bbYmin
                    bbYmin = y;
                elseif y > bbYmax
                    bbYmax = y;
                end
                if x < bbXmin
                    bbXmin = x;
                elseif x > bbXmax
                    bbXmax = x;
                end
            end
                
            m10 = m10 + x * fAux(y, x); % Momento en que r = 1, s = 0
            m01 = m01 + y * fAux(y, x); % Momento en que r = 0, s = 1
        end
    end
    
    % Una vez se tienen los momentos m10 y m01 se puede calcular el centro
    % de gravedad.
    centroGravX = round(m10 / m00);
    centroGravY = round(m01 / m00);
    
    % Para calcular los limites de la bounding box basta con comprobar el
    % valor minimo y maximo en cada imagen.
    estructuraRP(i).BoundingBox = [bbXmin bbYmin bbXmax-bbXmin bbYmax-bbYmin];
    estructuraRP(i).Area = m00;
    estructuraRP(i).Centroid = [centroGravX centroGravY];
end
end