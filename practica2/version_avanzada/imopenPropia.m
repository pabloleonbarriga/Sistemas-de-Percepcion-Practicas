%
function fTratar = imopenPropia(fTratar, plantilla)
%imopenPropia Funcion que realiza la misma funcionalidad que imopen.
%   Recibe la imagen a tratar y el elemento "strel" de tipo disco con el
%   que se realizara la operacion morfologica.

% Primero se realiza una erosion y posteriormente un dilatado
fTratar = imerodePropia(fTratar, plantilla);

fTratar = imdilatePropia(fTratar, plantilla);

end