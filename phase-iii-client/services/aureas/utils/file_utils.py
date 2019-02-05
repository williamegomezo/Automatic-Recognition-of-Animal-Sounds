
import os
import numpy as np
from shutil import copyfile
from .feature_extraction_utils import FeatureExtractionUtils
from .spectrogram_utils import SpectrogramUtils
from .dir_utils import DirUtils

dir_utils = DirUtils()


class FileUtils:

    def process_files(self, directory, files):
        spectrogram_utils = SpectrogramUtils()
        feature_utils = FeatureExtractionUtils()

        total_features = np.array([])
        total_segs = np.array([])
        total_metadata = np.array([])
        for i, file in enumerate(files):
            segment_intervals, segs, f, t, s, metadata = spectrogram_utils.extract_complete_data(
                directory, file, 1)

            nc = 10
            nframes = 10
            nfilters = 30

            features, features_removed = feature_utils.extract_features(
                segs, nfilters, nc, nframes)
            segs = np.delete(np.array(segs), features_removed)[:, None]
            metadata = np.delete(np.array(metadata), features_removed, axis=0)
            metadata = np.around(metadata, 2)
            titles = np.tile(np.array([file]), (metadata.shape[0], 1))
            dirs = np.tile(np.array([directory]), (metadata.shape[0], 1))
            metadata = np.hstack((titles, metadata, dirs))

            if i == 0:
                total_features = total_features.reshape((0, features.shape[1]))
                total_segs = total_segs.reshape((0, segs.shape[1]))
                total_metadata = total_metadata.reshape((0, metadata.shape[1]))

            total_features = np.vstack((total_features, features))
            total_segs = np.vstack((total_segs, segs))
            total_metadata = np.vstack((total_metadata, metadata))

        return total_features, total_segs, total_metadata

    def save_representative_call(self, name, data, metadata):
        mean_calls = np.mean(data, axis=0)[None, :]
        distances = np.linalg.norm(data - mean_calls, axis=1)
        index_representative = np.argmin(distances)
        meta_representative = metadata[index_representative]
        spectrogram_utils = SpectrogramUtils()

        audio_path = self.save_audio(
            meta_representative[-1], 'clusters/audios/', meta_representative[0], name)
        return audio_path, spectrogram_utils.get_segment_in_image(meta_representative[-1],
                                                                  meta_representative[0], 1, float(
            meta_representative[1]),
            float(meta_representative[2]), float(
            meta_representative[4]),
            float(meta_representative[5]), 'clusters/images/', name)

    def save_audio(self, origin_dir, destination_dir, origin_filename, destination_filename):
        dir_utils.create_dir(destination_dir)
        extension = origin_filename.split('.')[1]
        copyfile(origin_dir + '/' + origin_filename,
                 destination_dir + destination_filename + '.' + extension)
        return os.path.abspath(destination_dir + destination_filename + '.' + extension)

    def get_representative_calls(self, recon, data, metadata):
        unique_clusters = np.unique(recon)
        index_representative = np.zeros((unique_clusters.shape), dtype=int)
        representive_calls = list()

        for i, cluster in enumerate(unique_clusters):
            indices = np.where(recon == cluster)[0]
            calls = data[indices]
            mean_calls = np.mean(calls, axis=0)[None, :]
            distances = np.linalg.norm(calls - mean_calls, axis=1)
            index_representative[i] = np.argmin(distances)
            meta_representative = metadata[indices[index_representative[i]]]
            representive_calls.append([str(i), str(len(indices)), *(meta_representative[4:7].tolist()),
                                       str(np.around(np.mean(metadata[indices, 3].astype(
                                           float)), 2)), meta_representative[0],
                                       meta_representative[2], meta_representative[3]])
        return representive_calls
