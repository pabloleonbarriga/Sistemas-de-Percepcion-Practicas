function interseccion = pr3_Calculo_Intersecciones(rhoHough,thetaHough,nFilas, nColumnas)
%f1_Calculo_Intersecciones Funcion que calcula la intersecciones con los
%bordes de la imagen

% Vectores que contienen los valores rho y theta de cada uno de los bordes
% de la imagen
rhoLineasBorde =    [0,       nFilas,   0,  nColumnas];
thetaLineasBorde =  [pi/2,   pi/2,      0,  0];

interseccion = [];
% Por cada linea (2 en cada caso).
for k = 1:2
    cont = 0;
    % Por cada posible interseccion
    for l = 1:4
        % Calcular la interseccion, redondear para obtener el valor en
        % pixel
        interseccionX= round((rhoHough(k)*sin(thetaLineasBorde(l)) - rhoLineasBorde(l)*sin(thetaHough(k))) / ...
            (cos(thetaHough(k)) * sin(thetaLineasBorde(l)) - cos(thetaLineasBorde(l)) * sin(thetaHough(k))));
        interseccionY = round((rhoLineasBorde(l)*cos(thetaHough(k)) - rhoHough(k)*cos(thetaLineasBorde(l))) / ...
            (cos(thetaHough(k)) * sin(thetaLineasBorde(l)) - cos(thetaLineasBorde(l)) * sin(thetaHough(k))));
        
        % Comprobar que el resultado de la interseccion no resulta ser
        % infinito (lineas paralelas a alguno de los bordes de la imagen).
        if (interseccionX ~= Inf && interseccionY ~= Inf)
            interseccion = [interseccion; interseccionX interseccionY];
            cont = cont + 1;
        end
        
        % Una vez se obtienen dos intersecciones, parar de calcular.
        if cont == 2
            break;
        end
    end
end
end

