from django.http import HttpResponse
from django.shortcuts import render
from . import models
from . import forms
import io
import os

from sklearn import cluster
from scipy.io.wavfile import read
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
import numpy as np
import base64
import json

from . import stft
from . import SegmentacionPaisaje

path  = "Aureas_App/audios"

def index(request):

	audios_list = os.listdir(path)

	return render(request, 'grafica.html', {'audios': audios_list})

def GraphsView(request):

	audio = request.GET.get('audio', None)
	channel = int(request.GET.get('channel', None))

	fs, x = read(path+"/"+audio)

	wspec = 1024; #tamaño de la ventana, nombre, voc corta o larga, tiempo de computo

	s1, t, f = stft.stft(x[:,(channel-1)], wspec, fs,'hamming', 2**12)

	s1 = 20*np.log10(np.abs(s1)) # amplitude to decibel

	plt.figure(figsize=(10,8))
	plt.pcolormesh(t, f, s1, cmap="jet")
	plt.xlim([min(t),max(t)])
	plt.ylim([min(f),max(f)])

	f = io.BytesIO()
	plt.savefig(f, format="png", transparent = True, bbox_inches = 'tight', pad_inches = 0)
	plt.clf()
	plt.close()

	return HttpResponse(base64.b64encode(f.getvalue()), content_type="image/png")

def GraphsViewSegmentacion(request):

	audio = request.GET.get('audio', None)
	channel = int(request.GET.get('channel', None))

	fs, x = read(path+"/"+audio)

	wspec = 1024+256; #tamaño de la ventana, nombre, voc corta o larga, tiempo de computo

	s, t, f = stft.stft(x[:,(channel-1)], wspec, fs,'hamming', 2**12)
	s = np.abs(s)
	s1 = 20*np.log10(s) # amplitude to decibel

	plt.figure(figsize=(10,8))
	plt.pcolormesh(t, f, s1, cmap="jet")
	plt.xlim([min(t),max(t)])
	plt.ylim([min(f),max(f)])
	ax1 = plt.gca()

	resiz = len(x[:,(channel-1)])/s.shape[1]

	SegmentacionPaisaje.SegmentacionPaisaje(x, resiz, s, fs, ax1, 1)	

	f = io.BytesIO()
	plt.savefig(f, format="png", transparent = True, bbox_inches = 'tight', pad_inches = 0)
	plt.clf()
	plt.close()

	return HttpResponse(base64.b64encode(f.getvalue()), content_type="image/png")

def GraphsViewKmeans(request):

	audio = request.GET.get('audio', None)
	channel = int(request.GET.get('channel', None))

	audiosTrain = os.listdir(path+"/"+audio+"/Entrenamiento")

	wspec = 1024+256; #tamaño de la ventana, nombre, voc corta o larga, tiempo de computo

	seg = []
	for tn in audiosTrain:
		print(tn)
		fs, x = read(path+"/"+audio+"/Entrenamiento/"+tn)
		s, t, f = stft.stft(x[:,(channel-1)], wspec, fs,'hamming', 2**12)
		s = np.abs(s)
		resiz = len(x[:,(channel-1)])/s.shape[1]
		features = SegmentacionPaisaje.SegmentacionPaisaje(x, resiz, s, fs, [], 0)
		if len(features) != 0:
			seg.append(features)

	seg = np.mean(np.concatenate(seg, axis=0), axis=1)
	kmeans = cluster.KMeans(init='k-means++', n_clusters=10)

	X_pca = PCA(n_components=2).fit_transform(seg)
	clusters = kmeans.fit_predict(seg)

	plt.figure(figsize=(10,8))
	plt.scatter(X_pca[:, 0], X_pca[:, 1], c=clusters)

	f = io.BytesIO()
	plt.savefig(f, format="png", transparent = True, bbox_inches = 'tight', pad_inches = 0)
	plt.clf()
	plt.close()

	return HttpResponse(base64.b64encode(f.getvalue()), content_type="image/png")
							
def ChannelAudio(request):

	audio = request.GET.get('audio', None)

	fs, x = read(path+"/"+audio)

	json_channel = json.dumps(x.ndim)

	return HttpResponse(json_channel)


def AjaxConsult(request):

	file = request.GET.get('file', None)
	audios_list = os.listdir(path+"/"+file)
	json_audios= json.dumps(audios_list)
	return HttpResponse(json_audios)