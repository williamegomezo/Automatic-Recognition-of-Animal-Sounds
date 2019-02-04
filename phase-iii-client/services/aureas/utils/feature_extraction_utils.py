import numpy as np


class FeatureExtractionUtils:
    def extract_features(self, segs, nfilters, nc, nframes):
        features = []
        features_removed = []
        for i, seg in enumerate(segs):
            values = self.fcc(seg, nfilters, nc, nframes)
            if len(values) == 0:
                features_removed.append(i)
            else:
                features.append(values)

        return np.array(features)[:, 0, :], np.array(features_removed)

    def fcc(self, seg, nfiltros, nc, nframes):
        [length_freq, length_time] = np.shape(seg)
        w = np.int(np.floor(length_time/nframes))

        if (w != 0) & (length_freq >= nfiltros):
            B = np.zeros((length_freq, 1))

            for k in np.arange(0, w*nframes, w):
                B = np.concatenate(
                    (B, np.sum(np.abs(seg[:, k:k+w])**2, axis=1)[:, None]), axis=1)

            B = B[:, 1:]

            H = np.zeros((nfiltros, length_freq))
            if length_freq >= nfiltros:
                wf = np.int(np.floor(length_freq/nfiltros))
                i = 0
                for k in np.arange(0, wf*nfiltros, wf):
                    H[i, :] = self.gaussfm(
                        np.arange(1, length_freq+1), wf/4, k+wf)
                    i += 1

            FBE = np.dot(H, B)
            N = nc
            M = nfiltros
            DCT = np.sqrt(2.0/M)*np.cos(np.array(np.tile(np.matrix(np.arange(0, N)).T, (1, M)))
                                        * np.array(np.tile(np.pi*(np.arange(1, M+1)-0.5)/M, (N, 1))))
            fcc_feat = np.dot(DCT, np.log(FBE))

            dfcc = np.diff(fcc_feat, n=1, axis=1)
            dfcc2 = np.diff(fcc_feat, n=2, axis=1)
            features = np.hstack((np.reshape(fcc_feat, (1, fcc_feat.shape[0]*fcc_feat.shape[1])),
                                  np.mean(dfcc, axis=1)[None, :],
                                  np.mean(dfcc2, axis=1)[None, :]))
        else:
            features = []
        return features

    def gaussfm(self, x, sig, c):
        return np.exp((-(x-c)**2)/(2*(sig**2)))
