%% Practica 1 - Sistemas de Percepcion
clear; %close all

%% Parametros de la camara
f = 4.2e-3;                     % Distancia focal: 4.2 mm = 4.2e-3 m
N = 1500;                       % Resolucion imagen, ancho = 1500 pix
M = 1000;                       % Resolucion imagen, alto = 1000 pix
anchoSensor = 4.96e-3;          % Ancho del sensor: 4.96 mm
altoSensor = 3.52e-3;           % Alto del sensor: 3.52 mm
u0 = round(N/2);                % Punto principal de la imagen: u0
v0 = round(M/2);                % Punto principal de la imagen: v0
skew = 0;                       % Coeficiente de no perpendicularidad

% Calculo de los parametros
rho_x = anchoSensor/N;  % Dimension efectiva de pixel, x
rho_y = altoSensor/M;   % Dimension efectiva de pixel, y
fx = f/rho_x;           % Longitud focal efectiva, horizontal [pix]
fy = f/rho_y;           % Longitud focal efectiva, veral [pix]

% Matriz de parametros intrinsecos
K = [fx     skew*fx     u0
    0       fy          v0
    0       0           1 ];

% Vectores con las esquinas de la camara
pXcamara = [1 1 N N];
pYcamara = [1 M M 1];

%% Parametros cuadro 1
alto = 1.016;     % Alto de 101'6 cms
ancho = 0.762;    % Ancho de 76'2 cms
cuadro1matriz_dim = [ancho/2 0; 0 alto/2];  % Matriz para multiplicar por "matriz_esquinas" y obtener las esquinas
cuadro1origen = [1.5, 3, 1.5]; % Origen del cuadro, la altura viene indicada por la 3a coordenada.
cuadro1X = zeros(1,5);
cuadro1Y = zeros(1,5);
cuadro1Z = zeros(1,5);

% Bucle para calcular las coordenadas 3D del cuadro. En este caso la
% coordenada Y se mantiene constante, puesto que el cuadro esta comprendido
% en el eje XZ.
matriz_esquinasCuadro1 = [-1 1; -1 -1; 1 -1; 1 1; -1 1];   % Matriz para calcular las esquinas de los cuadros mediante el punto central y el alto/ancho

for i = 1:5
    cuadro1XZ = cuadro1origen(1:2:3)' + cuadro1matriz_dim * matriz_esquinasCuadro1(i,:)';
    cuadro1X(i) = cuadro1XZ(1);
    cuadro1Y(i) = cuadro1origen(2);
    cuadro1Z(i) = cuadro1XZ(2);
end
cuadro1XYZ_ = [cuadro1X; cuadro1Y; cuadro1Z];
cuadro1XYZ = cuadro1XYZ_(:,1:4);

% Parametros para el calculo de las matrices mundo-cuadro y cuadro-mundo
XYZ_cuadro1 = cuadro1origen;    % Posicion XYZ del sistema de referencia, respecto al sistema de referencia {W}

% Angulos de giro segun convenio de ejes moviles ZYX
psi_cuadro1 = 0;    % Eje Z
theta_cuadro1 = 0;  % Eje Y
phi_cuadro1 = pi/2; % Eje X

[wtc_cuadro1, wRc_cuadro1, wTc_cuadro1, cTw_cuadro1, cRw_cuadro1, ctw_cuadro1] = calculo_wRc(XYZ_cuadro1, psi_cuadro1, theta_cuadro1, phi_cuadro1);


%% Parametros cuadro 2
alto = 1.232;     % Alto de 50 cms
ancho = 2.134;    % Ancho de 80 cms
cuadro2matriz_dim = [ancho/2 0; 0 alto/2];
cuadro2origen = [2, -3, 1.5]; % Origen del cuadro, la altura viene indicada por la 3a coordenada.
cuadro2X = zeros(1,5);
cuadro2Y = zeros(1,5);
cuadro2Z = zeros(1,5);

% Bucle para calcular las coordenadas 3D del cuadro. En este caso la
% coordenada Y se mantiene constante, puesto que el cuadro esta comprendido
% en el eje XZ.
matriz_esquinasCuadro2 = [1 1; 1 -1; -1 -1; -1 1; 1 1];   % Matriz para calcular las esquinas de los cuadros mediante el punto central y el alto/ancho
for i = 1:5
    cuadro2XZ = cuadro2origen(1:2:3)' + cuadro2matriz_dim * matriz_esquinasCuadro2(i,:)';
    cuadro2X(i) = cuadro2XZ(1);
    cuadro2Y(i) = cuadro2origen(2);
    cuadro2Z(i) = cuadro2XZ(2);
end
cuadro2XYZ_ = [cuadro2X; cuadro2Y; cuadro2Z];
cuadro2XYZ = cuadro2XYZ_(:,1:4);

% Parametros para el calculo de las matrices mundo-cuadro y cuadro-mundo
XYZ_cuadro2 = cuadro2origen;

% Angulos de giro segun convenio de ejes moviles ZYX
psi_cuadro2 = pi;
theta_cuadro2 = 0;
phi_cuadro2 = pi/2;

[wtc_cuadro2 ,wRc_cuadro2, wTc_cuadro2, cTw_cuadro2, cRw_cuadro2, ctw_cuadro2] = calculo_wRc(XYZ_cuadro2, psi_cuadro2, theta_cuadro2, phi_cuadro2);

%% Parametros cuadro 3
alto = 2.05;     % Alto de 50 cms
ancho = 2.0;    % Ancho de 80 cms
cuadro3matriz_dim = [ancho/2 0; 0 alto/2];
cuadro3origen = [5, 0, 1.5]; % Origen del cuadro, la altura viene indicada por la 3a coordenada.
cuadro3X = zeros(1,5);
cuadro3Y = zeros(1,5);
cuadro3Z = zeros(1,5);

% Bucle para calcular las coordenadas 3D del cuadro. En este caso la
% coordenada X se mantiene constante, puesto que el cuadro esta comprendido
% en el eje YZ.
matriz_esquinasCuadro3 = [1 1; 1 -1; -1 -1; -1 1; 1 1];   % Matriz para calcular las esquinas de los cuadros mediante el punto central y el alto/ancho

for i = 1:5
    cuadro3YZ = cuadro3origen(2:3)' + cuadro3matriz_dim * matriz_esquinasCuadro3(i,:)';
    cuadro3X(i) = cuadro3origen(1);
    cuadro3Y(i) = cuadro3YZ(1);
    cuadro3Z(i) = cuadro3YZ(2);
end
cuadro3XYZ_ = [cuadro3X; cuadro3Y; cuadro3Z];
cuadro3XYZ = cuadro3XYZ_(:,1:4);

% Parametros para el calculo de las matrices mundo-cuadro y cuadro-mundo
XYZ_cuadro3 = cuadro3origen;

% Angulos de giro segun convenio de ejes moviles ZYX
psi_cuadro3 = pi;
theta_cuadro3 = 0;
phi_cuadro3 = pi/2;

[wtc_cuadro3 ,wRc_cuadro3, wTc_cuadro3, cTw_cuadro3, cRw_cuadro3, ctw_cuadro3] = calculo_wRc(XYZ_cuadro3, psi_cuadro3, theta_cuadro3, phi_cuadro3);

%% Parametros unidos
cuadrosXYZ = [cuadro1XYZ cuadro2XYZ cuadro3XYZ];

%% Calculo de los movimientos de la camara y su proyeccion
nloop = 200;
long_ejes = 0.3;    % Parametro para indicar la longitud de los ejes de coordenadas de los sistemas, a la hora de representarlos en 3D

for i = 1:nloop
    
    fRender = 155*ones(M, N, 3);    % Para cada bucle de movimiento, se inicializa la imagen a renderizar
    tic
    
    %% Posicion y orientacion relativa de la camara
    % La posicion X de la camara varia segun avanza la simulacion, al igual
    % que la variable correspondiente al angulo de rotacion del eje Z, para
    % simular en movimiento circular de la camara.
    x0_cam = i/nloop * 2;
    y0_cam = 0;
    z0_cam = 1.5;
    XYZ_cam = [x0_cam y0_cam z0_cam];
    
    % Orientacion {C} respecto a {W}. Convenio de ejes ZYX moviles.
    psi_cam = -1/2*pi + pi/2*4 * (i / nloop);       % Ángulo de rotación respecto a eje Z (rojo).
    theta_cam = 0.5*0;                              % Ángulo de rotación respecto a eje Y' (azul).
    phi_cam = -pi/2;                                % Ángulo de rotación respecto a eje X''(verde).
    
    [wtc_cam ,wRc_cam, wTc_cam, cTw_cam, cRw_cam, ctw_cam] = calculo_wRc(XYZ_cam, psi_cam, theta_cam, phi_cam);
    
    
    
    %% Calculo de las esquinas de los cuadros en la imagen proyectada
    npuntos = length(cuadrosXYZ(1,:));
    wP1_ = [cuadrosXYZ; ones(1, npuntos)];         % Anadir coordenada homogenea
    pXcuadros = zeros(1, npuntos);
    pYcuadros = zeros(1, npuntos);
    for j = 1:npuntos
        p1_ = K * [cRw_cam ctw_cam] * wP1_(:,j); % Operar para obtener pixeles homogeneos
        p1 = p1_(1:2)/p1_(3);           % Dividir por la variable homogenea, obteniendo el valor en pixeles del punto
        p1 = round(p1);                 % Redondear puesto los pixeles no pueden ser flotantes
        pXcuadros(j) = p1(1);
        pYcuadros(j) = p1(2);
    end
    %     return
    pCuadros = [pXcuadros; pYcuadros]';
    
    %% Graficas
    figure(1); title("Imagen 3D");
    
    % Cuadro 1
    plot3(cuadro1origen(1), cuadro1origen(2), cuadro1origen(3), '.');
    hold on
    plot3(cuadro1XYZ_(1,:), cuadro1XYZ_(2,:), cuadro1XYZ_(3,:), '-*','Color','m');
    
    % Cuadro 2
    plot3(cuadro2origen(1), cuadro2origen(2), cuadro2origen(3), '.');
    hold on
    plot3(cuadro2XYZ_(1,:), cuadro2XYZ_(2,:), cuadro2XYZ_(3,:), '-*','Color','m');
    
    % Cuadro 3
    plot3(cuadro3origen(1), cuadro3origen(2), cuadro3origen(3), '.');
    hold on
    plot3(cuadro3XYZ_(1,:), cuadro3XYZ_(2,:), cuadro3XYZ_(3,:), '-*','Color','m');
    
    axis equal
    xlabel ("Eje X [metros]"); %xlim([0 8]);
    ylabel ("Eje Y [metros]"); %ylim([0 6]);
    zlabel ("Eje Z [metros]"); %zlim([-15 3]);
    
    [pf_origen] = dibujo_ejes(zeros(3,1), eye(3), 1);
    [pf_cam] = dibujo_ejes(wtc_cam, cRw_cam, long_ejes);
    [pf_cuadro1] = dibujo_ejes(wtc_cuadro1, cRw_cuadro1, long_ejes);
    [pf_cuadro2] = dibujo_ejes(wtc_cuadro2, cRw_cuadro2, long_ejes);
    [pf_cuadro3] = dibujo_ejes(wtc_cuadro3, cRw_cuadro3, long_ejes);
    hold off;
    
    
    
    % Calculo del plano de la imagen para comprobar que puntos se
    % encuentran a un lado y a otro
    vectornormal = pf_cam(3,:);
    puntoperteneciente = wtc_cam;   % El punto perteneciente es el origen de coordenadas de la camara
    Aplano = vectornormal(1);
    Bplano = vectornormal(2);
    Cplano = vectornormal(3);
    Dplano = -(Aplano * puntoperteneciente(1) + Bplano * puntoperteneciente(2) + Cplano * puntoperteneciente(3));
    plano = [Aplano Bplano Cplano Dplano];
    
    % Una vez se tiene todas las variables del plano, basta con sustituir
    % los puntos de los cuadros en la ecuacion del plano, y comprobar el
    % signo con un punto conocido a ese mismo lado del plano (el final del
    % eje Z de la camara, por ejemplo).
    pFinalZ = [x0_cam+pf_cam(3,1) y0_cam+pf_cam(3,2) z0_cam+pf_cam(3,3) 1]; % Se añade el 1 para multiplicar por Dplano
    resultado_comprobar = sign(plano * pFinalZ');
    
    % Una vez se tiene el signo de la operacion anterior, basta con
    % sustituir el punto a comprobar y verificar. En caso de que se
    % encuentre detrás del plano de la camara, no se operará.  
    figure(2); 
    for k = 0: npuntos/4 - 1             % Por cada cuadro
        todosdentro = 1;
        for l = 4*k + 1 : 4 * (k+1)       % Por cada punto de ese cuadro
            % Comprobar que se encuentren todos los puntos dentro
            pComprobar = wP1_(:, l);
            calculo_plano = sign(plano * pComprobar);
            if (calculo_plano ~= resultado_comprobar)   % Si se encuentran en lados distintos del plano
                todosdentro = 0;
                break;
            end
        end
        if (todosdentro == 1)   % Solo se mostraran aquellos cuadros cuyos puntos se encuentren en el mismo lado que el plano
            pXinputrender = pXcuadros(4*k + 1 : 4 * (k+1));
            pYinputrender = pYcuadros(4*k + 1 : 4 * (k+1));
            % Con la siguiente comprobacion unicamente se llama a
            % renderizar para aquellos cuadros que tengan algun pixel
            % dentro de la camara.
            if any(pXinputrender > 1) && any(pXinputrender < N) && any(pYinputrender > 1) && any(pYinputrender < M) 
                fRender = renderizadoImagen(4, [pXinputrender; pYinputrender]', M, N, fRender, k);
                rectangulo(pXcuadros(4*k + 1 : 4 * (k+1)), pYcuadros(4*k + 1 : 4 * (k+1)), 1); hold on;
            end
        end
    end
    rectangulo(pXcamara, pYcamara, 0);
    % Revertir el eje y, para que comience en la esquina superior izquierda
    set(gca,'YDir', 'reverse');axis equal
    % Situar el eje x en la parte superior del plot, permite facilitar la
    % visualización de la orientación de la cámara
    set(gca,'XAxisLocation', 'top');
    xlim([-29 N+30]);
    ylim([-29 M+30]);
    title("Proyeccion de los cuadros sobre el sensor de la camara")
    hold off;
     
    
    figure(3);imshow(uint8(fRender));title("Imagen renderizada");hold off;
%     pause(.5);
    
    % Revertir el eje y, para que comience en la esquina superior izquierda
    % set(gca,'YDir', 'reverse');
    % Situar el eje x en la parte superior del plot, permite facilitar la
    % visualización de la orientación de la cámara
    set(gca,'XAxisLocation', 'top');

end