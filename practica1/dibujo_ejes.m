function [pf] = dibujo_ejes(wtc, cRw, longitud)
%dibujo_ejes Funcion que dibuja los ejes de coordenadas
%   Recibe como parametros las matrices de rotacion y traslacion del origen
%   de coordenadas de los ejes del objeto que se quiera mostrar.

    x0 = wtc(1); y0 = wtc(2); z0 = wtc(3);
    pf = [longitud 0 0;0 longitud 0;0 0 longitud]*cRw ; % Ejes de la cámara rotados
    h1 = line([x0 x0+pf(1,1)],...
        [y0 y0+pf(1,2)],...
        [z0 z0+pf(1,3)],'LineWidth',1.5 ,'Color','g'); %x-axis : VERDE
    h2 = line([x0 x0+pf(2,1)],...
        [y0 y0+pf(2,2)],...
        [z0 z0+pf(2,3)],'LineWidth',1.5 ,'Color','b'); %y-axis : AZUL
    h3 = line([x0 x0+pf(3,1)],...
        [y0 y0+pf(3,2)],...
        [z0 z0+pf(3,3)],'LineWidth',1.5 ,'Color','r'); %z-axis : ROJO
    h = [h1 h2 h3];
    

end

