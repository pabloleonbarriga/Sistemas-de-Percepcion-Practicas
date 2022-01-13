function f1_calculo_avanzada(fTratada, fOriginal, indice_plot, nombre_colores)
%f1_calculo: Funcion que realiza los calculos necesarios para obtener los
%centros de masa de los objetos a individualizar.

% Radio de los objetos, en pixeles
radioMM = 18;

% Convertir la imagen de entrada a imagen logica.
fEtiquetada = bwlabel(fTratada);

% Preparar subplot para mostrar cada color por separado
figure(2); subplot(2, 3, indice_plot);imshow(fOriginal,[]);title(nombre_colores(indice_plot));

% Obtener los datos de area, perimetro y bounding box de cada objeto.
datos = regionpropsPropia(fEtiquetada);

for i = 1:length(datos)
    areaObj = datos(i).Area;
    boundingboxObj = round(datos(i).BoundingBox);
    centroObj = datos(i).Centroid;
    
    % Comprobar que se trata de un unico objeto, y no la union de varios
    % que no se han podido individualizar. Se utiliza el area, pero podria
    % utilizarse la circularidad por ejemplo.
    if (areaObj > 1500)
        % Si se trata de mas de un objeto, se procede a realizar
        % operaciones de erosion hasta conseguir individualizar los
        % objetos.
        
        % Se calcula el numero de objetos que hay en el segmento mal
        % individualizado
        numObjetos = round(areaObj / 1000);
        
        % Obtener valores de bounding boxes, pasados a filas/columnas de la
        % imagen tratada (filas se corresponde con la Y, columnas con la X)
        pFila_inicio = boundingboxObj(2);
        pFila_final = boundingboxObj(2) + boundingboxObj(4);
        pColumna_inicio = boundingboxObj(1);
        pColumna_final = boundingboxObj(1) + boundingboxObj(3);
        
        % Recortar la imagen para aplicar el procesamiento solo en la parte
        % fallida. A partir de ahora todos los valores seran "locales" a la
        % seccion fallida, por lo que se necesitara reconvertirlos a
        % coordenadas "globales".
        fRecortada = fTratada(pFila_inicio-2:pFila_final+2, pColumna_inicio-2:pColumna_final+2);    % Se le da un pequeno margen para evitar que los bordes esten a 1.
        datosIndividualizados = regionpropsPropia(fRecortada);
        elem = strelPropia(1);
        
        % Se hace erosion con un disco de 1 de radio. Mientras que el numero
        % que devuelve regionprops es menor al calculado de objetos,
        % continuar iterando erosiones hasta cumplir la condicion.
        while(length(datosIndividualizados) < numObjetos)
            fRecortada = imerodePropia(fRecortada, elem);
            fEtiq = bwlabel(fRecortada);
            datosIndividualizados = regionpropsPropia(fEtiq);
        end
        
        % Una vez se tienen individualizados, se procede a dibujar su
        % bounding box y centroide.
        for j = 1:length(datosIndividualizados)
            centroX = round(pColumna_inicio + datosIndividualizados(j).Centroid(1));
            centroY = round(pFila_inicio + datosIndividualizados(j).Centroid(2));
            line([centroX centroX], [centroY centroY], 'Marker','o','MarkerFaceColor','b','MarkerSize',5,'MarkerEdgeColor','w');
            
            % Obtener los valores de las bounding boxes
            pFila_inicioInd = datosIndividualizados(j).Centroid(2) - radioMM;
            pFila_finalInd = datosIndividualizados(j).Centroid(2) + radioMM;
            pColumna_inicioInd = datosIndividualizados(j).Centroid(1) - radioMM;
            pColumna_finalInd = datosIndividualizados(j).Centroid(1) + radioMM;
            
            % Devolver a coordenadas "globales" sumando el inicio de la
            % bounding box que se utilizo para recortar la imagen
            pFila_inicioInd = pFila_inicioInd + pFila_inicio;
            pFila_finalInd = pFila_finalInd + pFila_inicio;
            pColumna_inicioInd = pColumna_inicioInd + pColumna_inicio;
            pColumna_finalInd = pColumna_finalInd + pColumna_inicio;
            
            % Dibujar cada bounding box
            line([pColumna_inicioInd pColumna_finalInd pColumna_finalInd pColumna_inicioInd pColumna_inicioInd], [pFila_inicioInd pFila_inicioInd pFila_finalInd pFila_finalInd pFila_inicioInd],...
                'Color','cyan','LineWidth', 2);
            
            % Dibujar ademas el bounding box "erroneo"
            line([pColumna_inicio pColumna_final pColumna_final pColumna_inicio pColumna_inicio], [pFila_inicio pFila_inicio pFila_final pFila_final pFila_inicio],...
                'Color','yellow','LineWidth', 2);
        end
    
    else
        % En caso de que se trate de un unico objeto bien individualizado,
        % dibujar el centro de masa y su bounding box.
        % Obtener valores de bounding boxes, pasados a filas/columnas de la
        % imagen tratada (filas se corresponde con la Y, columnas con la X)
        pFila_inicio = boundingboxObj(2);
        pFila_final = boundingboxObj(2) + boundingboxObj(4);
        pColumna_inicio = boundingboxObj(1);
        pColumna_final = boundingboxObj(1) + boundingboxObj(3);
        centroFila = centroObj(1);
        centroColum = centroObj(2);
        
        % Dibujar cada bounding box
        line([pColumna_inicio pColumna_final pColumna_final pColumna_inicio pColumna_inicio], [pFila_inicio pFila_inicio pFila_final pFila_final pFila_inicio],...
            'Color','green','LineWidth', 2);
        % Dibujar centro
        line([centroFila centroFila], [centroColum centroColum], 'Marker','o','MarkerFaceColor','b','MarkerSize',5,'MarkerEdgeColor','w');
    end
end
end

