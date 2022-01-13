%% Sistemas de Percepcion - Practica 2 - Segmentacion por color
clear; clc; close all

% Leer la imagen
fOriginal = imread('imagenDePartida.png');
fHSV = rgb2hsv(fOriginal);

%Separar por canales
fH = fHSV( :,:,1); % canal hue
fS = fHSV( :,:,2); % canal saturation
fV = fHSV( :,:,3); % canal value


% Obtener umbrales HSV a traves de aplicacion colorThresholder
umbralesHSV = [ 0.0340, 0.9470, 1.0000, 0.4010, 1.0000, 0.5420;
                0.0820, 0.0200, 1.0000, 0.4140, 1.0000, 0.8340;
                0.3770, 0.2710, 1.0000, 0.1910, 1.0000, 0.6120;
                0.6110, 0.5090, 1.0000, 0.1910, 1.0000, 0.4700;
                0.1890, 0.1530, 1.0000, 0.4830, 1.0000, 0.6670;
                0.9850, 0,      1.0000, 0,      0.3050, 0.0980];
            
nombre_colores = ["Rojo", "Naranja", "Verde", "Azul", "Amarillo", "Negro"];


%
for i = 1:6
    % El siguiente if comprueba que no se trate del caso en que el umbral
    % minimo es mayor que el umbral maximo en el campo Hue.
    if (umbralesHSV(i,1) < umbralesHSV(i,2))
        fTratada =  (fH < umbralesHSV(i, 1) | fH > umbralesHSV(i, 2)) &...
                    (fS < umbralesHSV(i, 3) & fS > umbralesHSV(i, 4)) &...
                    (fV < umbralesHSV(i, 5) & fV > umbralesHSV(i, 6));
    else
        fTratada =  (fH < umbralesHSV(i, 1) & fH > umbralesHSV(i, 2)) &...
                    (fS < umbralesHSV(i, 3) & fS > umbralesHSV(i, 4)) &...
                    (fV < umbralesHSV(i, 5) & fV > umbralesHSV(i, 6));
    end 
    
    % Una vez obtenida la mascara en blanco y negro, aplicar procesamiento
    % Realizar una erosión con plantilla circular de radio 1
    elem = strelPropia(1);
    fTratada = imerodePropia(fTratada, elem);
    
    % Realizar un cierre con plantilla circular de radio 8
    elem = strelPropia(8);
    fTratada = imclosePropia(fTratada, elem);
    
    % Realizar una apertura con plantilla circular de radio 1
    elem = strelPropia(1);
    fTratada = imopenPropia(fTratada, elem);
    
    % Una vez se tiene una imagen binaria con los objetos separados en
    % mayor o menor medida, se pasa a tratar la imagen para dibujar las
    % bounding boxes y los centros de masa de cada objeto.
    f1_calculo_avanzada(fTratada, fOriginal, i, nombre_colores);
    
%     pause();
end
        