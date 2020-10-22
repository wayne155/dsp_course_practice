function X = overlapSave(x,h,L,puaseTime)
%  快速卷积重叠保留法
%  x: 输入信号
%  h: 冲积行向量
%  L: 卷积块大小 不能比x长度还大, 否则自动变为他的长度

if nargin<4
    puaseTime = 1;
end

close All
clear All
clc

% 确保x, y是行向量
if ~isrow(x) 
    x = x';
end
if ~isrow(h)
    h = h';
end
% 计算元素个数， 确保小于L
[r,c] = size(x);
nx = r*c;
if L > nx
    L = nx;
end

N1=length(x);
M=length(h);

% 序列补齐0便于分割
x=[x zeros(1,mod(-N1,L)) zeros(1,L)];
N2=length(x);
h=[h zeros(1,L-1)];

% 计算H(w)
H=fft(h,L+M-1);

% 共有S块
S=N2/L;  
index=1:L;
xm=x(index);		% 第一次迭代
x1=[zeros(1,M-1) xm];	% 开始位置补零
X=[];
figure()
title("卷积动态展示");
for stage=1:S
    % ifft
    X1=fft(x1,L+M-1); 
    Y=X1.*H;
    Y=ifft(Y);

    % 当前计算的Y
    subplot(2,1,1)
    hold off;
    stem(Y);    
    xlabel(['第',num2str(stage),'块ifft结果']);
    
    
    % 绘制当前X状态
    subplot(2,1,2)
    hold off;
    stem(X);
    xlabel(['前',num2str(stage),'块ifft叠加结果']);
    
    % 忽略前面的序列
    index2=M:M+L-1;
    Y=Y(index2);		
    
    X=[X Y]; % 保存结果
    index3=(((stage)*L)-M+2):((stage+1)*L);		% 继续选择信号进行处理
    if(index3(L+M-1)<=N2)
        x1=x(index3);
    end
   pause(puaseTime); 
end
i=1:N1+M-1;
X=X(i);


end

