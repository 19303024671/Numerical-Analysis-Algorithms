function [func] = LowOrder3(x,func_in,n,mode)
%函数的功能：分段三次插值算法
%函数的使用：func = LowOrder3(x1)或func = LowOrder3(x3,func_in,n)
%      输入：x1:坐标矩阵[1,2,3;2,3,4;3,4,5;]表示[x,f(x),f导函数(x);...]
%或    输入：x3:插值总区间如[1,2]与
%            func_in:原函数句柄如@(x)x+1
%            n:分段数
%      输出：分段三次插值函数信息元组func以及绘图操作
%注意事项：1、mode只是为了忽略绘图调用该函数，正常可以忽略
%          2、MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月3日
%最后更新日期：2023年2月4日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    if nargin == 4
        func = in1(x);
    end
   if nargin  == 1
        func = in1(x);
        %绘图
        figure(1);
        hold on
        %先获取分段函数的矩阵[y,x]
        [y,x] = MyFunc(func);
        plot(x,y,'-b');
        title("分段三次插值");
        xlabel("x");ylabel("y");
        grid on
        legend("分段三次插值函数");
        hold off 
        return;
   end
   if nargin == 3
       func = in3(x,func_in,n);
       figure(1);
       fplot(func_in,'-r');
       hold on
       [y,x] = MyFunc(func);
       plot(x,y,'-b');
       title("分段三次插值");
       xlabel("x");ylabel("y");
       grid on
       legend("原函数图像","插值函数图像");
       hold off 
       return;
   end
end

function [func] = in1(x1)
    if size(x1,2)~=3
        disp("输入矩阵有误！");
        func = "无结果";
        return;
    end
    n = size(x1,1)-1;
    func = cell(n,2);
    for i = 1:n
        func{i,1} = "区间：["+num2str(x1(i,1))+","+num2str(x1(i+1,1))+"]";
        func{i,2} = HermiteI([x1(i,:);x1(i+1,:)],"1","mode");
    end   
end

function [func] = in3(x3,func_in,n)
    if size(x3)~=[1,2]
        disp("输入矩阵有误！");
        func = "无结果";
        return;
    end
    temp = zeros(n+1,3);
    p = (max(x3)-min(x3))/n;
    func_dao = str2func(['@(x)', vectorize(diff(str2sym(func2str(func_in))))]);
    for i = 1:n+1
        begin = min(x3)+(i-1)*p;
        temp(i,1) = begin;
        temp(i,2) = func_in(begin);
        temp(i,3) = func_dao(begin);        
    end
    func = in1(temp);
end

