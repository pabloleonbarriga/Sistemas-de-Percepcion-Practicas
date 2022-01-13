function [nPicos,rhoHough,thetaHough] = pr3_Hough_RhoTheta(fTratada)
%f1_Hough_RhoTheta Funcion que obtiene los valores de rho y theta de las
%rectas principales de la imagen

% Aplicar la transformada de Hough para obtener las rectas principales
% de la imagen.
[H, tablaTheta, tablaRho] = hough(fTratada, 'Theta', -90:0.2:89);
Picos = houghpeaks(H, 20, 'Threshold', 0.3*max(H(:)),'nHoodSize', [31,31]);
nPicos = length(Picos(:,1));

% Obtener los valores en coordenadas polares de esas rectas
for k = 1:nPicos
    rhoHough(k) = tablaRho(Picos(k,1));
    thetaHough(k) = tablaTheta(Picos(k,2)) * pi / 180;
end
end

