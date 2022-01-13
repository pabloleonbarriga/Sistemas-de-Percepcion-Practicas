function [fValidacionLabelled,datosNumeros, nDatosNumeros]  = f_Comprobar_Orientacion(datosNumeros, nDatosNumeros, fValidacionLabelled)
%f_Comprobar_Orientacion Funcion que comprueba la orientacion de la
%matricula, girando 180 grados para obtenerla del derecho.
%   Detailed explanation goes here

% Inicializar variable para obtener el objeto de mayor area
datoMayorArea = datosNumeros(1);

[~, nColumnas, ~] = size(fValidacionLabelled);

% Obtener el objeto de mayor area, que se corresponde con la parte azul de
% la matricula.
for i = 2:nDatosNumeros
    if datosNumeros(i).Area > datoMayorArea.Area
        datoMayorArea = datosNumeros(i);
    end
end

% Si la variable horizontal del centroide de la parte azul se encuentra mas
% alla de la mitad de la imagen, se debe voltear 180 grados la imagen.
if datoMayorArea.Centroid(1) > nColumnas / 2
    fValidacionLabelled = imrotate(fValidacionLabelled, 180);
    
    % Reobtener los datos de cada elemento de la matricula una vez girada
    % 180 grados.
    datosNumeros = regionprops(fValidacionLabelled, 'Area', 'BoundingBox', 'Centroid', 'MinorAxisLength', 'MajorAxisLength', 'Orientation');
    nDatosNumeros = length(datosNumeros(:,1));
end
end

