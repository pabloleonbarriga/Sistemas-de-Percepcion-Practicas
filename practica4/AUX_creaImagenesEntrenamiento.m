% Programa para crear imagenes de entrenamiento
close all; clear


%% Preparacion
fEjemplo = imread("imagenes/entrenamiento0.jpg");
[nFilas, nColumnas, ~] = size(fEjemplo);


filaInter = nFilas;
columInter = round(nColumnas / 5);
profInter = 3;
fInter = uint8(255*ones(filaInter, columInter, profInter));


%% Variables aux
res = [190 154 134 98];
inicioY = 75;
inicioX = [230 440 623 780];
for indice = 3:9
%% Lectura imagen
imagen = sprintf("imagenesCrearEntrenamiento/crear%d.jpg", indice);
f = imread(imagen);
[a, b, ~] = size(f);


for j = 1:a
    for k = 1:b
        if f(j,k, 1) == 0 && f(j,k, 2) == 0 && f(j,k, 3) == 0
            for l = 1:3
                f(j,k, l) = 1;
            end
        end
    end
end
for j = 1:a
    for k = 1:b
        if f(j,k, 1) == 0 && f(j,k, 2) == 0 && f(j,k, 3) == 0
            x = 1;
        end
    end
end

for j = 1:4
    fRes = imresize(f,[res(j) NaN], 'nearest');
%     imshow(fRes);
    [aa,ba, ~] = size(fRes);
    for i = 1:3
        fInter(inicioX(j):inicioX(j) + aa - 1, inicioY:inicioY + ba - 1, i) = fRes(:,:,i);
    end
end
% figure();imshow(fInter);
ang = [30 -30 45 -45];
fInterAux = fInter;
for j = 1:4
    fRot = imrotate(fInter, ang(j));
    
    [nFilas2, nColumnas2, ~] = size(fRot);
    sobranteFil = (nFilas2 - filaInter) / 2;
    sobranteCol = (nColumnas2 - columInter) / 2;
    if ang(j) > 0
        fCrop = fRot(sobranteFil:nFilas2 - sobranteFil - 1, sobranteCol*2/3 : nColumnas2 - 4/3*sobranteCol - 101,:);
    else
        fCrop = fRot(sobranteFil:nFilas2 - sobranteFil - 1, sobranteCol*3/3 : nColumnas2 - 3/3*sobranteCol + 100,:);
    end
    fInterAux = [fInterAux fCrop];
%     imshow(fCrop);
end

for j = 1:nFilas
    for k = 1:nColumnas
        if fInterAux(j,k, 1) == 0 && fInterAux(j,k, 2) == 0 && fInterAux(j,k, 3) == 0
            for l = 1:3
                fInterAux(j,k, l) = 255;
            end
        end
    end
end
% fig = imshow(fInterAux);
nombre_guardar = sprintf("imagenes/entrenamientoNuevo%d.jpg", indice);
imwrite(fInterAux, nombre_guardar);
end