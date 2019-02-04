from scipy import signal
from scipy.io.wavfile import read
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
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
        plt.savefig('temp/spectrograms' + filename +
                    '.png', format='png', dpi=1000)
        return 'temp/spectrograms/' + filename + '.png'

    def get_segments(self, directory, filename, channel):
        fs, x = read(directory + '/' + filename)
        f, t, Sxx = self.get_spectrogram(x[:, channel - 1], fs)
        bands = self.get_bands(Sxx, f)
        segments_interval = self.get_bands_segments(bands, Sxx, t, f)
        return segments_interval, f, t, Sxx

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

        for i in range(len(threshold_list)):
            # Threshold are added in order of priority, first threholds are more important
            thresholds_indices = self.get_intervals_from_ones(
                threshold_list[i], neg_projection)

            if i == 0:
                for j in range(int(len(thresholds_indices)/2)):  # For each pair of indices
                    threshold_list[i][thresholds_indices[2*j]                                      :thresholds_indices[2*j+1]] = 1
            else:
                for j in range(int(len(thresholds_indices)/2)):  # For each pair of indices
                    previous = i - 1
                    previous_threshold_ranges = threshold_list[previous][
                        thresholds_indices[2*j]:thresholds_indices[2*j+1]]
                    current_threshold_ranges = threshold_list[i][thresholds_indices[2*j]                                                                 :thresholds_indices[2*j+1]]

                    if np.sum(np.logical_and(current_threshold_ranges, previous_threshold_ranges)):
                        threshold_list[i][thresholds_indices[2*j]                                          :thresholds_indices[2*j+1]] = previous_threshold_ranges
        return self.get_intervals_from_ones(
            threshold_list[-1], neg_projection)

    def get_intervals_from_ones(self, indices, projection):
        # Threshold are added in order of priority, first threholds are more important
        derivative_threshold = np.diff(indices)

        thresholds_indices = np.where(np.abs(derivative_threshold))[0]

        # If the first derivative is -1, the interval already began
        if derivative_threshold[thresholds_indices[0]] == -1:
            thresholds_indices = np.insert(thresholds_indices, 0, 0)

        # If the last derivative is 1, the interval already began
        if derivative_threshold[thresholds_indices[-1]] == 1:
            thresholds_indices = np.append(
                thresholds_indices, len(projection))

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

            band_interval = np.tile(bands[i], (time_intervals.shape[0], 1))
            segments = np.hstack((band_interval, time_intervals))
            segments = self.remove_noisy_segments_per_band(segments, s)
            total_segments = np.vstack((total_segments, segments))
        return total_segments

    def remove_noisy_segments_per_band(self, segments, s):
        if len(segments) > 0:
            mean_value = np.mean(s[segments[0, 0]: segments[0, 1], :])
            indices = []
            for i in range(len(segments)):
                seg = s[segments[i, 0]: segments[i, 1],
                        segments[i, 2]: segments[i, 3]]
                if np.mean(seg) < mean_value:
                    indices.append(i)
            segments = np.delete(segments, indices, axis=0)
        return segments

    def get_time_intervals(self, s):
        time_projection = np.sum(s, axis=0)
        pos_projection = signal.medfilt(time_projection, 11)
        neg_projection = - pos_projection + np.max(pos_projection)
        pos_peaks_indices = signal.find_peaks(time_projection)[0]
        neg_peaks_indices = signal.find_peaks(neg_projection)[0]
        relevant_peaks = self.get_relevant_peaks(
            pos_projection, neg_projection, pos_peaks_indices, neg_peaks_indices, 0.1)

        if len(relevant_peaks) > 0:
            time_intervals = self.get_intervals(relevant_peaks, neg_projection)
            return np.reshape(time_intervals, (int(len(time_intervals)/2), 2))
        else:
            return np.empty((0, 2))

    def get_metadata(self, segment_intervals, s, t, f):
        for i in range(len(segment_intervals)):
            segment_intervals[i] = self.increase_segment_size(
                segment_intervals[i], s, threshold=0.8)

        freq = segment_intervals[:, :2]*np.max(f)/len(f)
        time = segment_intervals[:, 2:]*np.max(t)/len(t)
        dom_freq = np.zeros((len(segment_intervals), 1))
        segments = []
        for i in range(len(segment_intervals)):
            seg = s[int(segment_intervals[i, 0]): int(segment_intervals[i, 1]),
                    int(segment_intervals[i, 2]): int(segment_intervals[i, 3])]
            segments.append(seg)
            dom_freq[i] = np.argmax(
                np.sum(seg, axis=1))*np.max(f)/len(f) + freq[i, 0]
        length_call = time[:, 1]-time[:, 0]
        return np.hstack((time, length_call[:, None], freq, dom_freq)), segment_intervals, segments

    def increase_segment_size(self, segment, s, threshold):
        mean_value = np.mean(s[int(segment[0]): int(segment[1]),
                               int(segment[2]): int(segment[3])])

        # Increase downwards
        new_value = int(segment[0]) - 1
        while True:
            if new_value < 0:
                new_value += 1
                break
            seg = s[new_value, int(segment[2]): int(segment[3])]
            if np.max(seg) > threshold * mean_value:
                new_value -= 1
            else:
                if new_value < 0:
                    new_value += 1
                    break
                break
        segment[0] = new_value

        # Increase upwards
        new_value = int(segment[1]) + 1
        while True:
            if new_value > s.shape[0] - 1:
                new_value -= 1
                break
            seg = s[new_value, int(segment[2]): int(segment[3])]
            if np.max(seg) > threshold * mean_value:
                new_value += 1
            else:
                if new_value > s.shape[0] - 1:
                    new_value -= 1
                    break
                break
        segment[1] = new_value

        # Increase to the left
        new_value = int(segment[2]) - 1
        while True:
            if new_value < 0:
                new_value += 1
                break
            seg = s[int(segment[0]): int(segment[1]), new_value]
            if np.max(seg) > threshold * mean_value:
                new_value -= 1
            else:
                if new_value < 0:
                    new_value += 1
                    break
                break
        segment[2] = new_value

        # Increase to the rigth
        new_value = int(segment[3]) + 1
        while True:
            if new_value > s.shape[1] - 1:
                new_value -= 1
                break
            seg = s[int(segment[0]): int(segment[1]), new_value]
            if np.max(seg) > threshold * mean_value:
                new_value += 1
            else:
                if new_value > s.shape[1] - 1:
                    new_value -= 1
                    break
                break
        segment[3] = new_value
        return segment

    def extract_complete_data(self, directory, filename, channel):
        segments, f, t, s = self.get_segments(directory, filename, channel)
        metadata, segment_intervals, segs = self.get_metadata(
            segments, s, t, f)
        return segment_intervals, segs, f, t, s, metadata

    def get_segments_in_image(self, directory, filename, channel):
        segments, f, t, s = self.get_segments(directory, filename, channel)
        metadata, _, _ = self.get_metadata(
            segments, s, t, f)
        plt.pcolormesh(t, f, s**(1/8), cmap='gray')
        plt.ylabel('Frequency [Hz]')
        plt.xlabel('Time [sec]')
        currentAxis = plt.gca()
        for seg in metadata:
            currentAxis.add_patch(
                Rectangle((seg[0], seg[3]), seg[1]-seg[0], seg[4]-seg[3], fill=None, alpha=1))
        plt.savefig('temp/segments_in_image/' + filename +
                    '.png', format='png', dpi=1000)
        return 'temp/' + filename + '.png'
