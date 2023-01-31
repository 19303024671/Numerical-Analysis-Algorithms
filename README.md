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

## 联系我：粤地小蜜蜂
email：[我的QQ邮箱][2]

CSDN:  [我的主页][3]

GitHub：[我的主页][4]

------


  [1]: https://github.com/19303024671/Numerical-Analysis-Algorithms/blob/main/Lagrange.m
  [2]: 3074647498@qq.com
  [3]: https://blog.csdn.net/m0_67194505
  [4]: https://github.com/19303024671
