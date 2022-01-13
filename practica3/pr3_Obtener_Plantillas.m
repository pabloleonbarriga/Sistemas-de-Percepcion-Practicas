function [fPlantilla] = pr3_Obtener_Plantillas(nFilas,nColumnas, thetaCorrecta, rhoCorrecta)
%f1_Obtener_Plantillas Función que recibe el numero de filas y columnas y
%devuelve la mascara con la carretera aislada.

% Crear las plantillas con el tamano deseado.
fPlantilla = zeros(nFilas, nColumnas);

% Se recorre cada pixel de la imagen, y se calcula el valor de rho para
% cada una de las rectas, dejando fijas sus thetas correspondientes.
for x = 1:nColumnas
    for y = 1:nFilas
        theta1 = thetaCorrecta(1);
        theta2 = thetaCorrecta(2);
        rho1 = x * cos(theta1) + y * sin(theta1);
        rho2 = x * cos(theta2) + y * sin(theta2);
        
        % Una vez obtenido theta, basta con comprobar si rho se encuentra
        % entre las dos rectas.
        if ((rho1 > rhoCorrecta(1) && theta1 > 0) || (rho1 < rhoCorrecta(1) && theta1 < 0))...
                && ((rho2 < rhoCorrecta(2) && theta2 > 0) || (rho2 > rhoCorrecta(2) && theta2 < 0))
            fPlantilla(y,x) = 1;
        end
    end
end

end

