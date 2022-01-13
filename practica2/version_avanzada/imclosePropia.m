%
function fTratar = imclosePropia(fTratar, plantilla)
%imclosePropia Funcion que realiza la misma funcionalidad que imclose.
%   Recibe la imagen a tratar y el elemento "strel" de tipo disco con el
%   que se realizara la operacion morfologica.

% Primero se realiza un dilatado y posteriormente una erosion
fTratar = imdilatePropia(fTratar, plantilla);

fTratar = imerodePropia(fTratar, plantilla);


end