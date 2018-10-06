from django import forms

class SignalForm(forms.Form):
	
	signal = forms.CharField(label='Signal')
	
