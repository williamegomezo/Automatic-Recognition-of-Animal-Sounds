from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
    path('get-clusters', views.get_clusters, name='index'),
]
