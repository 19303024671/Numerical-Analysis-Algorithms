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
%注意事项：适合拉格朗日插值算法的问题使用
%作者：王洪立
%创建日期：2023年2月1日
%最后更新日期：2023年2月1日
%CSDN：see <a href=
%"https://blog.csdn.net/Undefinedefity">my CSDN blogs</a>.
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
