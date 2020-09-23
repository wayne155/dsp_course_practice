% =======================
% 计算序列 DTFT
% =====================
function Xw = dtft(xn, w)
% xn : 采样序列   scalar | vector
% w : 想求的角频率(归一化后)  scalar | vector

% 空间复杂度: xn * w
% Xw= abs(sum(xn'.*exp(-1i*(0:length(xn)-1)'*w*pi))) ;  % N = length(xn);









