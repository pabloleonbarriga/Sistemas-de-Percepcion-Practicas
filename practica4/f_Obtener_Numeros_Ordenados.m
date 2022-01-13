function [matrizOrdenar, indiceNumeros] = f_Obtener_Numeros_Ordenados(nDatosNumeros,datosNumeros, areaMediana)
%f_Obtener_Numeros_Ordenados Funcion que recibe todos los objetos, filtra los numeros y los
%ordena segun orden de apariencia en la matricula (de izquierda a derecha).

indiceNumeros = 1;
matrizOrdenar = [];
for k = 1:nDatosNumeros
    areaNumero = round(datosNumeros(k).Area);
    
    % Comprobar que el area se encuentra dentro de unos margenes
    % arbitrarios, para descartar el borde y la D y el resto de
    % objetos no deseados.
    if areaNumero > areaMediana *0.8 && areaNumero < areaMediana *1.2
        indiceNumeros = indiceNumeros + 1;
        
        % Introducir en una matriz los valores de fila y columna
        % para acotar, así como el indice, para poder ordenar segun
        % aparezcan en la matricula.
        
        numeroBoundingBox = round(datosNumeros(k).BoundingBox);
        numeroFilaMin = numeroBoundingBox(2);
        numeroFilaMax = numeroBoundingBox(2) + numeroBoundingBox(4);
        numeroColumnaMin = numeroBoundingBox(1);
        numeroColumnaMax = numeroBoundingBox(1) + numeroBoundingBox(3);
        numeroCentroide = round(datosNumeros(k).Centroid);
        
        matrizOrdenar = [matrizOrdenar; numeroFilaMin numeroFilaMax numeroColumnaMin numeroColumnaMax numeroCentroide];
        
    end
end
% Ordenar la matriz en orden ascendente de distancia hacia la
% izquierda, de manera que se tienen en orden los numeros segun
% aparecen en la matricula.
matrizOrdenar = sortrows(matrizOrdenar, 3);
end

