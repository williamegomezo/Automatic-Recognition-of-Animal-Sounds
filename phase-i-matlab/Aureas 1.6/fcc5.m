%%%% parte final de los MFCCs
%FCCs con escalamiento lineal

% f es un segmento (canto)  calculado con estos parámetros: f=spectrogram(signal(:,1),flattopwin(256),128,256,FS); %256,128,256

function [y]=fcc5(canto,nfiltros,nc,nframes)


    [a,b]=size(canto);

    div=nframes;

    w=floor(b/div); %5
    p=1;

    for k=1:w:w*div
        B(:,p)=sum(abs(canto(:,k:k+w-1)).^2,2); %energía para todos los bines
        p=p+1;
    end

    numfilt=nfiltros;
    
    
    if  a>=numfilt
        H=zeros(numfilt,a);
        wf=floor(a/numfilt);
        i=1;
        for k=1:wf:wf*numfilt
            H(i,:)= gaussmf(1:a,[wf/4 k+wf-1]);
            %H(i,k:k+wf-1)=1;
            i=i+1;
        end
    end

    FBE = H * B;
    
    N=nc;
    M=numfilt;
    
    dctm = @( N , M )( sqrt(2.0/M) * cos( repmat([0:N-1].',1,M) ...
                                           .* repmat(pi*([1:M]-0.5)/M,N,1) ) );
    
    
    DCT = dctm( N , M );
    CC =  DCT * log( FBE );  
    
    y = CC;
end
