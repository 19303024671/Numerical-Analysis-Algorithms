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
#### 文件：[HermiteI.m][8]
#### 说明：需要文件 [IsPlot.m][9] 提供绘图操作
#### 代码：
```matlab
function [func] = HermiteI(x,func_in,mode)
%函数的功能：三次埃尔米特(Hermitel)插值算法
%函数的使用：func = Hermite(x,func_in)
%      输入：x:坐标矩阵[1,2,3;2,3,4]
%或    输入：x:横坐标矩阵[1;2]与
%            func_in:原函数句柄如@(x)x+1
%      输出：埃尔米特插值多项式函数func(可选是否化简)以及可选绘图
%注意事项：1、mode表示是否作为子函数调用(忽略绘图与是否化简输入)，正常情况可以直接忽略该参数
%          2、适合埃尔米特插值算法的问题(函数值与导数值均相等),有且只有指定两个点(只能三次插值),MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月2日
%最后更新日期：2023年2月3日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    if size(x,1)~=2
        disp("只能进行三次的Hermite插值");
        func = "无结果";
        return;
    end
    if nargin==1
        func = in1(x);
        func = IsSimple(func);
        return;
    end
    if exist('func_in','var')&& nargin==2
        temp(:,1)=x(:,1);
        func_dao = diff(str2sym(func2str(func_in))); 
        for i = 1:2
            temp(i,2) = func_in(x(i,1));
            temp(i,3) = func_dao(x(i,1));
        end
        func = in1(temp);
        func = IsSimple(func);
        msg = input("绘图？yes or no",'s');
        IsPlot(func_in,func,msg);
        return;
    end    
    if nargin==3
        func = in1(x);
        func = IsSimple(func,"no");
        return;
    end
end
function [func] = in1(x1)
    temp = zeros(2,3);
    temp(:,:) = x1(:,:);
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
end
function [func] = IsSimple(func,mode)
    if ~exist('mode','var')
        msg = input("化简？yes or no",'s');
    else
        msg = "no";
    end
    switch msg
        case "yes"
            func = str2sym(func);
            func = simplify(func);
            func = str2func(['@(x)',vectorize(func)]);
        case "no"
            if nargin==1
                disp("no simplify");
            end
            func = str2func(vectorize(strcat("@(x)",func)));
        otherwise
                func = str2func(strcat("@(x)",func));
                disp("no accept command");
     end
end



```

------

### 5.分段线性插值
#### 文件：[LowOrder1.m][10]
#### 说明：重载函数，可以接受一个或三个参数，具体见文件内说明，需要文件 [Lagrange.m][11] 求两点的直线
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

### 6.分段三次插值（分段Hermite插值）
#### 文件： [LowOrder3.m][12]
#### 说明： 需要文件 [HermiteI.m][13] 提供求每一段的插值函数与文件 [MyFunc.m][14] 提供绘制分段函数所需的[y,x]矩阵，具体见文件内注释
#### 代码：
```matlab
function [func] = LowOrder3(x,func_in,n,mode)
%函数的功能：分段三次插值算法
%函数的使用：func = LowOrder3(x1)或func = LowOrder3(x3,func_in,n)
%      输入：x1:坐标矩阵[1,2,3;2,3,4;3,4,5;]表示[x,f(x),f导函数(x);...]
%或    输入：x3:插值总区间如[1,2]与
%            func_in:原函数句柄如@(x)x+1
%            n:分段数
%      输出：分段三次插值函数信息元组func以及绘图操作
%注意事项：1、mode只是为了忽略绘图调用该函数，正常可以忽略
%          2、MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月3日
%最后更新日期：2023年2月4日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    if nargin == 4
        func = in1(x);
    end
   if nargin  == 1
        func = in1(x);
        %绘图
        figure(1);
        hold on
        %先获取分段函数的矩阵[y,x]
        [y,x] = MyFunc(func);
        plot(x,y,'-b');
        title("分段三次插值");
        xlabel("x");ylabel("y");
        grid on
        legend("分段三次插值函数");
        hold off 
        return;
   end
   if nargin == 3
       func = in3(x,func_in,n);
       figure(1);
       fplot(func_in,'-r');
       hold on
       [y,x] = MyFunc(func);
       plot(x,y,'-b');
       title("分段三次插值");
       xlabel("x");ylabel("y");
       grid on
       legend("原函数图像","插值函数图像");
       hold off 
       return;
   end
end

function [func] = in1(x1)
    if size(x1,2)~=3
        disp("输入矩阵有误！");
        func = "无结果";
        return;
    end
    n = size(x1,1)-1;
    func = cell(n,2);
    for i = 1:n
        func{i,1} = "区间：["+num2str(x1(i,1))+","+num2str(x1(i+1,1))+"]";
        func{i,2} = HermiteI([x1(i,:);x1(i+1,:)],"1","mode");
    end   
end

function [func] = in3(x3,func_in,n)
    if size(x3)~=[1,2]
        disp("输入矩阵有误！");
        func = "无结果";
        return;
    end
    temp = zeros(n+1,3);
    p = (max(x3)-min(x3))/n;
    func_dao = str2func(['@(x)', vectorize(diff(str2sym(func2str(func_in))))]);
    for i = 1:n+1
        begin = min(x3)+(i-1)*p;
        temp(i,1) = begin;
        temp(i,2) = func_in(begin);
        temp(i,3) = func_dao(begin);        
    end
    func = in1(temp);
end


```
------
### 7.样条插值
#### 文件：[Spline.m][15]
#### 说明：需要文件 [GaussX.m][16]提供解线性方程组的高斯消元法 与文件 [ChaseM.m][17]提供解三对角线性方程组的追赶法  还需要文件 [LowOrder3.m][18] 提供分段三次插值基础算法
#### 代码：
```matlab
function [func] = Spline(boundary,table,func_in)
%函数的功能：样条插值算法
%函数的使用：func = Spline(boundary,table,func_in)或者func = Spline(boundary,table)
%      输入：boundary:边界条件类型，一共三种("固支边界条件"，"自然边界条件"，"周期边界条件")
%                     可以直接输入上述字符串名字，也可以直接输入"1","2","3"代表
%            table:坐标值表格，可以是[x,y]也可以是[x]列向量
%            func_in:原函数句柄，如果table为列向量（只有x值），则可以使用原函数计算一下y向量，也可以绘制原函数图像
%      输出：func：插值函数信息元组
%注意事项：1、代码十分混乱，报错在所难免，另外周期边界条件原理存在不确定的情况，暂时不知如何改进，望知悉
%          2、请不要尝试不合理输入，由于缺乏判断输入是否合理的代码，会产生严重后果
%          3、MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月4日
%最后更新日期：2023年2月4日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    if nargin==2
        s = in2(boundary,table);
        func = s{1,2};
        IsP(s);
        return;
    end
    if nargin==3
        s = in3(boundary,table,func_in);
        IsP(s);
        func = s{1,2};
        return;
    end
end

function [s] = in2(boundary,table)
    x = table(:,1);
    y = table(:,2);
    h = h_(x);
    [a,p] = a_p(h,y);
    [A,b] = get_funcs(a,p);
    add_ = get_bou(boundary,y,h);
    quots = get_quots(add_,A,b);
    m = quots{1,2};
    if quots{1,1}=="3"
        temp(1,:) = m(:,1);
        m = temp;
    end
    x = [x,y,m'];
    func = LowOrder3(x,"func_in","n","mode");
    s = {"in2",func};
end

function [s] = in3(boundary,table,func_in)
    y = func_in(table);
    temp = [table,y];
    func = in2(boundary,temp);
    func = func{1,2};
    s = {"in3",func,func_in};
end

%绘图操作
function IsP(s)
    func = s{1,2};
    msg = s{1,1};
    switch msg
        case "in2"    
            [y,x] = MyFunc(func);
            figure(1);
            hold on
            plot(x,y);
            title("样条插值");
            xlabel("x");
            ylabel("y");
            grid on
            hold off
        case "in3"
            figure(1);
            hold on
            fplot(s{1,3},"-r");
            [y,x] = MyFunc(func);
            plot(x,y,"-b");
            title("样条插值");
            xlabel("x");
            ylabel("y");
            grid on
            legend("原函数","插值函数");
            hold off 
    end
end


% α与β获取
function [a,p] = a_p(h,y)
    n = size(y,1)-2;
    a = zeros(1,n);
    p = zeros(1,n);
    for i = 1:n
        a(i) = h(i)/(h(i)+h(i+1));
        p(i) = 3*((1-a(i))/h(i)*(y(i+1)-y(i))+a(i)/h(i+1)*(y(i+2)-y(i+1)));
    end 
end

% h获取
function [h] = h_(x)
    n = size(x,1)-1;
    h = zeros(1,n);
    for i = 1:n
        h(i) = x(i+1)-x(i);
    end
end
% 构造初步方程组
function [A,b] = get_funcs(a,p)
    n = size(a,2);
    b(:,1) = p(1,:);
    A = zeros(n,n+2);
    for i = 1:n
        A(i,i) = 1-a(i);
        A(i,i+1) = 2;
        A(i,i+2) = a(i);
    end
    
end
% 边界条件的处理
function [add_] = get_bou(boundary,y,h)     
    switch boundary
        case {"固支边界条件","1"}
            m0 = str2double(input("请输如第一个点的导数值：","s"));
            m1 = str2double(input("请输如最后一个点的导数值：","s"));
            add_ = {"1",[m0,m1]};
        case {"自然边界条件" ,"2"}
            n = size(y,1);
            q1 = 3/h(1)*(y(2)-y(1));
            q2 = 3/h(n-1)*(y(n)-y(n-1));
            add_ = {"2",[2,1,q1;1,2,q2]};
        case {"周期边界条件","3"}
            n = size(y,1);
            A = zeros(2,n);
            b = zeros(2,1);
            A(1,1) = 1;
            A(1,n) = 1;
            b(1) = 0;
            A(2,1) = (-1)/h(1)*2;
            A(2,2) = (-1)/h(1);
            A(2,n-1) = (-1)/h(n-1)*2;
            A(2,n) = -1/h(n-1);
            b(2) = 3/h(n-1)^2*(y(n-1)-y(n))-3/h(1)^2*(y(2)-y(1));
            add_ = {"3",A,b};
    end
end
% 最终的方程组构造顺便解出结果m矩阵
function [quots] = get_quots(add_,A,b)
    msg = add_{1,1};
    switch msg
        case "1"
            n= size(A,1);
            m0 = add_{1,2}(1);
            m1 = add_{1,2}(2);
            b(1) = b(1)-A(1,1)*m0;
            b(n) = b(n)-A(n,n+2)*m1;
            A_ = A(:,2:n);
            x = ChaseM(A_,b);
            x = [m0,x,m1];
            quots = {"1",x};
        case "2"
            n = size(A,2);
            row1 = add_{1,2}(1,:);
            row2 = add_{1,2}(2,:);
            row_1 = zeros(1,n);
            row_1(1,1:2) = row1(1,1:2);
            row_n = zeros(1,n);
            row_n(1,n-1:n) = row2(1,1:2);
            A_ = [row_1;A;row_n];
            b_ = [row1(3);b;row2(3)];
            x = ChaseM(A_,b_);
            quots = {"2",x};
        case "3"
            add_a = add_{1,2};
            add_b = add_{1,3};
            A_ = [add_a;A];
            b_ = [add_b;b];
            x = GaussX(A_,b_);
            quots = {"3",x};
            
    end
    
end

```
------
## 第六章：解线性方程组的直接法
### 1.高斯消元法
#### 文件：[GaussX.m][19]
#### 代码：
```matlab
function [x] = GaussX(A,b)
%函数的功能：高斯消去法(解线性方程组的一种直接算法)
%函数的使用：x = GaussX(A,b)
%      输入：A:系数矩阵
%            b：常数矩阵，必须为列向量，否则会报无解的错误
%      输出：x：解，也是一个列向量
%注意事项：1、b不接受行向量，如若无解请检查b
%          2、A对角上的数据不应为零，如若无解请检查A对角上的数据
%          3、A对角上的数据不应太小，否则会有较大的舍入误差，结果误差较大请检查
%          4、其他报无解错误，请检查A与b是否合适，如行数应该一样
%          5、MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月4日
%最后更新日期：2023年2月4日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    msg = IsOk(A,b);
    if msg==0
        disp("输入的矩阵不适合高斯消去");
        x = "无解";
        return;
    end
    A_b = cancel(A,b);
    x = sol(A_b);    
end
function [msg] = IsOk(A,b)
    msg = 1;
    [rows,cols] = size(A);
    if rows~=cols|| rows<=1||rows ~= size(b,1)||size(b,2)~=1
        msg = 0;
        return;
    end
    for i = 1:rows
        if A(rows,rows)~=0
            continue;
        else
            msg = 0;
            return;
        end
    end
end

function [A_b] = cancel(A,b)
    A_b = [A,b];
    [rows,cols] = size(A);
    for k = 1:rows-1
        for i = k+1:rows
            for j = 1:cols+1
                A_b(i,j) = A_b(k,j)*(-A(i,k)/A_b(k,k))+A_b(i,j);
            end
        end
        A = A_b(:,1:cols);
    end
end

function [x] = sol(A_b)
    n = size(A_b,1);
    x = zeros(n,1);
    x(n) = A_b(n,n+1)/A_b(n,n);
    i = n-1;
    while i>=1
        temp = 0;
        for j = i+1:n
            temp = A_b(i,j)*x(j)+temp;
        end
        x(i) = (A_b(i,n+1)-temp)/A_b(i,i);
        i=i-1;
    end
end

```
------
### 2.追赶法
#### 文件：[ChaseM.m][20]
#### 说明：只能解对角完全占优的三对角线性方程组，具体见文件内说明
#### 代码：
```matlab
function [x] = ChaseM(A,b)
%函数的功能：追赶法解三对角线性方程组
%函数的使用：x = ChaseM(A,b)
%      输入：A：系数矩阵，必须是三对角矩阵且满足对角完全占优
%            b：常数矩阵，请输入列向量
%      输出：x：解，一个行向量
%注意事项：如果报告“矩阵输入有误”请检查A与b（必须完全按照上方所说格式输入）,
%          MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月3日
%最后更新日期：2023年2月3日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    if nargin~=2
       x="有误";
       disp("输入矩阵有误！");
       return;        
    end
   msg = Is(A,b);
   if msg==0
       x="有误";
       disp("输入矩阵有误！");
       return;
   end
  [u,q] = chase(A,b);
  x = catch_up(u,q);   
end

%追 求u与q
function [u,q] = chase(A,b)
    n = size(A,1);
    u = zeros(n-1,1);
    q = zeros(n,1);
    u(1) = A(1,2)/A(1,1);
    q(1) = b(1)/A(1,1);
    for i = 2:n-1
        u(i) = A(i,i+1)/(A(i,i)-A(i,i-1)*u(i-1));
        q(i) = (b(i)-A(i,i-1)*q(i-1))/(A(i,i)-A(i,i-1)*u(i-1));
    end
    q(n) = (b(n)-A(n,n-1)*q(n-1))/(A(n,n)-A(n,n-1)*u(i-1));
end
% 赶：得到解x
function [x] = catch_up(u,q)
    n = size(q,1);
    x = zeros(1,n);
    x(n) = q(n);
    i = n-1;
    while i >=1
        x(i) = q(i)-u(i)*x(i+1);
        i = i-1;
    end
end


%判断是三对角方程组且对角完全占优可解
function [msg] = Is(A,b)
    msg = 1;
   if size(A,1)~=size(b,1)||size(A,1)~=size(A,2)||size(b,2)~=1
      msg = 0;  
      return;
   end 
   if size(A,1)<=2
       msg = 0;
       return;
   end
   n = size(A,1);
   for i = 1:n
       for j = 1:i-2
           if A(i,j)~=0
               msg = 0;
               return;
           end
       end
       for j = i+2:n
           if A(i,j)~=0
               msg = 0;
               return;
           end
       end
       if i~=1&&i~=n&&abs(A(i,i))>=abs(A(i,i-1))+abs(A(i,i+1))
           continue;
       elseif i==1&&abs(A(i,i))>abs(A(i,i+1))
           continue;
       elseif i==n&&abs(A(i,i-1))<abs(A(i,i))
           continue;
       else
           msg = 0;
           return;
       end
   end


end
      

```
------

## 联系我：粤地小蜜蜂
email：<a href="3074647498@qq.com">我的邮箱</a>

CSDN:  [我的主页][22]

GitHub：[我的主页][23]

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
  [11]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/Lagrange.m
  [12]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/LowOrder3.m
  [13]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/HermiteI.m
  [14]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/MyFunc.m
  [15]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/Spline.m
  [16]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/GaussX.m
  [17]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/ChaseM.m
  [18]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/LowOrder3.m
  [19]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/GaussX.m
  [20]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/ChaseM.m
  [21]: 3074647498@qq.com
  [22]: https://blog.csdn.net/m0_67194505
  [23]: https://github.com/19303024671
