from scipy import signal
from scipy.io.wavfile import read
import matplotlib.pyplot as plt
import numpy as np


class SpectrogramUtils:
    def get_spectrogram(self, x, fs):
        f, t, Sxx = signal.spectrogram(
            x, fs, window=signal.get_window('hann', 1280), nfft=2048, noverlap=960)
        return f, t, Sxx

    def get_spectrogram_hd(self, x, fs):
        f, t, Sxx = signal.spectrogram(
            x, fs, window=signal.get_window('hann', 512), nfft=4096, noverlap=256)
        return f, t, Sxx

    def get_spectrogram_image(self, directory, filename, channel):
        fs, x = read(directory + '/' + filename)
        f, t, Sxx = self.get_spectrogram_hd(x[:, channel - 1], fs)
        plt.pcolormesh(t, f, Sxx ** (1/8), cmap='gray')
        plt.ylabel('Frequency [Hz]')
        plt.xlabel('Time [sec]')
        plt.savefig('temp/' + filename + '.png', format='png', dpi=1000)
        return 'temp/' + filename + '.png'

    def get_segments(self, directory, filename, channel):
        fs, x = read(directory + '/' + filename)
        f, t, Sxx = self.get_spectrogram(x[:, channel - 1], fs)
        bands = self.get_bands(Sxx, f)
        segments_interval = self.get_bands_segments(bands, Sxx, t, f)
        return segments_interval

    def get_bands(self, s, f):
        bands_projection = np.std(s, axis=1)
        pos_projection = signal.medfilt(bands_projection, 5)
        neg_projection = - pos_projection + np.max(pos_projection)
        pos_peaks_indices = signal.find_peaks(bands_projection)[0]
        neg_peaks_indices = signal.find_peaks(neg_projection)[0]
        relevant_peaks = self.get_relevant_peaks(
            pos_projection, neg_projection, pos_peaks_indices, neg_peaks_indices, 0.8)

        band_intervals = self.get_intervals(relevant_peaks, neg_projection)
        band_intervals = self.filter_narrow_bands(band_intervals, f)
        # Reshape to have in each row a band interval values
        return np.reshape(band_intervals, (int(len(band_intervals)/2), 2))

    def get_relevant_peaks(self, pos_projection, neg_projection, pos_peaks, neg_peaks, threshold):
        relevant_ind_peaks = []
        for i in range(len(neg_peaks)):
            # Find all positive peaks before the actual negative peak
            indices = np.where(pos_peaks < neg_peaks[i])[0]

            # Default: If there are no peaks, maximum before negative peak
            first_peak = np.max(pos_projection[:neg_peaks[i]])
            if len(indices) > 0:
                # If there are positives peaks, get its value
                first_peak = pos_projection[pos_peaks[indices[-1]]]

            # Find all positive peaks before the actual negative peak
            indices = np.where(pos_peaks > neg_peaks[i])[0]

            # If there are no peaks, maximum after negative peak
            second_peak = np.max(pos_projection[neg_peaks[i]:])
            if len(indices) > 0:
                # If there are positives peaks, get its value
                second_peak = pos_projection[pos_peaks[indices[0]]]

            value_peak = pos_projection[neg_peaks[i]]

            if first_peak > second_peak:
                if value_peak - np.min(pos_projection) < threshold*(first_peak-np.min(pos_projection)):
                    relevant_ind_peaks.append(neg_peaks[i])
            else:
                if value_peak-np.min(pos_projection) < threshold*(second_peak-np.min(pos_projection)):
                    relevant_ind_peaks.append(neg_peaks[i])

        relevant_ind_peaks = np.array(relevant_ind_peaks)
        if len(relevant_ind_peaks) > 0:
            sorting = np.argsort(neg_projection[relevant_ind_peaks])
            return relevant_ind_peaks[sorting]
        else:
            return np.array([])

    def get_intervals(self, peaks, neg_projection):
        threshold_list = []
        for i in range(len(peaks)):
            # Threshold are added in order of priority, first threholds are more important
            threshold_list.append(
                (neg_projection < neg_projection[peaks[i]]).astype(int))

        for i in range(1, len(threshold_list)):
            # Threshold are added in order of priority, first threholds are more important
            derivative_threshold = np.diff(threshold_list[i])

            thresholds_indices = np.where(np.abs(derivative_threshold))[0]

            # If the first derivative is -1, the interval already began
            if derivative_threshold[thresholds_indices[0]] == -1:
                thresholds_indices = np.insert(thresholds_indices, 0, 0)

            # If the last derivative is 1, the interval already began
            if derivative_threshold[thresholds_indices[-1]] == 1:
                thresholds_indices = np.append(
                    thresholds_indices, len(neg_projection))

            for j in range(int(len(thresholds_indices)/2)):  # For each pair of indices
                previous = i - 1
                previous_threshold_ranges = threshold_list[previous][thresholds_indices[2*j]
                    :thresholds_indices[2*j+1]]
                current_threshold_ranges = threshold_list[i][thresholds_indices[2*j]
                    :thresholds_indices[2*j+1]]

                if np.sum(np.logical_and(current_threshold_ranges, previous_threshold_ranges)):
                    threshold_list[i][thresholds_indices[2*j]
                        :thresholds_indices[2*j+1]] = previous_threshold_ranges

        derivative_threshold = np.diff(threshold_list[-1])
        thresholds_indices = np.where(np.abs(derivative_threshold))[0]
        return thresholds_indices

    def filter_narrow_bands(self, band_intervals, f):
        step_width = np.max(f)/len(f)

        minimum_width_hertz = 200
        indices_to_remove = []

        for j in range(int(len(band_intervals)/2)):
            if (band_intervals[2*j + 1] - band_intervals[2*j])*step_width < minimum_width_hertz:
                indices_to_remove.append(2*j + 1)
                indices_to_remove.append(2*j)

        return np.delete(band_intervals, indices_to_remove)

    def get_bands_segments(self, bands, s, t, f):
        total_segments = np.empty((0, 4))
        for i in range(bands.shape[0]):
            time_intervals = self.get_time_intervals(
                s[bands[i][0]: bands[i][1], :])

            band_interval = np.tile(bands[0], (time_intervals.shape[0], 1))
            segments = np.hstack((band_interval, time_intervals))
            total_segments = np.vstack((total_segments, segments))
        return total_segments

    def get_time_intervals(self, s):
        time_projection = np.sum(s, axis=0)
        pos_projection = signal.medfilt(time_projection, 21)
        neg_projection = - pos_projection + np.max(pos_projection)
        pos_peaks_indices = signal.find_peaks(time_projection)[0]
        neg_peaks_indices = signal.find_peaks(neg_projection)[0]
        relevant_peaks = self.get_relevant_peaks(
            pos_projection, neg_projection, pos_peaks_indices, neg_peaks_indices, 0.2)

        if len(relevant_peaks) > 0:
            time_intervals = self.get_intervals(relevant_peaks, neg_projection)
            return np.reshape(time_intervals, (int(len(time_intervals)/2), 2))
        else:
            return np.empty((0, 2))


spectrogram_utils = SpectrogramUtils()
segments = spectrogram_utils.get_segments(
    '/Users/williamgomez/Downloads/Colostethus fraterdanieli/Entrenamiento/', 'JAGUAS260_20121120_064500.wav', 1)

print(segments)
