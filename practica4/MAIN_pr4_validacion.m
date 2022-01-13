%% Practica 4 - Sistemas de Percepcion - Pablo Leon Barriga
clear;close all;clc

%% Variables a utilizar

% Cargar el archivo clase.mat, que contiene la estructura con la
% informacion de cada clase
load('clase.mat');
nClases = length(clase);

%% Leer imager, pasar a escala de grises y binarizarla con umbral.
imagenLeer = sprintf("imagenes/validacion.jpg");
fOriginal = imread(imagenLeer);
[nFilas, nColumnas, ~] = size(fOriginal);
fGray = rgb2gray(fOriginal);
fBW = fGray < 245;

%% Operaciones morfologicas para obtener imagen mas homogenea
% Dilatar la imagen para obtener cada matrícula.
elem = strel('disk', 2);
fBW = imdilate(fBW, elem);

%% Etiquetado y obtencion de datos de la imagen
% Etiquetar la imagen para realizar regionprops
fBWlabeled = logical(fBW);

% Obtener los datos de cada matricula
datosMatriculas = regionprops(fBWlabeled, 'Area', 'BoundingBox', 'Centroid', 'MinorAxisLength', 'MajorAxisLength', 'Orientation');
nDatosMatriculas = length(datosMatriculas(:,1));

%% Bucle de tratamiento de imagenes para obtener cada matricula por separado
for j = 1:nDatosMatriculas
    if datosMatriculas(j).Area > 500
        % Recortar y girar la imagen
        fValidacion = f_recortar_girar_imagen(datosMatriculas(j), fGray, 0);
        
        % Etiquetar la imagen
        fValidacionLabelled = logical(fValidacion);
        
        % Obtener los datos de cada elemento de la matricula aislada
        datosNumeros = regionprops(fValidacionLabelled, 'Area', 'BoundingBox', 'Centroid', 'MinorAxisLength', 'MajorAxisLength', 'Orientation');
        nDatosNumeros = length(datosNumeros(:,1));
        
        % Comprobar orientacion
        [fValidacionLabelled,datosNumeros, nDatosNumeros]  = f_Comprobar_Orientacion(datosNumeros, nDatosNumeros, fValidacionLabelled);
        
        % Obtener la mediana de las areas de los objetos, para obtener
        % el area de un numero individual.
        areaMediana = f_Obtener_Mediana_Area(nDatosNumeros,datosNumeros);
        
        % Una vez obtenida la mediana, analizar cada numero y
        % obtener la matriz con cada numero ordenado por orden de aparicion
        % en la matricula.
        [matrizOrdenar, numeroNumeros] = f_Obtener_Numeros_Ordenados(nDatosNumeros,datosNumeros, areaMediana);
        
        
        % Una vez se tiene cada numero de la matricula por separado, se
        % detecta cada numero.
        matriculaBayesiano = zeros(1, numeroNumeros - 1);
        matriculaTextoBayesiano = '';
        matriculaLineal = zeros(1, numeroNumeros - 1);
        matriculaTextoLineal = '';
        for k = 1 : numeroNumeros - 1
            
            % "Recortar" cada numero de la matricula
            fNumero = fValidacionLabelled(matrizOrdenar(k, 1):matrizOrdenar(k, 2), matrizOrdenar(k, 3):matrizOrdenar(k, 4));
            
            % Una vez se tiene el numero, normalizar tamano a 128 filas x 64 columnas pix.
            fNumeroResized = imresize(fNumero, [128 64]);
            
            % Una vez normalizado, se pasan a calcular las caracteristicas
            % Xi.
            Xaux = f_calculo_caracteristicas(fNumeroResized);
            X = Xaux(6:13);
            
            % Una vez obtenidas las caracteristicas, se pasa a
            % comprobar que numero del entrenamiento se corresponde con
            % el detectado.
            fdkBayesiano = zeros(1, 10);
            for l = 1 : nClases
                dist = (X - clase(l).mu') * clase(l).Vinv * (X - clase(l).mu')';
                fdkBayesiano(l) = -1/2*dist^2 + clase(l).fk;
            end
            [~, indiceMinimoBayesiano] = min(abs(fdkBayesiano));
            matriculaBayesiano(k) = indiceMinimoBayesiano - 1;
            matriculaTextoBayesiano = strcat(matriculaTextoBayesiano, num2str(matriculaBayesiano(k)));
            
            % Clasificador de minima distancia
            fdkLineal = zeros(1, 10);
            for l = 1 : nClases
                fdkLineal(l) = norm(clase(l).mu' - X);  % Distancia a cada clase
            end
            [~, indiceMinimoLineal] = min(abs(fdkLineal));
            matriculaLineal(k) = indiceMinimoLineal - 1;
            matriculaTextoLineal = strcat(matriculaTextoLineal, num2str(matriculaLineal(k)));
            
        end
        f_Mostrar_Matricula_Numero(fValidacionLabelled, matrizOrdenar, numeroNumeros,  matriculaBayesiano, matriculaTextoBayesiano, matriculaLineal, matriculaTextoLineal);
%         pause;
    end
end


