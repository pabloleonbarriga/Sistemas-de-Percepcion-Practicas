function rectangulo(pX,pY, param)
%rectangulo
%   Funcion que dibuja en la grafica de la camara los trapecios
%   correspondientes a la silueta de los cuadros, asi como el borde de la
%   camara.
    pXY = [pX ; pY ]';
    pXY = [pXY; pXY(1, 1) pXY(1, 2)];

    if param == 0
        aux = '-';
        grosor = 2;
    else 
        aux = '-o';
        grosor = 1;
    end
    plot(pXY(:,1), pXY(:,2), aux, 'Color', 'black', 'Linewidth', grosor)
end

