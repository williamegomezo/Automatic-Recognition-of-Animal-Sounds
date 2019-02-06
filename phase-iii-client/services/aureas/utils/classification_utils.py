import numpy as np


class ClassificationUtils:
    def lamda(self, ex_level, it_num, data, mad, gad):
        num_datos, num_feat = data.shape
        num_classes = 1
        mean_class = 0.5*np.ones((1, num_feat))
        std_class = 0.25*np.ones((1, num_feat))
        if mad == 'binomial-centrada':
            std_class = 0.5*np.ones((1, num_feat))

        conteo = list()
        conteo.append(0)

        mad_functions = {
            'binomial': lambda x, cmean, cstd: cmean**(np.tile(x, (cmean.shape[0], 1)))*(1-cmean)**(np.tile(1-x, (cmean.shape[0], 1))),
            'binomial-centrada': lambda x, cmean, cstd: cstd**np.abs(np.tile(x, (cmean.shape[0], 1))-cmean)*(1-cstd)**(1-np.abs(np.tile(x, (cmean.shape[0], 1))-cmean)),
            'gauss': lambda x, cmean, cstd: np.exp(-1/2*(np.tile(x, (cmean.shape[0], 1))-cmean)**2/(cstd**2))
        }

        gad_functions = {
            '3pi': lambda x: np.prod(x, axis=1)/(np.prod(x, axis=1)+np.prod(1-x, axis=1)),
            'minmax': lambda x: ex_level*np.min(x, axis=1)+(1-ex_level)*np.max(x, axis=1)
        }

        for _ in range(0, it_num):
            for j in range(0, num_datos):

                mads = mad_functions[mad](data[j, :], mean_class, std_class)
                gads = gad_functions[gad](mads)

                ind_gad = np.argmax(gads)

                if ind_gad == 0:
                    # print('NIC')
                    num_classes += 1
                    conteo.append(1)
                    mean_class = np.concatenate(
                        (mean_class, (mean_class[0, :]+data[j, :])[None, :]/2), axis=0)
                    std_class = np.concatenate((std_class, self.mov_std(
                        mean_class[0, :], (mean_class[0, :]+data[j, :])[None, :]/2, 2, std_class[0, :])), axis=0)

                else:
                    # print('Newclass')
                    conteo[ind_gad] += 1
                    new_mean = mean_class[ind_gad, :] + \
                        (1/conteo[ind_gad])*(data[j, :]-mean_class[ind_gad, :])
                    std_class[ind_gad, :] = self.mov_std(
                        mean_class[ind_gad, :], new_mean, conteo[ind_gad], std_class[ind_gad, :])
                    mean_class[ind_gad, :] = new_mean

        gadso = np.zeros((num_classes-1, num_datos))
        for j in range(0, num_datos):
            mads = mad_functions[mad](
                data[j, :], mean_class[1:, :], std_class[1:, :])
            gadso[:, j] = np.transpose(gad_functions[gad](mads)[None, :])[:, 0]

        recon = np.argmax(gadso, axis=0)
        return recon, mean_class, std_class

    def predict_lamda(self, ex_level, data, mad, gad, mean_class, std_class):
        num_datos, num_feat = data.shape
        num_classes = mean_class.shape[0]

        conteo = list()
        conteo.append(0)

        mad_functions = {
            'binomial': lambda x, cmean, cstd: cmean**(np.tile(x, (cmean.shape[0], 1)))*(1-cmean)**(np.tile(1-x, (cmean.shape[0], 1))),
            'binomial-centrada': lambda x, cmean, cstd: cstd**np.abs(np.tile(x, (cmean.shape[0], 1))-cmean)*(1-cstd)**(1-np.abs(np.tile(x, (cmean.shape[0], 1))-cmean)),
            'gauss': lambda x, cmean, cstd: np.exp(-1/2*(np.tile(x, (cmean.shape[0], 1))-cmean)**2/(cstd**2))
        }

        gad_functions = {
            '3pi': lambda x: np.prod(x, axis=1)/(np.prod(x, axis=1)+np.prod(1-x, axis=1)),
            'minmax': lambda x: ex_level*np.min(x, axis=1)+(1-ex_level)*np.max(x, axis=1)
        }

        gadso = np.zeros((num_classes, num_datos))
        for j in range(0, num_datos):
            mads = mad_functions[mad](
                data[j, :], mean_class[:, :], std_class[:, :])
            gadso[:, j] = np.transpose(gad_functions[gad](mads)[None, :])[:, 0]

        recon = np.argmax(gadso, axis=0)
        return recon

    def mov_std(self, old_mean, new_mean, n, old_std):
        a = (new_mean-old_mean)**2
        b = (old_std**2)/n
        c = (a+b)*(n-1)
        return c**(1/2)

    def norm(self, data, min_values=[], max_values=[]):
        minimums = min_values if len(min_values) != 0 else np.min(data, axis=0)
        maximums = max_values if len(max_values) != 0 else np.max(data, axis=0)
        data_norm = (data - minimums)/(maximums - minimums)

        return data_norm, minimums, maximums
