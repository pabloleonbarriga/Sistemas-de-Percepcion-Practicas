function [fTratada, fResized] = pr3_Tratado_Imagen(i)
%f1_Tratado_Imagen Funcion que lee y trata la imagen para obtener las
%lineas principales mediante la transformada de Hough

% Umbrales obtenidos mediante la herramiento colorThresholder
% umbralesHSV_nofallos = [ 0.187, 0.111, 0.590, 0.215, 0.839, 0.550];
umbralesHSV_fallos = [ 0.157, 0.111, 0.530, 0.215, 0.839, 0.650];
umbralesHSV = umbralesHSV_fallos;

% Leer la imagen, disminuir al 30% del tamano
imagenLeer = sprintf('secuenciaBicicleta/000%d.jpg', i);
fOriginal = imread(imagenLeer);
fResized = imresize(fOriginal, 0.30);

% Pasar a espacio de colores HSV
fHSV = rgb2hsv(fResized);

%Separar por canales
fH = fHSV( :,:,1); % canal hue
fS = fHSV( :,:,2); % canal saturation
fV = fHSV( :,:,3); % canal value

% El siguiente if comprueba que no se trate del caso en que el umbral
% minimo es mayor que el umbral maximo en el campo Hue.
if (umbralesHSV(1) < umbralesHSV(2))
    fTratada =  (fH < umbralesHSV(1) | fH > umbralesHSV(2)) &...
        (fS < umbralesHSV(3) & fS > umbralesHSV(4)) &...
        (fV < umbralesHSV(5) & fV > umbralesHSV(6));
else
    fTratada =  (fH < umbralesHSV(1) & fH > umbralesHSV(2)) &...
        (fS < umbralesHSV(3) & fS > umbralesHSV(4)) &...
        (fV < umbralesHSV(5) & fV > umbralesHSV(6));
end

% Crear una plantilla en forma de diamante de radio 3
elem = strel('diamond', 3);

% Realizar operaciones morfologicas para obtener el resultado deseado
fTratada = imclose(fTratada, elem);
end

