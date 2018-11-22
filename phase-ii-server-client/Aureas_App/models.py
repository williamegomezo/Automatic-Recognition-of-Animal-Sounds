from django.db import models
import os

class ListModel(models.Model):

	class Meta: 
		ordering = ["-upload"]

	#upload = models.FilePathField(path="Aureas_App/static/", match=".*\.(mp3|wav)$", recursive=True, allow_files=True)
	upload = models.FilePathField(match=".*\.(mp3|wav)$", recursive=True)
