
import numpy as np
from utils.spectrogram_utils import SpectrogramUtils
from utils.feature_extraction_utils import FeatureExtractionUtils
from utils.classification_utils import ClassificationUtils

spectrogram_utils = SpectrogramUtils()
segment_intervals, segs, f, t, s, metadata = spectrogram_utils.extract_complete_data(
    '/Users/williamgomez/Downloads/Colostethus fraterdanieli/Entrenamiento/', 'JAGUAS260_20121120_064500.wav', 1)

feature_utils = FeatureExtractionUtils()
nc = 10
nframes = 10
nfilters = 30

features, features_removed = feature_utils.extract_features(
    segs, nfilters, nc, nframes)
segs = np.delete(np.array(segs), features_removed)
metadata = np.delete(np.array(metadata), features_removed, axis=0)

classification_utils = ClassificationUtils()

ex_level = 1
it_num = 5
data = np.hstack((features, metadata[:, 5][:, None]))
mad = 'binomial'
gad = '3pi'

datanorm, mininums, maximums = classification_utils.norm(data)
recon, mean_class, std_class = classification_utils.lamda(
    ex_level, it_num, datanorm, mad, gad)
