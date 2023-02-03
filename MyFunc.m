function [y,x] = MyFunc(func,accu)
%函数的功能：用于分段函数的构造
%函数的使用：[y,x] = MyFunc(func)
%      输入：func:表示分段函数的元组如：
%                   func =
%                       2×2 cell 数组
%                       {["区间：[-1,-0.8]"        ]}    {@(x)0.10181.*x+0.140272}
%                       {["区间：[-0.8,-0.6]"      ]}    {@(x)0.20588.*x+0.223528}
%            accu:精度即每个区间在分割的步长，默认为0.001
%      输出：[y,x]:分段函数矩阵如x:[0:0.1:1,1:0.1:2,...] y=func(x)
%            获得[y,x]后可以直接plot(x,y)绘制分段函数func的图像
%注意事项：1、func元组必须为LowOrder系列函数的返回值(或者自己构造的类似结构的元组),
%          2、另外，存在运行速度未进行优化的错误，暂不知如何操作
%         /3、MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月3日
%最后更新日期：2023年2月3日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    if ~exist('accu','var')
        accu = 0.001;
    end
    n = size(func,1);
    y = [];
    x = [];
    for i = 1:n
        x1 = str2double(extractBetween(func{i,1},"[",","));
        x2 = str2double(extractBetween(func{i,1},",","]"));
        temp_x = x1:accu:x2;
        func_y = func{i,2};
        temp_y = func_y(temp_x);
        x = [x,temp_x];
        y = [y,temp_y];
    end
end

