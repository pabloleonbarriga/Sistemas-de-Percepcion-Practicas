%% Practica 4 - Sistemas de Percepcion - Pablo Leon Barriga
clear;close all;clc

%% Variables a utilizar
% Numero de clases, en este caso 10 (10 posibles numeros, 0 - 9).
Nclases = 10;

% Numero de caracteristicas, en este caso 13 (x1 - x13).
Nx = 13;

% La probabilidad a priori de las clases es 1 / Nclases
pC = 1/Nclases;

% Arrancar ventana grafica
pIMSHOW = imshow(logical(zeros(128,64)));

%% Bucle para entrenar cada una de las clases (numeros)
for i = 1:Nclases
    
    % Matriz de caracteristicas
    X = [];
    
    % Numero de muestras de entrenamiento
    nMuestras = 0;
    
    % Leer imager, pasar a escala de grises y binarizarla con umbral.
    imagenLeer = sprintf("imagenes/entrenamiento%d.jpg", i - 1);
    fOriginal = imread(imagenLeer);
    [nFilas, nColumnas, ~] = size(fOriginal);
    fGray = rgb2gray(fOriginal);
    fBW = fGray < 245;
    
    % Operaciones morfologicas para obtener imagen mas homogenea
    % Dilatar la imagen para obtener cada matrícula.
    elem = strel('disk', 2);
    fBW = imdilate(fBW, elem);
    
    % Etiquetado y obtencion de datos de la imagen
    % Etiquetar la imagen para realizar regionprops
    fBWlabeled = logical(fBW);
    
    % Obtener los datos de cada matricula
    datosMatriculas = regionprops(fBWlabeled, 'Area', 'BoundingBox', 'Centroid', 'MinorAxisLength', 'MajorAxisLength', 'Orientation');
    nDatosMatriculas = length(datosMatriculas(:,1));
    
    % -------------------------------------------------------------------------
    % Bucle de tratamiento de imagenes para obtener cada matricula por separado
    % -------------------------------------------------------------------------
    for j = 1:nDatosMatriculas
        % Eliminar posibles objetos detectados pero que no se tratan de
        % matriculas por el area.
        if datosMatriculas(j).Area > 500
            
            % Recortar y girar la imagen
            fEntrenamiento = f_recortar_girar_imagen(datosMatriculas(j), fGray, 0);
            
            % Etiquetar la imagen
            fEntrenamientoLabelled = logical(fEntrenamiento);
            
            % Obtener los datos de cada elemento de la matricula aislada
            datosNumeros = regionprops(fEntrenamientoLabelled, 'Area', 'BoundingBox', 'Centroid', 'MinorAxisLength', 'MajorAxisLength', 'Orientation');
            nDatosNumeros = length(datosNumeros(:,1));
            
            % Obtener la mediana de las areas de los objetos, para obtener
            % el area de un numero individual.
            areaMediana = f_Obtener_Mediana_Area(nDatosNumeros,datosNumeros);
            
            % -----------------------------------------------
            % Bucle para tratar cada numero de cada matricula
            % -----------------------------------------------
            
            % Una vez obtenida la mediana, analizar cada numero del vector
            % para realizar el entrenamiento, comprobando nuevamente que se
            % trata de un numero.
            for k = 1:nDatosNumeros
                areaNumero = round(datosNumeros(k).Area);
                
                % Comprobar que el area esta dentro de unos margenes
                % arbitrarios, para descartar el borde y la D, asi como
                % otros posibles ruidos.
                if (areaNumero > (areaMediana * 0.9)) && (areaNumero < (areaMediana * 1.1))
                    nMuestras = nMuestras + 1;
                    
                    % Recortar cada numero de la matricula
                    fNumero = f_recortar_girar_imagen(datosNumeros(k), fEntrenamiento, 1);
                    
                    % Una vez se tiene el numero, normalizar tamano a 128 filas x 64 columnas pix.
                    fNumeroResized = imresize(fNumero, [128 64]);
                    set(pIMSHOW, 'CData', fNumeroResized);
                    pause(0.000000001);
                    
                    % Una vez normalizado, se pasan a calcular las caracteristicas
                    % Xi.
                    Xaux = f_calculo_caracteristicas(fNumeroResized);
                    X = [X; Xaux];
                end
            end
        end
    end
    
    % ------------------------------------
    % -------Clasificador Bayesiano-------
    % ------------------------------------
    % Una vez finalizada con todas las matriculas de la imagen, se pasa a
    % construir el clasificador Bayesiano. Se escogen las caracteristicas
    % x6~x13, que permite construir una matriz inversa sin tener un numero
    % de condicion excesivamente alto (ill-conditioned matrix).
    
    % Se tiene la matriz de caracteristicas X, cada columna se trata de una de
    % las caracteristicas x1 - x13.
    clase(i).X = X(:,6:13);
    
    % Media de cada caracteristica (diap. 42, tema 4). La media tambien
    % servirá para el clasificador lineal.
    clase(i).mu = mean(X(:,6:13))';
    
    % Varianza de la clase (diap. 42, tema 4), media de las varianzas de cada
    % caracteristica.
    clase(i).V = (clase(i).X'-clase(i).mu)*(clase(i).X'-clase(i).mu)' / nMuestras;
    clase(i).Vinv = pinv(clase(i).V);
    
    % Calculo de fk, ya que depende de la probabilidad total de la clase, y de
    % su varianza, que son constantes.
    clase(i).fk = log(pC) - 1/2 * log(det(clase(i).V));
    
    % Probabilidad a priori de cada clase
    clase(i).pC = pC;
end

%% Guardar el entrenamiento
save('clase.mat', 'clase');

