import numpy as np

def stft(x, wlen, fs, wn, n):

	xlen = len(x)

	if wn == 'hanning':
		win = np.hann(wlen)
	elif wn == 'hamming':
	    win = np.hamming(wlen)

	step = np.arange(0, xlen-wlen, wlen)
	rown = int(np.ceil(n/2))
	coln = len(step)
	stft = np.zeros((rown, coln), dtype=complex)
	col = 0

	for stepf in step:
		xw = np.double(x[stepf:stepf+wlen])*win
		X = np.fft.fft(xw, n)
		stft[:, col] = X[0:rown]
		col = col + 1

	bins = np.arange(0, rown, 1)
	f = bins*fs/n
	t = np.linspace(0, xlen/fs, stft.shape[1])

	return (stft, t, f) 