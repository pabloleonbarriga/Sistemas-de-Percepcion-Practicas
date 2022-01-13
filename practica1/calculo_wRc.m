function [wtc,wRc, wTc, cTw, cRw, ctw] = calculo_wRc(XYZ, psi, theta, phi)
%calculo_wRc Calculo de la matriz de rotacion total con los parametros de
%entrada de los angulos de giro segun convenio de ejes moviles ZYX.
x0 = XYZ(1);
y0 = XYZ(2);
z0 = XYZ(3);

% Matriz de traslacion mundo-camara
wtc = [x0, y0, z0]';

% Calculo de matrices de rotacion Rz, Ry, Rx
Rz = [cos(psi)  -sin(psi)   0;
    sin(psi)  cos(psi)    0;
    0         0           1];

Ry = [cos(theta)    0   	sin(theta)
    0               1       0
    -sin(theta)     0       cos(theta) ];

Rx = [1   0           0
    0   cos(phi)    -sin(phi)
    0   sin(phi)    cos(phi) ];

% Calculo de la matriz de rotacion total
wRc = Rz*Ry*Rx;

% Matriz de rotacion + traslacion
wTc = [wRc wtc; [0 0 0 1]];

% Matrices traslación cámara-mundo, rotación cámara-mundo
cTw = inv(wTc);         % Rotacion + traslacion camara mundo
cRw = cTw(1:3,1:3);     % Rotacion camara mundo
ctw = cTw(1:3,4);       % Traslacion camara mundo

end

