function fEntrenamiento = f_recortar_girar_imagen(datos, f, numero)
%f_recortar_girar_imagen Funcion que recorta y gira la imagen para aislar
%la matricula.

% Obtener datos para facilitar lectura
BoundBox = round(datos.BoundingBox);
anguloGiro = -round(datos.Orientation);  % Negativo puesto que se quiere deshacer el giro
ejeXlong = datos.MajorAxisLength;
ejeYlong = datos.MinorAxisLength;

% En caso de que se quiera aislar un numero no se contempla borde.
if numero == 0
    borde = 30;
else
    borde = 0;
    anguloGiro = 0;
end

% Acotar la plantilla para tener unicamente
fAcotadaGray = f(BoundBox(2) : BoundBox(2) + BoundBox(4)-1, BoundBox(1) : BoundBox(1) + BoundBox(3)-1);

% Imagen acotada y rotada
fAcotadaRotadaGray = imrotate(fAcotadaGray, anguloGiro);

% En caso de que el angulo de giro sea distinto de 0 (solo se da en las
% matriculas), se debera acotar aun mas la imagen
if anguloGiro ~= 0
    [nFilasLocal, nColumnasLocal, ~] = size(fAcotadaRotadaGray);
    acotarFilaMin = max([round(nFilasLocal / 2 - ejeYlong / 2 ), 1]);
    acotarFilaMax = min([round(nFilasLocal / 2 + ejeYlong / 2), nFilasLocal]);
    acotarColumnaMin = max([round(nColumnasLocal / 2 - ejeXlong / 2 + borde), 1]);
    acotarColumnaMax = min([round(nColumnasLocal / 2 + ejeXlong / 2 - borde), nColumnasLocal]);
    fAcotadaRotadaGray = fAcotadaRotadaGray(acotarFilaMin:acotarFilaMax, acotarColumnaMin: acotarColumnaMax);
end

% Obtener la imagen binaria a partir de la imagen en escala de grises
fEntrenamiento = fAcotadaRotadaGray < 120 & fAcotadaRotadaGray > 0;
end

