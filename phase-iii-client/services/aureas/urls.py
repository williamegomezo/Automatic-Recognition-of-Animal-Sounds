from django.urls import path

from . import views

urlpatterns = [
    path('get-species', views.get_species, name='index'),
    path('get-clusters', views.get_clusters, name='clusters'),
    path('get-segment-image', views.get_segment_in_image, name='segment-image'),
    path('save-cluster', views.save_cluster, name='save-cluster')
]
