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
