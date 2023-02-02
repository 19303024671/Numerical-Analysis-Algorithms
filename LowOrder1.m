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

