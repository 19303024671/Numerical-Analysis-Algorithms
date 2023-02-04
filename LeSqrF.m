function [func] = LeSqrF(table,func_table,w,func_in)
%函数的功能：一般最小二乘法
%函数的使用：func = LeSqrF(table,func_table,w)或者func =
%LeSqr(table,func_table,w,func_in)
%输入：
%     table：坐标矩阵或者只有x列向量
%     func_table：指定拟合函数句柄元组，一个行元组
%     func_in：原函数,用于求table的y向量
%     w:各个点的加权系数矩阵，列向量
%输出：
%     func：拟合多项式句柄
%注意事项：1、注意给定的坐标矩阵table的坐标个数应该大于指定的拟合次数m，否则报无解错误
%          2、加权系数暂时不知道对解有没有影响（应该有）但是用不上，所以输入时可以随意输入个参数，作为占位
%          3、MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月4日
%最后更新日期：2023年2月4日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    if nargin==3
        func = in3(table,func_table,w);
        return;
    end
    if nargin==4
        func = in4(table,func_table,w,func_in);
        return;
    end
end
% 输入三个参数
function [func] = in3(table,func_table,w)
    msg = IsOk3(table,func_table);
    if msg==0
        func = "无解";
        return;
    end
    %正规方程组
    G = get_G(table,func_table,w);
    y = table(:,2);
    [A,b] = get_q(G,y);
    a = GaussX(A,b);
    % 构造func的函数句柄
    func = get_func(a,func_table);
    %绘图
    IsPlot(func);
end
%输入四个参数
function [func] = in4(table,func_table,w,func_in)
    msg = IsOk4(table,func_table,func_in);
    if msg==0
        func="无解";
        return;
    end
    % 构造标准table
    table = [table,func_in(table)];
    func = in3(table,func_table);
    % 绘图
    IsPlot(func,"yes",func_in);
end
% 构造G矩阵
function [G] = get_G(table,func_table,w)
    m = size(func_table,2);
    n = size(table,1);
    x = table(:,1);
    G = zeros(n,m);
    for i = 1:n
        for j = 1:m
            G(i,j) = func_table{j}(x(i));
        end
    end
end
% 构造正规方程组
function [A,b] = get_q(G,y)
    A = G'*G;
    b = G'*y;
end
% 判断输入的参数是否合适
function [msg] = IsOk3(table,func_table)
    msg = 1;
    [rows,cols] = size(table);
    m = size(func_table,2);% func_table应该是一个含m个元素的行元组
    if cols~=2||size(func_table,1)~=1||rows<=m% 应保证给的坐标值够用
        msg = 0;
        return;
    end
    if rows<=1%就一个数你在搞什么？
        msg = 0;
        return;
    end
end
function [msg] = IsOk4(table,func_table,func_in)
    msg = 1;
    [rows,cols] = size(table);
    m = size(func_table,2);
    if rows<=m||cols~=1||class(func_in)~='function_handle'
        msg = 0;
        return;
    end   
end
% 构造函数句柄
function [func] = get_func(a,func_table)
    m = size(func_table,2);
    func = "";
    for i = 1:m
        func_str = func2str(func_table{i});
        func_str = "("+string(func_str(1,5:end))+")";
        func = func + "("+num2str(a(i))+")*"+func_str+"+";
    end
    func = extractBetween(func,1,strlength(func)-1);
    func = str2sym(func);
    func = simplify(func);
    func = str2func(['@(x)',vectorize(func)]);
end