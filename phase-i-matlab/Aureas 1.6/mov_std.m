function nstd = mov_std(xmean,nueva_mean,n,std_p)
% std_clas(i_gad,:) = mov_std(mean_clas(i_gad,:),new_mean,conteo(i_gad),std_clas(i_gad,:));

a = (nueva_mean-xmean).^2;
b = (std_p.^2)./n;
c = (a+b).*(n-1);
nstd = c.^(1/2);

% sx = n*xmean;
% nsx = sx+xnew;
% ssx = (n-1)*std_p.^2+((sx).^2)./n;
% nssx = ssx + xnew.^2;
% nstd = (((1/((n+1)*n))*((n+1)*nssx-nsx.^2)).^(1/2));