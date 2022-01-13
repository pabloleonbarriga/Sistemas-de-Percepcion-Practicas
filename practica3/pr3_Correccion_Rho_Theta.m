function [rhoCorrecta,thetaCorrecta, fallo] = pr3_Correccion_Rho_Theta(rhoHough,thetaHough, i, rhoCorrecta, thetaCorrecta, limRho, limTheta, nPicos,primerFrame)
%f1_Correccion_Rho_Theta Funcion que compara y corrige los valores de rho y
%theta

% Inicializar valores
rho1 = rhoCorrecta(1);
rho2 = rhoCorrecta(2);
theta1 = thetaCorrecta(1);
theta2 = thetaCorrecta(2);


fallo = 0;

% Solo si nos encontramos en la primera iteracion, coger los dos
% valores de las rectas como validos (es importante comprobar que se
% parte de un par de rectas correctas).
if i == primerFrame
    rho1 = rhoHough(1); theta1 = thetaHough(1);
    rho2 = rhoHough(2); theta2 = thetaHough(2);
    rhoCorrecta = [rho1 rho2];
    thetaCorrecta = [theta1 theta2];
else
    % Para el resto de fotogramas, se compara el valor obtenido para
    % cada rho y theta con los de la iteracion anterior, teniendo en
    % cuenta que puede haber cierto margen, definido en las variables
    % limTheta y limRho.
    
    
    if (abs(rhoHough(1)) < abs(rho1) + limRho && abs(rhoHough(1)) > abs(rho1) - limRho) &&...
            (abs(thetaHough(1)) < abs(theta1) + limTheta && abs(thetaHough(1)) > abs(theta1) - limTheta)
        % Si la primera recta se corresponde con la primera recta en el
        % apartado anterior.
        %disp('El primero se corresponde con el primero');
        rho1 = rhoHough(1); theta1 = thetaHough(1);
        
        % Comprobar ahora si la segunda recta se corresponde con la
        % segunda del frame anterior.
        if (abs(rhoHough(2)) < abs(rho2) + limRho && abs(rhoHough(2)) > abs(rho2) - limRho) &&...
                (abs(thetaHough(2)) < abs(theta2) + limTheta && abs(thetaHough(2)) > abs(theta2) - limTheta)
            %disp('El segundo se corresponde con el segundo');
            rho2 = rhoHough(2); theta2 = thetaHough(2);
        else
            % En caso de que la segunda linea no se corresponda, se
            % debe buscar en el resto de rectas encontradas con la
            % transformada de Hough.
            fallo = 1;
            for j = 3:nPicos
                if (abs(rhoHough(j)) < abs(rho2) + limRho && abs(rhoHough(j)) > abs(rho2) - limRho) &&...
                        (abs(thetaHough(j)) < abs(theta2) + limTheta && abs(thetaHough(j)) > abs(theta2) - limTheta)
%                     fprintf("El segundo se corresponde con j: %d\n", j)
                    rho2 = rhoHough(j); theta2 = thetaHough(j);
                    %                         pause;
                    break;
                end
            end
            %disp('Error');
        end
        
        
        % En caso de que la recta 1 no se corresponda con la recta 1
        % del frame previo, comprobar si la recta 2 obtenida se
        % corresponde con la primera del frame anterior.
    elseif (abs(rhoHough(2)) < abs(rho1) + limRho) && abs(rhoHough(2)) > abs(rho1) - limRho &&...
            (abs(thetaHough(2)) < abs(theta1) + limTheta && abs(thetaHough(2)) > abs(theta1) - limTheta)
        %disp('El segundo se corresponde con el primero');
        rho1 = rhoHough(2); theta1 = thetaHough(2);
        % Comprobar ahora si la primera recta se corresponde con la
        % segunda del frame anterior.
        if (abs(rhoHough(1)) < abs(rho2) + limRho && abs(rhoHough(1)) > abs(rho2) - limRho) &&...
                (abs(thetaHough(1)) < abs(theta2) + limTheta && abs(thetaHough(1)) > abs(theta2) - limTheta)
            %disp('El segundo se corresponde con el primero');
            rho2 = rhoHough(1); theta2 = thetaHough(1);
        else
            % En caso de que la segunda linea no se corresponda, se
            % debe buscar en el resto de rectas encontradas con la
            % transformada de Hough.
            fallo = 1;
            for j = 3:nPicos
                if (abs(rhoHough(j)) < abs(rho2) + limRho && abs(rhoHough(j)) > abs(rho2) - limRho) &&...
                        (abs(thetaHough(j)) < abs(theta2) + limTheta && abs(thetaHough(j)) > abs(theta2) - limTheta)
%                     fprintf("El primero se corresponde con j: %d\n", j)
                    rho2 = rhoHough(j); theta2 = thetaHough(j);
                    %                         pause;
                    break;
                end
            end
            %disp('Error');
        end
    else
        fallo = 1;
        % Si no se encuentra el valor requerido en las dos primeras,
        % buscar en el resto de rectas encontradas. Se itera en el resto de
        % picos, para obtener aquel que tenga el valor más proximo al
        % anterior.
        for j = 3:nPicos
            if (abs(rhoHough(j)) < abs(rho1) + limRho) && abs(rhoHough(j)) > abs(rho1) - limRho &&...
                    (abs(thetaHough(j)) < abs(theta1) + limTheta && abs(thetaHough(j)) > abs(theta1) - limTheta)
                if (abs(rhoHough(j)) - abs(rhoCorrecta(1)) <  abs(rho1) - abs(rhoCorrecta(1))) &&...
                        (abs(thetaHough(j)) - abs(thetaCorrecta(1)) <  abs(theta1) - abs(thetaCorrecta(1)))
                    rho1 = rhoHough(j); theta1 = thetaHough(j);
                end
            end
            if (abs(rhoHough(j)) < abs(rho2) + limRho) && abs(rhoHough(j)) > abs(rho2) - limRho &&...
                    (abs(thetaHough(j)) < abs(theta2) + limTheta && abs(thetaHough(j)) > abs(theta2) - limTheta)
                if (abs(rhoHough(j)) - abs(rhoCorrecta(2)) <  abs(rho2) - abs(rhoCorrecta(2))) &&...
                        (abs(thetaHough(j)) - abs(thetaCorrecta(2)) <  abs(theta2) - abs(thetaCorrecta(2)))
                    rho2 = rhoHough(j); theta2 = thetaHough(j);
                end
            end
        end
        
        
    end
    
    % Actualizar valores de rho y theta
    rhoCorrecta = [rho1 rho2];
    thetaCorrecta = [theta1 theta2];
end
end

