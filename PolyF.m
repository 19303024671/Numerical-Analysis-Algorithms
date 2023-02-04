function [func] = PolyF(table,m,func_in)  
%函数的功能：多项式拟合（最小二乘法）
%函数的使用：func = PolyF(table,m)或者func = PolyF(table,m,func_in);
%输入：
%     table：坐标矩阵或者只有x列向量
%     m：拟合多项式次数
%     func_in：原函数
%输出：
%     func：拟合多项式句柄
%注意事项：1、注意给定的坐标矩阵table的坐标个数应该大于指定的拟合次数m，否则报无解错误
%          2、MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月4日
%最后更新日期：2023年2月4日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    if nargin==2
        func = in2(table,m);
        IsPlot(func);
        return;
    end
    if nargin==3
        func = in3(table,m,func_in);
        IsPlot(func,"yes",func_in);
        return;
    end
end

function [func] = in2(table,m)
    msg = IsOk(table,m);
    if msg==0
        func = "无解";
        desp("输入矩阵有误");
        return;
    end
    [A,b] = quot(table,m);
    a = GaussX(A,b);  
    func = get_func(a);
end

function [func] = in3(table,m,func_in)
    table = [table,func_in(table)];
    func = in2(table,m);
end
% 判断table,m是否合适
function [msg] = IsOk(table,m)
    msg = 1;
    [rows,cols] = size(table);
    if cols~=2||rows<=1||m>=rows
        msg = 0;
        return;
    end 
end
% 构造正规方程组
function [A,b] = quot(table,m)
    A = zeros(m+1,m+1);
    b = zeros(m+1,1);
    x = table(:,1);
    y = table(:,2);
    %行数
    for i = 0:m
        for j = 0:m
            A(i+1,j+1) = my_sub1(x,i+j);
        end
        b(i+1) = my_sub2(x,y,i,1);
    end   
end
% 求和操作 给定列向量，给定幂次，求出和
function [total] = my_sub1(x,n)
    total = 0;
    rows = size(x,1);
    for i = 1:rows
        total = total + x(i)^n;
    end
end
% 求和，求两个列向量的指定幂次和
function [total] = my_sub2(x,y,n_x,n_y)
    total = 0;
    rows = size(x,1);
    if rows~=size(y,1)
        total = 0;
        disp("求和无解");
        return;
    end
    for i = 1:rows
        total = total + x(i)^n_x*y(i)^n_y;
    end
end
% 构造多项式函数句柄
function [func] = get_func(a)
    func = "";
    m = size(a,1);
    for i = 1:m
        func = func+"("+num2str(a(i))+")*x^("+num2str(i-1)+")+";
    end
    func = extractBetween(func,1,strlength(func)-1);
    func = str2sym(func);
    func = simplify(func);
    func = str2func(['@(x)',vectorize(func)]);
end