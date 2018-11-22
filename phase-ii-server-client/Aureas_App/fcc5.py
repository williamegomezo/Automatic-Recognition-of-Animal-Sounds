import numpy as np

def gaussfm(x, sig, c):
	return np.exp((-(x-c)**2)/(2*(sig**2)))

def fcc5(canto, nfiltros, nc, nframes):
	canto = np.array(canto)
	[a,b] = np.shape(canto)
	div = nframes
	w = np.int(np.floor(b/div))

	if (w != 0) & (a >= nfiltros):
		B = np.zeros((a,1))
		
		for k in np.arange(0,w*div,w):
			B = np.concatenate((B,np.matrix(np.sum(np.abs(canto[:,k:k+w])**2,1)).T), axis=1)

		B = B[:,1:]

		H = np.zeros((nfiltros,a))
		if a >= nfiltros:
			wf = np.int(np.floor(a/nfiltros))
			i = 0
			for k in np.arange(0,wf*nfiltros,wf):
				H[i,:] = gaussfm(np.arange(1,a+1), wf/4, k+wf)
				i+=1

		FBE = np.dot(H,B)
		N = nc
		M = nfiltros
		DCT = np.sqrt(2.0/M)*np.cos(np.array(np.tile(np.matrix(np.arange(0,N)).T,(1,M)))*np.array(np.tile(np.pi*(np.arange(1,M+1)-0.5)/M,(N,1))))
		CC = np.dot(DCT,np.log(FBE))
		y = CC
	else:
		y = []
	return y