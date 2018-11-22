import matplotlib.patches as patches
from scipy import signal
import numpy as np
from . import fcc5

def SegmentacionPaisaje(x, resiz, s, fs, ax1, en):

	featuresAudio = []
	[u, v] = s.shape

	band_1=1/u
	band_2=1
	p = 1

	for j in range(0,p):

		mfband = s[np.int(np.round(band_1*u)):np.int(np.round(band_2*u)),:]
		mfband = signal.medfilt2d(mfband, 5)
		selband = mfband
		D = np.std(mfband,1)
		L = 10 ##Filtro de media movil
		coefs = np.ones(L)/float(L)
		D = np.convolve(D, coefs, mode='same')
		D = np.convolve(D, coefs, mode='same')
		Y = -D+np.max(D)
		
		locsY = signal.find_peaks_cwt(Y,np.arange(1,20))
		peaksY = Y[locsY]
		locsD = signal.find_peaks_cwt(D,np.arange(1,20))
		peaksD = D[locsD]

		indx = []
		for x in range(0,len(peaksY)):
			indloc = np.where(locsD<locsY[x])[0]

			if len(indloc) == 0:
				firstpeak = np.max(D);
			else:
				firstpeak = peaksD[indloc[-1]]

			indloc = np.where(locsD>locsY[x])[0]
			if len(indloc) == 0:
				secondpeak = np.max(D)
			else:
				secondpeak = peaksD[indloc[0]]

			if firstpeak<secondpeak:
				if (D[locsY[x]]-np.min(D))>(0.6*(firstpeak-np.min(D))):
					indx.append(x)
			else:
				if (D[locsY[x]]-np.min(D))>(0.6*(secondpeak-np.min(D))):
					indx.append(x)

		peaksY = np.delete(peaksY, indx)

		if len(peaksY) == 0:
			puntos = D>np.mean(D)
			dpuntos = np.diff(puntos, axis=0)
		else:
			thres = []
			indices = np.where((peaksY>np.mean(peaksY)))[0]
			peaksY = np.delete(peaksY, indices)
			peaksY.sort()
			num_peaks = len(peaksY)

			for r in range(0,num_peaks):
				thres.append(Y<peaksY[r])

			thres = np.array(thres)
			for r in range(1,thres.shape[0]):
				dthres = np.diff(thres[r,:], axis=0)
				bandthres = np.where(abs(dthres))[0]

				if dthres[bandthres[0]] == -1: #Si la primera derivada es -1, agregue el cero al indice
					bandthres = np.concatenate(([1],bandthres))

				if dthres[bandthres[-1]] == 1: #Si la ultima derivada es 1, agregue el último numero de la banda
					bandthres = np.concatenate((bandthres, [len(D)]))        

				for g in range(0,np.int(np.array(bandthres).shape[0]/2)):
					if sum((thres[r,bandthres[2*g]:bandthres[2*g+1]]) & (thres[r-1,bandthres[2*g]:bandthres[2*g+1]]))>0: #Hay puntos de la banda superior
						thres[r,bandthres[2*g]:bandthres[2*g+1]] = thres[r-1,bandthres[2*g]:bandthres[2*g+1]] #Prima la banda superior
			
			puntos = np.matrix(thres[-1,:]).T
			dpuntos = np.diff(puntos, axis=0)
				
		indband = np.where(np.abs(dpuntos))[0] #Hace las veces de find()
		if dpuntos[indband[0]] == -1:#Si la primera derivada es -1, agregue el cero al indice
			indband = np.concatenate(([1],indband))

		if dpuntos[indband[-1]] == 1: #Si la ultima derivada es 1, agregue el último numero de la banda
			indband = np.concatenate((indband, [len(D)]))   

		ind = []
		for h in range(0,np.int(np.size(indband,axis=0)/2)):
			if indband[2*h] == indband[2*h+1]:
				ind.append(2*h)
				ind.append(2*h+1)

		indband = np.delete(indband, ind)

		for g in range(0,np.int(np.size(indband,axis=0)/2)):
			fband = mfband[indband[2*g]:indband[2*g+1],:]
			D = np.sum(fband, axis=0)
			L = 40 ##Filtro de media movil
			coefs = np.ones(L)/float(L)
			D = np.convolve(D, coefs, mode='same')
			D = np.convolve(D, coefs, mode='same')
			Y = -D+np.max(D)

			locsY = signal.find_peaks_cwt(Y,np.arange(1,20))
			peaksY = Y[locsY]
			locsD = signal.find_peaks_cwt(D,np.arange(1,20))
			peaksD = Y[locsD]

			if len(peaksY) == 0:
				puntos = D>np.mean(D)
				dpuntos = np.diff(puntos, axis=0)
			else:
				thres = []
				peaksY = np.delete(peaksY, np.where(peaksY>np.mean(peaksY))[0])
				peaksY.sort()
				num_peaks = 5
				if len(peaksY)<num_peaks:
					num_peaks = len(peaksY)

				for r in range(0,num_peaks):
					thres.append(Y<peaksY[r])
				
				thres = np.array(thres)
				for r in range(1,thres.shape[0]):
					dthres = np.diff(thres[r,:])
					bandthres = np.where(np.abs(dthres))[0]

					if dthres[bandthres[0]] == -1:
						bandthres = np.concatenate(([1],bandthres))

					if dthres[bandthres[-1]] == 1:
						bandthres = np.concatenate((bandthres,[len(D)]))

					for x in range(0,np.int(np.size(bandthres,axis=0)/2)):
						if sum(thres[r,bandthres[2*x]:bandthres[2*x+1]]&thres[r-1,bandthres[2*x]:bandthres[2*x+1]])>0:
							thres[r,bandthres[2*x]:bandthres[2*x+1]] = thres[r-1,bandthres[2*x]:bandthres[2*x+1]]

				puntos = np.matrix(thres[-1]).T
				dpuntos = np.diff(puntos, axis=0)

			vindband = np.where(np.abs(dpuntos))[0]

			if dpuntos[vindband[0]] == -1:
				vindband = np.concatenate(([1],vindband))

			if dpuntos[vindband[-1]] == 1:
				vindband = np.concatenate((vindband,[len(D)]))

			ind = []
			for h in range(0,np.int(np.array(vindband).shape[0]/2)):
				if vindband[2*h] == vindband[2*h+1]:
					ind.append(2*h)
					ind.append(2*h+1)
			
			vindband = np.delete(vindband, ind)

			for w in range(0,np.int(np.array(vindband).shape[0]/2)):
				pini = np.int(np.round(vindband[2*w]))
				pend = np.int(np.round(vindband[2*w+1]))
				mini = np.int(np.round(band_1*u)+indband[2*g])/u
				maxi = np.int(np.round(band_1*u)+indband[2*g+1])/u

				seg = selband[indband[2*g]:indband[2*g+1],pini:pend]

				if en == 1:
					ax1.add_patch(
					   patches.Rectangle(
						   (pini*((resiz)/fs), mini*(fs/2)),   # (x,y)
						   (pend*((resiz)/fs)-pini*((resiz)/fs)),         # width
						   (maxi*(fs/2)-mini*(fs/2)),          # height
						   fill = False
					   )
					)
				
				if en == 0:
					nfrec = 10
					div = 10
					nfiltros = 30

					features = fcc5.fcc5(seg,nfiltros,nfrec,div) #50 caracteristicas FCC

					if len(features) != 0:
						featuresAudio.append(features)

	return featuresAudio