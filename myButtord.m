function [order,wn] = myButtord(wp,ws,rp,rs,opt)
% ���������˲����������Ƶѡ����
% ���չٷ�buttordʵ�֣� Ĭ����������˲�
%   [N, Wn] = BUTTORD(Wp, Ws, Rp, Rs) ����������������͵Ľ���
%   wp : ͨ����ֹƵ�ʣ� �͸�ͨ1x1 ��ͨ����Ϊ1x2
%   ws : �����ֹƵ�ʣ� �͸�ͨ1x1 ��ͨ����Ϊ1x2
%   rp : ͨ�����˥��
%   rs : ������˥��
%   opt: Ĭ��Ϊ 'z', ��������˲��� ָ��Ϊ's'ʱ���ģ���˲�

% Ĭ����������˲���(opt='z'), ��ָ��'s' �� �����ģ���˲���
if nargin == 4
    opt = 'z';
elseif nargin == 5
    if ~strcmp(opt,'z') && ~strcmp(opt,'s')
        error(message('signal:buttord:InvalidParam'));
    end
end

% ����wp, ws ����ѡ���˲�������
ftype = 2*(length(wp) - 1);
if wp(1) < ws(1)
    ftype = ftype + 1;	% ��ͨ (1) or ����(3)
else
    ftype = ftype + 2;	% ��ͨ(2) or ��ͨ (4)
end

% ��һ��: ����˲���ָ��(����һ��)��ģ��ָ���ת��
if strcmp(opt,'z')	% digital
    WP=tan(pi*wp/2);
    WS=tan(pi*ws/2);
else  % ���ָ��ģ�����������
    WP=wp;
    WS=ws;
end


% �ڶ���: �����˲������ͣ�����Ƶ��ת������ɴӵ�ͨ�����������˲�����ת��   
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



% ����������ʼ��ƣ�: ������N��ʽ����Ҫ���������Ҫ�����͵İ��������˲����Ľ���
% �����WA��ΪOmega_p / Omega_s
WA=min(abs(WA));
order = ceil( log10( (10 .^ (0.1*abs(rs)) - 1)./ ...
    (10 .^ (0.1*abs(rp)) - 1) ) / (2*log10(WA)) );

% ���Ĳ�: ����3dB��ֹƵ��
% to give exactly rs dB at WA.  W0 will be between 1 and WA:
W0 = WA / ( (10^(.1*abs(rs)) - 1)^(1/(2*(abs(order)))));

% ���岽: ����ֹƵ�ʴӵ�ͨת���ض�Ӧ��ģ���˲�������
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
    W0=[-W0 W0];  % ���ҵ�3dB��Ƶ
    WN= -W0*(WP(2)-WP(1))/2 + sqrt( W0.^2/4*(WP(2)-WP(1))^2 + WP(1)*WP(2) );
    WN=sort(abs(WN));
end

% ��� ��ģ��Ƶ��ת��������Ƶ��
if strcmp(opt,'z')	% digital
    wn=(2/pi)*atan(WN);  % ˫���Ա任
else
    wn=WN;
end
end

