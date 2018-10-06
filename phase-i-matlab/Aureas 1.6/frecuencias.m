function [dom,mini,maxi] = frecuencias(seg,band_1,band_2); %segmento, freq_min, freq_ max
%Cálculo de frecuencias máximas, mínimas, dominante de un segmento de
%espectrograma
seg=abs(seg).^2;
seg=medfilt2(seg,[10 10]);
[C,I]=max(seg,[],2); 
[c,i]=max(C);
dom=((band_2-band_1)/length(I))*i+band_1; % i es la frecuencia dominante
men=find(C>prctile(C,1)); % encuente valores mayores al percentil 20
maxi=((band_2-band_1)/length(I))*men(end)+band_1; %end por que en el espectrograma como variable se invierte el eje y
mini=((band_2-band_1)/length(I))*men(1)+band_1;
end

