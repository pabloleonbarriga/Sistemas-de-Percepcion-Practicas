function H = HomographySolve (pIn, pOut)
%
% H = HomographySolve (pIn, pOut)
%
%    Funci�n que encuentra la matriz de homograf�a a partir de, al menos, 4 parejas de puntos.
%    Usa el m�todo de descomposici�n en valores singulares (SVD) descrito, por ejemplo, en:
%    http://www.robots.ox.ac.uk/%7Evgg/presentations/bmvc97/criminispaper/node3.html
%
%    Adaptaci�n a partir de la versi�n original de David Young, University of Sussex, February 2008.
%
% Par�metros:
%    pIn:  Matriz de dimensiones 2xn correspondiente a los puntos de entrada:
%          pIn = [x1 x2 x3 ...;
%                 y1 y1 y3 ... ]
%    pOut: Matriz de dimensiones 2xn correspondiente a los puntos de salida con la misma estructura
%          que 'pIn'.
%
%    H:    Se devuelve la matriz de homograf�a que transforma 'pIn' en 'pOut':
%          pOut = H * pIn;
%

if size(pIn,1) ~= size(pOut,1)  |  size(pIn,2) ~= size(pOut,2)
    error ('Las dimensiones de las matrices de puntos deben ser iguales');
end
if size(pIn,1) ~= 2
    error ('Las matrices de puntos deben ser de dimensiones 2xn');
end
n = size(pIn,2);
if n < 4
    error ('N�mero de puntos insuficiente');
end

% Componemos la matriz de coeficientes para el sistema de ecuaciones homog�neo:
A11 = [pIn' ones(n,1)];
A12 = zeros(n,3);
A13 = - [ pIn(1,:)' .* pOut(1,:)' ,  pIn(2,:)' .* pOut(1,:)' ,   pOut(1,:)' ];
A23 = - [ pIn(1,:)' .* pOut(2,:)' ,  pIn(2,:)' .* pOut(2,:)' ,   pOut(2,:)' ];
A = [A11 A12 A13;
     A12 A11 A23];

if n == 4
   [U,D,V] = svd(A);
else
   [U,D,V] = svd(A,'econ');
end

% Dado que svd() devuelve los valores singulares ordenados de mayor a menor, el valor singular m�s 
% cercano a cero es el �ltimo. El vector singular correspondiente es, por tanto, el contenido en la 
% �ltima columna de V:
h = V(:,end);

% Conformamos la matriz de homograf�a:
H = reshape(h,3,3)';
