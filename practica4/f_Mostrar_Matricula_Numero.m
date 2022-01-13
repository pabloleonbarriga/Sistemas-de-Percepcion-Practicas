function f_Mostrar_Matricula_Numero(fMatricula, matrizOrdenar, numeroNumeros, matriculaBayesiano, matriculaTextoBayesiano, matriculaLineal, matriculaTextoLineal)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

[nFilas, ~, ~] = size(fMatricula);
% Obtener imagen en RGB para poder mostrar los numeros detectas mas
% adelante.
fValidacionRGB = [];
for RGB = 1:3
    fValidacionRGB(:,:,RGB) = uint8(fMatricula * 150);
end

% Mostrar imagen
fValidacionRGB = uint8(fValidacionRGB);
figure();
imshow(fMatricula);
pause(0.00001);
for k = 1:numeroNumeros - 1
    text(matrizOrdenar(k, 5), nFilas / 2 - 20, sprintf("%d", matriculaBayesiano(k)), 'Color', 'cyan', 'FontSize', 40, 'FontWeight', 'bold');
    text(matrizOrdenar(k, 5), nFilas / 2 + 20, sprintf("%d", matriculaLineal(k)), 'Color', 'red', 'FontSize', 40, 'FontWeight', 'bold');
end
title(sprintf("Matricula clasificador bayesiano: %s. Matricula clasificador distancia minima: %s", matriculaTextoBayesiano, matriculaTextoLineal));
xlabel("Azul: clasificador bayesiano. Rojo: clasificador distancia minima");
end

