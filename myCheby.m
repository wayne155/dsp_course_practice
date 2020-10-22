function [order,wn] = myCheby(wp,ws,rp,rs,opt)
%CHEB1ORD Chebyshev Type I filter order selection.
%   [N, Wp] = CHEB1ORD(Wp, Ws, Rp, Rs) returns the order N of the lowest
%   order digital Chebyshev Type I filter which has a passband ripple of no
%   more than Rp dB and a stopband attenuation of at least Rs dB. Wp and Ws
%   are the passband and stopband edge frequencies, normalized from 0 to 1
%   (where 1 corresponds to pi radians/sample). For example,
%       Lowpass:    Wp = .1,      Ws = .2
%       Highpass:   Wp = .2,      Ws = .1
%       Bandpass:   Wp = [.2 .7], Ws = [.1 .8]
%       Bandstop:   Wp = [.1 .8], Ws = [.2 .7]


% Cast to enforce precision rules
wp = signal.internal.sigcasttofloat(wp,'double','cheb1ord','Wp',...
  'allownumeric');
ws = signal.internal.sigcasttofloat(ws,'double','cheb1ord','Ws',...
  'allownumeric');
rp = signal.internal.sigcasttofloat(rp,'double','cheb1ord','Rp',...
  'allownumeric');
rs = signal.internal.sigcasttofloat(rs,'double','cheb1ord','Rs',...
  'allownumeric');

if nargin == 4
    opt = 'z';
elseif nargin == 5
    if ~strcmp(opt,'z') && ~strcmp(opt,'s')
        error(message('signal:cheb1ord:InvalidParam'));
    end
end



ftype = 2*(length(wp) - 1);
if wp(1) < ws(1)
    ftype = ftype + 1;	% low (1) or reject (3)
else
    ftype = ftype + 2;	% high (2) or pass (4)
end

if strcmp(opt,'z')	% digital
    WPA=tan(pi*wp/2);
    WSA=tan(pi*ws/2);
else 
    WPA=wp;
    WSA=ws;
end

% 第二步: 根据滤波器类型，利用频率转化，完成从低通到各种类型滤波器的转变
if ftype == 1	% low
    WA=WSA/WPA;
elseif ftype == 2	% high
    WA=WPA/WSA;
elseif ftype == 3	% stop
    fo = optimset('display','none');
    %wp1 = lclfminbnd('bscost',WPA(1),WSA(1)-1e-12,fo,1,...
        %WPA,WSA,rs,rp,'cheby');
   
    %WPA(1) = wp1;
    
    %wp2 = lclfminbnd('bscost',WSA(2)+1e-12,WPA(2),fo,2,...
        %WPA,WSA,rs,rp,'cheby');
   % WPA(2) = wp2;
    WA=(WSA*(WPA(1)-WPA(2)))./(WSA.^2 - WPA(1)*WPA(2));
elseif ftype == 4	% pass
    WA=(WSA.^2 - WPA(1)*WPA(2))./(WSA*(WPA(1)-WPA(2)));
end


% 第三步（开始设计）: 根据求N的式子与要求，求得满足要求的最低的巴特沃兹滤波器的阶数
% 这里的WA即为Omega_p / Omega_s
WA=min(abs(WA));
order=ceil(acosh(sqrt((10^(.1*abs(rs))-1)/(10^(.1*abs(rp))-1)))/acosh(WA));



% 最后， 将模拟频率转化回数字频率
if strcmp(opt,'z')	% digital
    wn = wp;
else
    wn = WPA;
end
