function [X] = ZscoreMV(X,media,des)

%Permite calcular el zscore para una media y var determinada
    [num_datos, num_feat] = size(X);
    Meansc = repmat(media,num_datos,1);
    Varnsc = repmat(des,num_datos,1);
    
    X=(X-Meansc)./(Varnsc);
end

