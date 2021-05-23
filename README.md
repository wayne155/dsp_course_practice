# TODO

- [x] 测试,完善切比雪夫滤波器
- [x] 在mainApp中添加IIR, FIR选择逻辑
- [x] 窗口法设计
  - [x] mainApp打开两个不同窗口
  - [x] IIR DF, 差分方程迭代滤波
  - [x] FIR DF, 快速卷积滤波
- [x] 整体测试\
- [x] 重叠保留法
- [x] 动态展示
  - [x] 点数动态
  - [x] 秒数动态
- [x] GUI完善



**For More information, Please reference to: [this_link](https://github.com/theoYe/dsp_course_practice/blob/dev/%E9%80%9A%E4%BF%A11802%E5%8F%B6%E4%BC%9F%E4%BC%9F-%E6%95%B0%E5%AD%97%E4%BF%A1%E5%8F%B7%E5%A4%84%E7%90%86%E5%AE%9E%E9%AA%8C%E6%8A%A5%E5%91%8A_.pdf)** 



# 1 系统展示

## 1.1 主界面

![](https://i.bmp.ovh/imgs/2021/05/6612eae26f0bf05f.png)





## 1.2 信号处理模块

![](https://i.bmp.ovh/imgs/2021/05/eca9a130c218846c.png)



**For More information, Please reference to: [this_link](https://github.com/theoYe/dsp_course_practice/blob/dev/%E9%80%9A%E4%BF%A11802%E5%8F%B6%E4%BC%9F%E4%BC%9F-%E6%95%B0%E5%AD%97%E4%BF%A1%E5%8F%B7%E5%A4%84%E7%90%86%E5%AE%9E%E9%AA%8C%E6%8A%A5%E5%91%8A_.pdf)** 

# 2 Signal Processing App Architecture



**For More information, Please reference to: [this_link](https://github.com/theoYe/dsp_course_practice/blob/dev/%E9%80%9A%E4%BF%A11802%E5%8F%B6%E4%BC%9F%E4%BC%9F-%E6%95%B0%E5%AD%97%E4%BF%A1%E5%8F%B7%E5%A4%84%E7%90%86%E5%AE%9E%E9%AA%8C%E6%8A%A5%E5%91%8A_.pdf)** 

## 2.1 数字信号系统设计

![](https://i.bmp.ovh/imgs/2021/05/0283b44a7ed82b69.png)

# 3 数字信号处理算法

## 3.1 matlab窗函数法

矩形窗: rectwin

三角窗: bartlett

汉宁窗: hann

汉明窗: hamming

kaise

blackman

## 3.2 conv函数



#### 1. 类型检查



### localAXPY

信号x 从 ix0开始n点， 乘a 倍加到 信号y从y0开始的地方

```matlab

function y = localAXPY(n,a,x,ix0,ignore1,y,iy0,ignore2)
% Simple xAXPY assuming unit strides. y(iy0 + (0:n-1)) = y(iy0 + (0:n-1)) +
% a*x(ix0 + (0:n-1)); This is used when NaNs are present because BLAS xAXPY
% will not perform multiplications by zero, hence NaNs can disappear.
% coder.internal.prefer_const(n,ix0,ignore1,iy0,ignore2);
% coder.inline('always');
for k = 0:n-1
    y(iy0 + k) = y(iy0 + k) + a*x(ix0 + k); % 
end

```



#### conv

```matlab
if isRow
    C = zeros(1,nC,'like',abzero);
else
    C = zeros(nC,1,'like',abzero);
end
```



```matlab
if nA > 0 && nB > 0
    if nB > nA
        for k = 1:nA
            C = xAXPY(nB,A(k),B,ONE,ONE,C,k,ONE);
        end
    else
        for k = 1:nB
            C = xAXPY(nA,B(k),A,ONE,ONE,C,k,ONE);
        end
    end
end
```





### 重叠保留发

```matlab

```

