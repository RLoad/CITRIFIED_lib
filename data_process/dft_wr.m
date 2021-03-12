
function [Xk] = dft_wr(xn,N)
% Computes Discrete Fourier Transform
%______________________________________________
% [Xk] = dft(xn,N)
% Xk = DFT coefficients array over 0 <= k <= N - 1
% xn = N-point finite - duration sequence 0 <= n <= N - 1
% N = Length of DFT
n = [0:1:N-1]; % row vector for n
k = [0:1:N-1]; % row vector for k
WN = exp(-j*2*pi/N);
nk = n'*k;
WNnk = WN .^ nk;   %DFT matrix
Xk = xn * WNnk;

