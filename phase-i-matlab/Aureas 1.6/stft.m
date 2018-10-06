function [stft,t, f] = stft(x, wlen, fs, wn, n)

if size(x, 2) > 1
    x = x';
end

% length of the signal
xlen = length(x);

% form a periodic hamming window
if wn=='hanning'
    win = hann(wlen);
elseif wn=='hamming'
    win = hamming(wlen);
end

% form the stft matrix
step = 1:wlen:xlen-wlen;

rown = ceil(n/2);            % calculate the total number of rows
coln = length(step);        % calculate the total number of columns
stft = zeros(rown, coln);           % form the stft matrix
col = 1;


for stepf=step
    xw = double(x(stepf:stepf+wlen-1)).*win;
    X = fft(xw,n);
    stft(:, col) = X(1:rown);
    col = col + 1;
end


bins = 0:rown-1;
f = bins*fs/n;
t = linspace(0,length(x)/fs,size(stft,2));
