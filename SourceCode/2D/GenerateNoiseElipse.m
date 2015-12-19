function [yNoisy] = GenerateNoiseElipse(a, b, samples, snr)
    y = GenerateElipse(a, b, samples);
    yNoisy = awgn(y, snr, 'measured');
end