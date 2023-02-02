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

