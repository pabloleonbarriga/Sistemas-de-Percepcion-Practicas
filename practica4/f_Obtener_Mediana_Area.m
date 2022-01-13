function areaMediana = f_Obtener_Mediana_Area(nDatosNumeros,datosNumeros)
%f_Obtener_Mediana_Area Funcion que recibe los datos de los objetos obtenidos con
%regionprops y calcula la mediana de las areas de los objetos, que se
%supone sera la de un numero. 

%   Se realiza una comprobacion para eliminar posibles objetos detectados
%   por regionprops pero que sean demasiado pequenos como para tratarse de
%   un numero.

% Obtener la mediana de las areas, para identificar el area de un numero.
indiceareaV = 1;
areaVector = 0;

% Tener unicamente en cuenta aquellos objetos cuya area sea
% mayor que 500 pixeles, para eliminar posible ruido al
% binarizar la imagen.
for k = 1:nDatosNumeros
    if datosNumeros(k).Area >  500
        areaVector(indiceareaV) = datosNumeros(k).Area;
        indiceareaV = indiceareaV + 1;
    end
end
areaMediana = median(areaVector);
end

