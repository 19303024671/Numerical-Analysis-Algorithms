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

