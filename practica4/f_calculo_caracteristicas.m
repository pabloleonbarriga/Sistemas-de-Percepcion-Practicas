function x = f_calculo_caracteristicas(fNumeroResized)
%f_calculo_caracteristicas Funcion que recibe la imagen del numero y 

% Obtener numero de filas y columnas
[nFilas, nColumnas, ~] = size(fNumeroResized);

% Inicializar variables
x1 = 0; x2 = 0; x3 = 0; x4 = 0; x5 = 0;
x6 = 0; x7 = 0; x8 = 0; x9 = 0; x10 = 0;
x11 = 0; x12 = 0; x13 = 0;

% Recorrer la imagen y 
for i = 1:nFilas
    for j = 1:nColumnas
        
        % Imagen entera
        x1 = x1 + fNumeroResized(i, j);
        
        % Imagen divida en 4 segmentos
        %
        % |---------|---------|
        % |         |         |
        % |   x2    |    x3   |
        % |         |         |
        % |---------|---------|
        % |         |         |
        % |   x4    |    x5   |
        % |         |         |
        % |---------|---------|
        %   
        if (i <= nFilas / 2) && (j <= nColumnas / 2)
            x2 = x2 + fNumeroResized(i, j);
        elseif (i <= nFilas / 2) && (j >= nColumnas / 2)
            x3 = x3 + fNumeroResized(i, j);
        elseif (i >= nFilas / 2) && (j <= nColumnas / 2)
            x4 = x4 + fNumeroResized(i, j);
        elseif (i >= nFilas / 2) && (j >= nColumnas / 2)
            x5 = x5 + fNumeroResized(i, j);
        end
        
        
        % Imagen divida en 8 segmentos
        %
        % |---------|---------|
        % |   x6    |   x7    |
        % |---------|---------|
        % |   x8    |   x9    |
        % |---------|---------|
        % |   x10   |   x11   |
        % |---------|---------|
        % |   x12   |   x13   |
        % |---------|---------|
        %   
        if (i <= nFilas / 4) && (j <= nColumnas / 2)
            x6 = x6 + fNumeroResized(i, j);
        elseif (i <= nFilas / 4) && (j >= nColumnas / 2)
            x7 = x7 + fNumeroResized(i, j);
        elseif (i >= nFilas / 4 && i <= nFilas / 2) && (j <= nColumnas / 2)
            x8 = x8 + fNumeroResized(i, j);
        elseif (i >= nFilas / 4 && i <= nFilas / 2) && (j >= nColumnas / 2)
            x9 = x9 + fNumeroResized(i, j);
        elseif (i >= nFilas / 2 && i <= nFilas * 3/4) && (j <= nColumnas / 2)
            x10 = x10 + fNumeroResized(i, j);
        elseif (i >= nFilas / 2 && i <= nFilas * 3/4) && (j >= nColumnas / 2)
            x11 = x11 + fNumeroResized(i, j);
        elseif (i >= nFilas * 3/4) && (j <= nColumnas / 2)
            x12 = x12 + fNumeroResized(i, j);
        elseif (i >= nFilas * 3/4) && (j >= nColumnas / 2)
            x13 = x13 + fNumeroResized(i, j);
        end
    end
end
% Montar vector X
x = [x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13];
end

