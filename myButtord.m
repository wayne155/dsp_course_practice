function [order,wn] = myButtord(wp,ws,rp,rs,opt)
% 巴特沃兹滤波器阶数与截频选择函数
% 仿照官方buttord实现， 默认设计数字滤波
%   [N, Wn] = BUTTORD(Wp, Ws, Rp, Rs) 返回满足条件的最低的阶数
%   wp : 通带截止频率， 低高通1x1 带通带阻为1x2
%   ws : 阻带截止频率， 低高通1x1 带通带阻为1x2
%   rp : 通带最大衰减
%   rs : 阻带最大衰减
%   opt: 默认为 'z', 设计数字滤波， 指定为's'时设计模拟滤波

% 默认设计数字滤波器(opt='z'), 若指定's' ， 则设计模拟滤波器
if nargin == 4
    opt = 'z';
elseif nargin == 5
    if ~strcmp(opt,'z') && ~strcmp(opt,'s')
        error(message('signal:buttord:InvalidParam'));
    end
end

% 根据wp, ws 参数选择滤波器类型
ftype = 2*(length(wp) - 1);
if wp(1) < ws(1)
    ftype = ftype + 1;	% 低通 (1) or 带阻(3)
else
    ftype = ftype + 2;	% 高通(2) or 带通 (4)
end

% 第一步: 完成滤波器指标(Π归一化)向模拟指标的转化
if strcmp(opt,'z')	% digital
    WP=tan(pi*wp/2);
    WS=tan(pi*ws/2);
else  % 如果指定模拟则不用做别的
    WP=wp;
    WS=ws;
end


% 第二步: 根据滤波器类型，利用频率转化，完成从低通到各种类型滤波器的转变   
if ftype == 1	% low
    WA=WS/WP;
elseif ftype == 2	% high
    WA=WP/WS;
elseif ftype == 3	% stop
    fo = optimset('display','none');
    %wp1 = lclfminbnd('bscost',WP(1),WS(1)-1e-12,fo,1,WP,WS,rs,rp,'butter');
    %WP(1) = wp1;
    %wp2 = lclfminbnd('bscost',WS(2)+1e-12,WP(2),fo,2,WP,WS,rs,rp,'butter');
    %WP(2) = wp2;
    WA=(WS*(WP(1)-WP(2)))./(WS.^2 - WP(1)*WP(2));
elseif ftype == 4	% pass
    WA=(WS.^2 - WP(1)*WP(2))./(WS*(WP(1)-WP(2)));
end



% 第三步（开始设计）: 根据求N的式子与要求，求得满足要求的最低的巴特沃兹滤波器的阶数
% 这里的WA即为Omega_p / Omega_s
WA=min(abs(WA));
order = ceil( log10( (10 .^ (0.1*abs(rs)) - 1)./ ...
    (10 .^ (0.1*abs(rp)) - 1) ) / (2*log10(WA)) );

% 第四步: 计算3dB截止频率
% to give exactly rs dB at WA.  W0 will be between 1 and WA:
W0 = WA / ( (10^(.1*abs(rs)) - 1)^(1/(2*(abs(order)))));

% 第五步: 将截止频率从低通转化回对应的模拟滤波器类型
if ftype == 1	% low
    WN=W0*WP;
elseif ftype == 2	% high
    WN=WP/W0;
elseif ftype == 3	% stop
    WN(1) = ( (WP(2)-WP(1)) + sqrt((WP(2)-WP(1))^2 + ...
        4*W0.^2*WP(1)*WP(2)))./(2*W0);
    WN(2) = ( (WP(2)-WP(1)) - sqrt((WP(2)-WP(1))^2 + ...
        4*W0.^2*WP(1)*WP(2)))./(2*W0);
    WN=sort(abs(WN));
elseif ftype == 4	% pass
    W0=[-W0 W0];  % 左右的3dB截频
    WN= -W0*(WP(2)-WP(1))/2 + sqrt( W0.^2/4*(WP(2)-WP(1))^2 + WP(1)*WP(2) );
    WN=sort(abs(WN));
end

% 最后， 将模拟频率转化回数字频率
if strcmp(opt,'z')	% digital
    wn=(2/pi)*atan(WN);  % 双线性变换
else
    wn=WN;
end
end

