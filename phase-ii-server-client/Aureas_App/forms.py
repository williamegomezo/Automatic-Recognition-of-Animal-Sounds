from django import forms

from . import models

class ListForm(forms.ModelForm):

	class Meta:
		model = models.ListModel
		fields = ['upload']

	def __init__(self, *args, **kwargs):
		super(ListForm, self).__init__(*args, **kwargs)
		
		mypath = "Aureas_App/audios/"
		self.fields['upload'] = forms.FilePathField(path=mypath, match=".*\.(mp3|wav)$", recursive=True)
	

	

