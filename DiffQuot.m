function [table] = DiffQuot(x,func)
%函数的功能：求差商的算法
%函数的使用：table = DiffQuot(x,func)或table = DiffQuot(x)
%      输入：x:坐标矩阵[1,2;2,3;3,4;]
%或    输入：x:横坐标矩阵[1;2;3;4]与
%            func:函数句柄如@(x)x+1
%      输出：差商表table
%注意事项：MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月2日
%最后更新日期：2023年2月2日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    n = size(x,1);
    table  = zeros(n,n+1);
    if (~exist('func','var'))
        table(:,1:2) = x(:,1:2);
    end
    if exist('func','var')
        for i = 1:n
            table(i,1) = x(i,1);
            table(i,2) = func(x(i,1));
        end 
    end    
    for i = 3:n+1 %计算列数
        for j = i-1:n%各列的计算数(行数)
            m = i-2;
            num_up = table(j,i-1)-table(j-1,i-1);
            num_down = table(j,1)-table(j-m,1);
            table(j,i) = num_up/num_down;
        end
    end
end

