from django.http import HttpResponse
from rest_framework.decorators import api_view
from rest_framework.decorators import parser_classes
from rest_framework.parsers import JSONParser
import numpy as np
import json
import os
from .utils.spectrogram_utils import SpectrogramUtils
from .utils.feature_extraction_utils import FeatureExtractionUtils
from .utils.classification_utils import ClassificationUtils
from .utils.file_utils import FileUtils
from .utils.dir_utils import DirUtils
from .constants.headers import headers_data, headers_clusters, headers_clusters_no_display

file_utils = FileUtils()
dir_utils = DirUtils()


@api_view(['GET'])
@parser_classes((JSONParser,))
def get_species(request):
    species = os.listdir('clusters/model/')
    species_data = []
    for specie in species:
        with open('clusters/model/' + specie, 'r') as infile:
            data = json.load(infile)
            species_data.append(data)
    return HttpResponse(json.dumps(species_data, separators=(',', ':')))


@api_view(['GET', 'POST'])
@parser_classes((JSONParser,))
def get_clusters(request):
    if request.method == 'POST':
        data = request.data
        directory = data['dir']
        files = data['files']
        features, segs, metadata = file_utils.process_files(
            directory, files)

        classification_utils = ClassificationUtils()

        ex_level = 1
        it_num = 5
        data = np.hstack((features, metadata[:, 6].astype(float)[:, None]))
        mad = 'binomial'
        gad = '3pi'

        datanorm, mininums, maximums = classification_utils.norm(data)
        recon, mean_class, std_class = classification_utils.lamda(
            ex_level, it_num, datanorm, mad, gad)

        representive_calls = file_utils.get_representative_calls(
            recon, datanorm, metadata)

        keys_results = [header['label'] for header in headers_data]
        keys_clusters = [header['label'] for header in headers_clusters]
        keys_clusters_no_display = [header['label']
                                    for header in headers_clusters_no_display]

        data_results = []
        for i, value in enumerate(metadata):
            values = [value[0], str(recon[i]), *
                      (value[1:].tolist()), datanorm[i]]
            zipbObj = zip(keys_results, values)
            data_results.append(dict(zipbObj))

        data_clusters = []
        for i, value in enumerate(representive_calls):
            zipbObj = zip(keys_clusters + keys_clusters_no_display, value)
            data_clusters.append(dict(zipbObj))

        response = {
            'results': {
                'headers': headers_data,
                'data': data_results,
                'model': {
                    'features': datanorm.tolist(),
                    'min_values': mininums.tolist(),
                    'max_values': maximums.tolist(),
                    'metadata': metadata.tolist()
                }
            },
            'clusters': {
                'headers': headers_clusters,
                'data': data_clusters
            }
        }

        return HttpResponse(json.dumps(response, separators=(',', ':')))


@api_view(['GET', 'POST'])
@parser_classes((JSONParser,))
def get_segment_in_image(request):
    if request.method == 'POST':
        data = request.data
        spectrogram_utils = SpectrogramUtils()
        filename = spectrogram_utils.get_segment_in_image(data['dir'],
                                                          data['filename'], 1, float(data['start']) - 0.5, float(data['end']) + 0.5, float(data['min_freq']) - 200, float(data['max_freq']) + 200)

        response = {
            'url': filename
        }

        return HttpResponse(json.dumps(response, separators=(',', ':')))


@api_view(['GET', 'POST'])
@parser_classes((JSONParser,))
def save_cluster(request):
    if request.method == 'POST':
        data = request.data

        features = np.array(data['model']['features'])
        min_values = data['model']['min_values']
        max_values = data['model']['max_values']
        metadata = np.array(data['model']['metadata'])

        indices = np.array(data['selected'])

        audio_path, image_path, metadata_representative = file_utils.save_representative_call(
            data['name'], features[indices], metadata[indices])

        model = {
            'name': data['name'],
            'metadata': metadata_representative.tolist(),
            'mean_values': np.mean(features[indices], axis=0).tolist(),
            'std_values': np.std(features[indices], axis=0).tolist(),
            'min_values': min_values,
            'max_values': max_values,
            'image_path': image_path,
            'audio_path': audio_path
        }

        dir_utils.create_dir('clusters/model/')
        with open('clusters/model/' + data['name'], 'w') as outfile:
            json.dump(model, outfile)

        return HttpResponse(json.dumps(model, separators=(',', ':')))


@api_view(['GET', 'POST'])
@parser_classes((JSONParser,))
def search_clusters(request):
    if request.method == 'POST':
        data = request.data
        directory = data['dir']
        files = data['files']
        species = data['species']
        features, segs, metadata = file_utils.process_files(
            directory, files)

        classification_utils = ClassificationUtils()

        ex_level = 1
        it_num = 5
        data = np.hstack((features, metadata[:, 6].astype(float)[:, None]))
        mad = 'binomial'
        gad = '3pi'

        num_datos, num_feat = data.shape
        mean_class = 0.5 * np.ones((1, num_feat))
        std_class = 0.25 * np.ones((1, num_feat))
        min_values = np.empty((0, num_feat))
        max_values = np.empty((0, num_feat))
        for specie in species:
            with open('clusters/model/' + specie, 'r') as infile:
                model = json.load(infile)
                mean_class = np.vstack(
                    (mean_class, np.array(model['mean_values'])))
                std_class = np.vstack(
                    (std_class, np.array(model['std_values'])))
                min_values = np.vstack(
                    (min_values, np.array(model['min_values'])))
                max_values = np.vstack(
                    (max_values, np.array(model['max_values'])))

        general_min_values = np.min(min_values, axis=0)
        general_max_values = np.max(max_values, axis=0)

        datanorm, mininums, maximums = classification_utils.norm(
            data, general_min_values, general_max_values)
        recon = classification_utils.predict_lamda(
            ex_level, datanorm, mad, gad, mean_class, std_class)

        representive_calls = file_utils.get_representative_calls(
            recon, datanorm, metadata)

        keys_results = [header['label'] for header in headers_data]
        keys_clusters = [header['label'] for header in headers_clusters]
        keys_clusters_no_display = [header['label']
                                    for header in headers_clusters_no_display]

        data_results = []
        for i, value in enumerate(metadata):
            species_name = species[recon[i] - 1] if recon[i] > 0 else 'NIC'
            values = [value[0], species_name, *
                      (value[1:].tolist()), datanorm[i]]
            zipbObj = zip(keys_results, values)
            data_results.append(dict(zipbObj))

        data_clusters = []
        for i, value in enumerate(representive_calls):
            value[0] = species[i - 1] if i > 0 else 'NIC'
            zipbObj = zip(keys_clusters + keys_clusters_no_display, value)
            data_clusters.append(dict(zipbObj))

        response = {
            'results': {
                'headers': headers_data,
                'data': data_results,
                'model': {
                    'features': datanorm.tolist(),
                    'min_values': mininums.tolist(),
                    'max_values': maximums.tolist(),
                    'metadata': metadata.tolist()
                }
            },
            'clusters': {
                'headers': headers_clusters,
                'data': data_clusters
            }
        }

        return HttpResponse(json.dumps(response, separators=(',', ':')))
