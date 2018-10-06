from django.http import HttpResponse
from django.shortcuts import render
from .forms import SignalForm
import io
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas

import matplotlib.pyplot as plt
import numpy as np

signal = ''


def index(request):

	val = 0

	if request.method == 'POST':
		form = SignalForm(request.POST)
		if form.is_valid():
			form = SignalForm(request.POST)
			signal = form['signal'].value()
			val = 1
	else:
		form = SignalForm()
	
	return render(request, 'grafica.html', {'x': form, 'val': val})

'''def GraphsView(request):

	f = plt.figure()
	x = np.linspace(-np.pi, np.pi, 201)
	plt.plot(x, np.sin(x))
	plt.xlabel('Angle [rad]')
	plt.ylabel('sin(x)')
	plt.axis('tight')

	canvas = FigureCanvas(f)    
	response = HttpResponse(content_type='image/png')
	canvas.savefig(response, format='png')
	plt.close(f)   
	return response'''

def GraphsView(request):
	"""
	This is an example script from the Matplotlib website, just to show 
	a working sample >>>
	"""
	x = np.linspace(-np.pi, np.pi, 201)
	plt.plot(x, np.sin(x))
	plt.xlabel('Angle [rad]')
	plt.ylabel('sin(x)')
	plt.axis('tight')
	"""
	Now the redirect into the cStringIO or BytesIO object >>>
	"""
	f = io.BytesIO()           # Python 3
	plt.savefig(f, format="png")
	plt.clf()
	"""
	Add the contents of the StringIO or BytesIO object to the response, matching the
	mime type with the plot format (in this case, PNG) and return >>>
	"""
	return HttpResponse(f.getvalue(), content_type="image/png")