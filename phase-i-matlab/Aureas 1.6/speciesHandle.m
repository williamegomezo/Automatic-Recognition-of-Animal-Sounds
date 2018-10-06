%Clase estática que modifica la base de datos
classdef speciesHandle < handle     
    methods (Static)
        %Cargar especies
        function loadSpecies()
            global species;
            s=load('Species.mat');
            species=s.species;
        end 
        
        %Obtener especies
        function rSpecies=getSpecies() 
            if length(dir('Species.mat'))>0
                rSpecies=load('Species.mat');
                rSpecies=rSpecies.species;
            else
                rSpecies=[];
            end
        end
                
        
        %Agregar especie
        function addSpecies(dataSpec)

            if length(dir('Species.mat'))>0
                rSpecies=load('Species.mat');
                species=rSpecies.species;
                species=[species; dataSpec];
            else
                species=dataSpec;
            end

            save('Species.mat','species');
            speciesHandle.notifyObservers(species);
        end
        
        %Actualizar species.
        function updateSpecies(species)
            save('Species.mat','species');
            speciesHandle.notifyObservers(species);
        end
        
        %Remover especie
        function rmSpecies(ind)
            rSpecies=load('Species.mat');
            species=rSpecies.species;
            species(ind,:)=[];
            save('Species.mat','species');
            speciesHandle.notifyObservers(species);
        end
        
        %Registrar observador 
        function registerObs(obs)
            global observers;
            observers=[observers obs];            
        end
        
        %Eliminar observador
        function removeObs(obs)
            global observers;
            observers(observers==obs)=[];
        end
        
        %Notificar a los observadores de cambios en la base de datos de
        %especies
        function notifyObservers(species)
            global observers;
            for i=1:length(observers)
                observers(i).update(species);
            end
        end
    end
end