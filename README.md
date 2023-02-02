# 数值分析课程算法汇总

------
## 说明：
数值分析是笔者在2022年学习的一门大学专业课程，由于2022年冬广州疫情形势的严峻，笔者所在的学校推迟了期末考试，在复习这门课程的过程中，笔者使用MATLAB语言重新编写了所学的所有算法的代码，特来记录与分享。(❁´◡`❁)*✲ﾟ*

------

## 第一章：插值算法
### 1.拉格朗日插值
#### 文件：  [Lagrange.m][1]
#### 代码：
```matlab
function [func] = Lagrange(x)
%函数的功能：拉格朗日插值算法
%函数的描述：输入坐标矩阵，返回插值多项式函数表达式
%函数的使用：func = Lagrange(x)
%输入：
%     x:坐标矩阵如[1,2;2,3;3,4]表示坐标(1,2),(2,3),(3,4)
%输出：
%     func:插值多项式函数句柄
%例子：func = Lagrange([-1,-2;1,0;3,-6;4,3]
%func =
%
%   包含以下值的 function_handle:
% 
%     @(x)x.^3-4.*x.^2+3
%注意事项：适合拉格朗日插值算法的问题使用,MATLAB版本：R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月1日
%最后更新日期：2023年2月1日
   n = size(x,1);
   func = "";
   for i=1:n
       molecule = "";
       denominator = 1;
       for j=1:i-1
           molecule = molecule+"(x-"+num2str(x(j,1))+")"+"*";
           denominator = denominator*(x(i,1)-x(j,1));
       end
       for j=i+1:n
           if j~=n
               molecule = molecule+"(x-"+num2str(x(j,1))+")"+"*"; 
           else
               molecule = molecule+"(x-"+num2str(x(j,1))+")";               
           end
           denominator = denominator*(x(i,1)-x(j,1));
       end
       if i==1
           func = func + molecule+ "*"+num2str(x(i,2))+"/("+num2str(denominator)+")";
       elseif i==n
           func = func + "+"+ molecule +num2str(x(i,2))+"/("+ num2str(denominator)+")"; 
       else
           func = func +"+"+ molecule+ "*"+num2str(x(i,2))+"/("+num2str(denominator)+")";
       end
   end
    func = str2sym(func);
    func = simplify(func);
    func = str2func(['@(x)',vectorize(func)]);
end

```
------
### 2.拉格朗日插值（原函数型）
#### 文件：[Lagrange2.m][2]
#### 说明：需要文件 [Lagrange.m][3] （拉格朗日插值算法原型）与 [IsPlot.m][4] （绘图操作）
#### 代码：
```MATLAB
function [func] = Lagrange2(func_in,x)
%函数的功能：拉格朗日插值算法(函数句柄参数型）
%函数的描述：输入x坐标矩阵与原函数句柄，返回插值多项式函数句柄以及是否绘图
%函数的使用：func = Lagrange(x)
%输入：
%     x:x坐标矩阵如[1;2;3;4]表示x坐标为1,2,3,4
%     func_in：原函数句柄如@(x)x.^(1/2)表示函数f(x)=x^(1/2)
%输出：
%     func:插值多项式函数句柄
%     选择yes：绘图
%     选择no：不绘图
%例子：func_in
% func_in =
% 
%   包含以下值的 function_handle:
% 
%     @(x)x.^(1/2)
% 
% x
% 
% x =
% 
%      4
%      9
% 
% func=Lagrange2(func_in,x)
% 图形化？yes or noyes
% 
% func =
% 
%   包含以下值的 function_handle:
% 
%     @(x)x./5+6./5
%注意事项：适合拉格朗日插值算法的问题使用，给定原函数与x坐标，MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月1日
%最后更新日期：2023年2月1日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    n = size(x,1);
    for i=1:n
        x(i,2) = func_in(x(i,1));
    end
    func = Lagrange(x);
    msg = input("图形化？yes or no",'s');
    IsPlot(func_in,func,msg);
end

```
------

### 3.牛顿插值
#### 文件：[NewtonI.m][5]
#### 说明：需要文件 [DiffQuot.m][6] （提供求差商表的操作） 与 [IsPlot.m][7] （绘图操作）
#### 代码：
```matlab
function [func] = NewtonI(x,func_in)
%函数的功能：牛顿插值算法
%函数的使用：func = NewtonI(x,func_in)或table=NewtonI(x)
%      输入：x:坐标矩阵[1,2;2,3;3,4;]
%或    输入：x:横坐标矩阵[1;2;3;4]与
%            func_in:原函数句柄如@(x)x+1
%      输出：牛顿插值多项式函数func(可选是否化简)以及可选绘图
%注意事项：适合牛顿插值算法的问题,MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月2日
%最后更新日期：2023年2月2日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    if ~exist('func_in','var')
        table = DiffQuot(x);
    end
    if exist('func_in','var')
        table = DiffQuot(x,func_in);
    end
    n = size(x,1);
    func = "("+num2str(table(1,2))+")"+"+";
    for i = 2:n
        temp = "("+num2str(table(i,i+1))+")*";
        for j = 1:i-1
            temp = temp + "(x-" + num2str(table(j,1))+")*";
        end
        temp = extractBetween(temp,1,strlength(temp)-1);
        func = func + temp + "+";
    end
    func = extractBetween(func,1,strlength(func)-1);
    msg = input('化简？yes or no','s');
    switch msg
        case 'yes'
                func = str2sym(func);
                func = simplify(func);
                func = str2func(['@(x)',vectorize(func)]);
        case 'no'
            disp('no simplify');
            func = str2func(strcat("@(x)",func));
        otherwise
            disp('no accept command');
    end
    msg = input('绘图？','s');
    IsPlot(func_in,func,msg);
end


```

------

### 4.三次埃尔米特插值算法
#### 文件：[Hermite.m][8]
#### 说明：需要文件 [IsPlot.m][9] 提供绘图操作
#### 代码：
```matlab
function [func] = HermiteI(x,func_in)
%函数的功能：三次埃尔米特(Hermitel)插值算法
%函数的使用：func = Hermite(x,func_in)
%      输入：x:坐标矩阵[1,2;2,3;3,4;]
%或    输入：x:横坐标矩阵[1;2;3;4]与
%            func_in:原函数句柄如@(x)x+1
%      输出：埃尔米特插值多项式函数func(可选是否化简)以及可选绘图
%注意事项：适合埃尔米特插值算法的问题(函数值与导数值均相等),有且只有指定两个点(只能三次插值),MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月2日
%最后更新日期：2023年2月2日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    if size(x,1)~=2
        disp("只能进行三次的Hermite插值");
        return;
    end
    temp = zeros(2,3);
    if exist('func_in','var')
        temp(:,1)=x(:,1);
        func_dao = diff(str2sym(func2str(func_in))); 
        for i = 1:2
            temp(i,2) = func_in(x(i,1));
            temp(i,3) = func_dao(x(i,1));
        end
    end
    if ~exist('func_in','var')
        temp(:,:) = x(:,:);
    end

    h0_1 = "(x-"+"("+num2str(temp(1,1))+"))"+"/"+"("+num2str(temp(2,1)-temp(1,1))+")";%(x-x0)/(x1-x0)
    h0_2 = "("+"(x-"+"("+num2str(temp(2,1))+"))"+"/"+"("+num2str(temp(1,1)-temp(2,1))+"))^2"; %((x-x1)/(x0-x1))^2
    h0_1 = "(1+"+"2*"+h0_1+")";%(1+2(x-x0)/(x1-x0))
    h0 = h0_1+"*"+h0_2;
    
    h1_1 = "(x-"+"("+num2str(temp(2,1))+"))"+"/"+"("+num2str(temp(1,1)-temp(2,1))+")";%(x-x1)/(x0-x1)
    h1_2 = "("+"(x-"+"("+num2str(temp(1,1))+"))"+"/"+"("+num2str(temp(2,1)-temp(1,1))+"))^2"; %((x-x0)/(x1-x0))^2
    h1_1 = "(1+"+"2*"+h1_1+")";%(1+2(x-x0)/(x1-x0))
    h1 = h1_1+"*"+h1_2;
    
    H0 = "(x-"+num2str(temp(1,1))+")*"+h0_2;
    H1 = "(x-"+num2str(temp(2,1))+")*"+h1_2;
    func = num2str(temp(1,2))+"*" + h0+"+"+num2str(temp(2,2))+"*"+h1;
    func = func + "+" + num2str(temp(1,3))+"*"+H0+"+"+num2str(temp(2,3))+"*"+H1;
    msg = input("化简？yes or no",'s');
    switch msg
        case "yes"
            func = str2sym(func);
            func = simplify(func);
            func = str2func(['@(x)',vectorize(func)]);
        case "no"
            disp("no simplify");
            func = str2func(strcat("@(x)",func));
        otherwise
                func = str2func(strcat("@(x)",func));
                disp("no accept command");
    end
    if exist('func_in','var')
        msg = input("绘图？yes or no",'s');
        IsPlot(func_in,func,msg);
    end
end


```

------

### 5.分段线性插值
#### 文件：[LowOrder1.m][10]
#### 说明：重载函数，可以接受一个或三个参数，具体见文件内说明
#### 代码：
```matlab
function [func] = LowOrder1(x,func_in,n)
%函数的功能：分段线性插值算法
%函数的使用：func = LowOrder(x1)或者func=LowOrder(x3,func_in,n)
%输入：
%     x1:坐标矩阵如[1,2;2,3;3,4]
%     x3:插值总区间如[0,5]
%     func_in:原函数句柄如@(x) 1./(1+25.*x.^2)
%     n:插值区间分段数如n=5则将[0,5]分成五段
%输出：
%     func:包含分段取值说明与各个分段内的线性函数句柄如：
% func =
% 
%   10×2 cell 数组
% 
%     {["区间：[-1,-0.8]"        ]}    {@(x)0.10181.*x+0.140272}
%     {["区间：[-0.8,-0.6]"      ]}    {@(x)0.20588.*x+0.223528}
%     {["区间：[-0.6,-0.4]"      ]}    {         @(x)0.5.*x+0.4}
%     {["区间：[-0.4,-0.2]"      ]}    {         @(x)1.5.*x+0.8}
%     {["区间：[-0.2,5.5511e-17]"]}    {        function_handle}
%     {["区间：[0,0.2]"          ]}    {         @(x)1.0-2.5.*x}
%     {["区间：[0.2,0.4]"        ]}    {         @(x)0.8-1.5.*x}
%     {["区间：[0.4,0.6]"        ]}    {         @(x)0.4-0.5.*x}
%     {["区间：[0.6,0.8]"        ]}    {@(x)0.223528-0.20588.*x}
%     {["区间：[0.8,1]"          ]}    {@(x)0.140272-0.10181.*x}
%注意事项：适合低次线性插值算法的问题使用，x1矩阵横坐标首尾应相接，MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月2日
%最后更新日期：2023年2月2日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    if nargin == 3
        func = in3(x,func_in,n);
    end
    if nargin==1
        func = in1(x);
    end
end
function [func] = in3(x,func_in,n)
    if size(x)~= [1,2]
        disp("区间x输入有误");
        func = "无结果";
        return;
    end
    func = cell(n,2);
    p = (max(x)-min(x))/n;
    figure(1);
    fplot(func_in,'-r');
    hold on
    for i=1:n
        begin = min(x)+(i-1)*p;
        endl = begin + p;
        func{i,1} = "区间：["+num2str(begin)+","+num2str(endl)+"]";
        func{i,2} = Lagrange([begin,func_in(begin);endl,func_in(endl)]);
        plot([begin,endl],[func_in(begin),func_in(endl)],'-b');
    end
    axis([min(x),max(x),min(func_in(x)),Inf]);
    title("分段线性插值");
    xlabel("x");ylabel("y");
    grid on
    hold off
    legend("原函数","插值函数");
end

function [func] = in1(x)
    if size(x,2)~=2 || size(x,1)<=1
        disp("坐标矩阵x有误");
        func = "无结果";
        return;
    end
    n = size(x,1);
    func = cell(n-1,2);
    figure(1);
    hold on
    for i = 1:n-1
        func{i,1} = "区间：["+num2str(x(i,1))+","+num2str(x(i+1,1))+"]";
        func{i,2} = Lagrange([x(i,1),x(i,2);x(i+1,1),x(i+1,2)]);
        plot([x(i,1),x(i+1,1)],[x(i,2),x(i+1,2)],'-b');
    end
    grid on
    title("分段线性插值");
    xlabel("x");ylabel("y");
    axis([min(x(:,1)),max(x(:,1)),min(x(:,2)),max(x(:,2))]);
    hold off
end


```

------

## 联系我：粤地小蜜蜂
email：[我的QQ邮箱][11]

CSDN:  [我的主页][12]

GitHub：[我的主页][13]

------


  [1]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/Lagrange.m
  [2]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/Lagrange2.m
  [3]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/Lagrange.m
  [4]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/IsPlot.m
  [5]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/NewtonI.m
  [6]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/DiffQuot.m
  [7]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/IsPlot.m
  [8]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/HermiteI.m
  [9]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/IsPlot.m
  [10]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/LowOrder1.m
  [11]: 3074647498@qq.com
  [12]: https://blog.csdn.net/m0_67194505
  [13]: https://github.com/19303024671
