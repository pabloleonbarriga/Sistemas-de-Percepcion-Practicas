function pr3_DibujaLineas(fTratada,interseccion, recta_a_pintar, indice, p, primerFrame)
%f1_Dibuja Funcion que dibuja las rectas sobre la imagen original

% b1 y b2 son variables en las que se guarda el plot de las lineas de una
% iteracion a otra, permite borrar exclusivamente las lineas para poder
% dibujar las del siguiente fotograma.
persistent recta1 recta2

% Vector para los colores de la primera y segunda linea de hough.
colores = ["red" "green"];

% Si no se trata del primer frame, borrar las lineas del frame anterior
if indice > primerFrame
    if (recta_a_pintar) == 0
        delete(recta1);
    else
        delete(recta2);
    end
end

% Mostrar la imagen tratada
set(p, 'CData', fTratada);
hold on

% Dibujar cada una de las lineas, seguns se trate de la imagen con lineas
% sin corregir o corregidas.
for a = 0:1
    if recta_a_pintar == 0
        recta1(a+1) = plot(interseccion(2*a + 1:2*a +2,1), interseccion(2*a + 1:2*a +2,2),'LineWidth', 2, 'Color', 'cyan');
    else
        recta2(a+1) = plot(interseccion(2*a + 1:2*a +2,1), interseccion(2*a + 1:2*a +2,2),'LineWidth', 2, 'Color', colores(a+1));
    end
end
hold off
end

