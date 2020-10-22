function X = overlapSave(x,h,L,puaseTime)
%  ���پ���ص�������
%  x: �����ź�
%  h: ���������
%  L: ������С ���ܱ�x���Ȼ���, �����Զ���Ϊ���ĳ���

if nargin<4
    puaseTime = 1;
end

close All
clear All
clc

% ȷ��x, y��������
if ~isrow(x) 
    x = x';
end
if ~isrow(h)
    h = h';
end
% ����Ԫ�ظ����� ȷ��С��L
[r,c] = size(x);
nx = r*c;
if L > nx
    L = nx;
end

N1=length(x);
M=length(h);

% ���в���0���ڷָ�
x=[x zeros(1,mod(-N1,L)) zeros(1,L)];
N2=length(x);
h=[h zeros(1,L-1)];

% ����H(w)
H=fft(h,L+M-1);

% ����S��
S=N2/L;  
index=1:L;
xm=x(index);		% ��һ�ε���
x1=[zeros(1,M-1) xm];	% ��ʼλ�ò���
X=[];
figure()
title("�����̬չʾ");
for stage=1:S
    % ifft
    X1=fft(x1,L+M-1); 
    Y=X1.*H;
    Y=ifft(Y);

    % ��ǰ�����Y
    subplot(2,1,1)
    hold off;
    stem(Y);    
    xlabel(['��',num2str(stage),'��ifft���']);
    
    
    % ���Ƶ�ǰX״̬
    subplot(2,1,2)
    hold off;
    stem(X);
    xlabel(['ǰ',num2str(stage),'��ifft���ӽ��']);
    
    % ����ǰ�������
    index2=M:M+L-1;
    Y=Y(index2);		
    
    X=[X Y]; % ������
    index3=(((stage)*L)-M+2):((stage+1)*L);		% ����ѡ���źŽ��д���
    if(index3(L+M-1)<=N2)
        x1=x(index3);
    end
   pause(puaseTime); 
end
i=1:N1+M-1;
X=X(i);


end

