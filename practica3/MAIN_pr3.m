% Practica 3 - Sistemas de Percepcion - Pablo Leon Barriga
clc;clear;close all;
fprintf("Practica 3 - Sistemas de Percepcion, Pablo Leon Barriga\n");
fprintf("El programa se parara cada vez que se detecte un error, para continuar basta con pulsar cualquier tecla.\n");
fprintf("Si se quiere ralentizar la muestra de imagenes, aumentar el valor de ""pausa"" (valor en segundos), en la linea 6.\n");
pausa = 0.00000001;

%% Inicializacion de variables/graficas

% Obtener tamano de la imagen a tratar
imagenLeer = sprintf('secuenciaBicicleta/000260.jpg');
fOriginal = imread(imagenLeer);
fResized = imresize(fOriginal, 0.30);
[nFilas, nColumnas, ~] = size(fOriginal);
[nFilasResized, nColumnasResized, ~] = size(fResized);

% Obtener una primera imagen tratada para tener una imagen binaria.
fTratada = pr3_Tratado_Imagen(260);

% Inicializar graficos
% Crear las graficas, para evitar hacer imshow una y otra vez.
figure('units','normalized','outerposition',[0 0 1 1])  % Pantalla completa
set(gcf,'color','white');       % Figura con fondo blanco
subplot(2,2,1);p1 = imshow(fResized, []);
subplot(2,2,2);p2 = imshow(fTratada, []);title('Lineas de interes, sin corregir');
subplot(2,2,3);p3 = imshow(fTratada, []);title('Lineas de interes, corregidas');
subplot(2,2,4);p4 = imshow(fResized, []);title('Segmentacion de la calzada');
pause(0.0001);  % Este pause sirve para darle tiempo a la ventana a crearse

% Contador de fallos
contador_fallos = 0;

%% Limites para la discrepancia entre valores de rho y theta
diag = (nFilas^2+nColumnas^2)^0.5;
limRho = 0.01*diag; % 1% de la diagonal
limTheta = 7.5*pi/180;   % 15 grados

rhoCorrecta = [0 0];
thetaCorrecta = [0 0];

primerFrame = 260;
ultimoFrame = 790;

%% Programa principal - recorre cada fotograma y opera
for i = primerFrame:ultimoFrame
    
    % Obtener la imagen tratada
    [fTratada, fResized] = pr3_Tratado_Imagen(i);
    
    % Calcular las rectas principales utilizando la transformada de Hough
    [nPicos,rhoHough,thetaHough] = pr3_Hough_RhoTheta(fTratada);
    
    % Corregir los valores de rho y theta. Se comprueba la correspondencia
    % entre las dos thetas y rho obtenidas en esta iteracion con las de la
    % iteracion anterior.
    [rhoCorrecta,thetaCorrecta, fallo] = pr3_Correccion_Rho_Theta(rhoHough,thetaHough, i, rhoCorrecta, thetaCorrecta, limRho, limTheta, nPicos,primerFrame);
    
    % Una vez se tienen los valores correctos de rho y theta (es decir,
    % manteniendo el orden que se establecion en la primera iteracion),
    % calcular la mascara que se corresponde con la segmentacion de la
    % calzada.
    [fMascara] = pr3_Obtener_Plantillas(nFilasResized,nColumnasResized, thetaCorrecta, rhoCorrecta);
    
    % Calcular la interseccion de cada recta con los bordes de la imagen.
    %   - interseccionErronea: se calcula con los dos primeros valores que
    %       devuelve la funcion pr3_Hough_RhoTheta.
    %   - interseccionCorrecta: se calcula con los valores ya corregidos
    %       de Rho y Theta en la funcion pr3_Correccion_Rho_Theta
    interseccionErronea = pr3_Calculo_Intersecciones(rhoHough,thetaHough, nFilasResized, nColumnasResized);
    interseccionCorrecta = pr3_Calculo_Intersecciones(rhoCorrecta,thetaCorrecta, nFilasResized, nColumnasResized);
    
    
    % Mostrar imagenes deseadas
    
    % 1 - Imagen de tamano reducido
    subplot(2,2,1);
    set(p1, 'CData', fResized);
    title(sprintf("Fotograma actual: 000%d.jpg", i));
    
    % 2 - Dos primeras lineas de Hough
    subplot(2,2,2);
    pr3_DibujaLineas(fTratada,interseccionErronea, 0, i, p2, primerFrame);
    if (fallo == 1)
        xlabel("Error. Pulse cualquier tecla para continuar");
    else
        xlabel(" ");
    end
    
    % 3 - Lineas corregidas
    subplot(2,2,3);
    pr3_DibujaLineas(fTratada,interseccionCorrecta, 1, i, p3, primerFrame);
    
    % 4 - Imagen con la calzada segmentada
    subplot(2,2,4);
    set(p4, 'CData', uint8(fMascara).*fResized);
    
    % Informar de los fallos
    if fallo == 1
        contador_fallos = contador_fallos + 1;  % Aumentar el contador de fallos
        fprintf("Se produjo un fallo en la imagen secuenciaBicicleta/000%d.jpg. Contador de fallos: %d. Pulse cualquier tecla para continuar.\n", i, contador_fallos);
        pause();    % Parar el programa para dar tiempo a visualizar el error.
    end
    
    % Pausa para dar tiempo a actualizar cada subplot. Si se quiere
    % ralentizar la muestra de imagenes basta con aumentar el valor.
    pause(pausa);
    
end

%% Estadisticas

% Numero de fotogramas
nFrames = ultimoFrame - primerFrame;

% Porcentaje de fallos
error_relativo = contador_fallos / nFrames * 100;

% Mostrar por terminal 
fprintf("Se produjeron %d fallos de un total de %d imagenes. Porcentaje de aciertos: %.2f%%. Porcentaje de fallos: %.2f%%\n", contador_fallos, nFrames, 100 - error_relativo, error_relativo);
