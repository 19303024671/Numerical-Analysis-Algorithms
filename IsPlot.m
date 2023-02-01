function  IsPlot(func_in,func,msg)
%函数的功能：绘制两个函数句柄的图像
%函数的描述：输入两个函数句柄以及判断是否绘图的消息字符串yes or no，绘制图像
%函数的使用：IsPlot(func_1,func_2,msg)
%输入：
%     func_1:第一个函数句柄如@(x)x+1
%     func_2:第二个函数句柄如@(x)x.^2
%     msg:判断消息字符串如yes no
%输出：
%     选择yes：绘图
%     选择no：不绘图
%例子：func_1 = @(x)x+1;
%      func_2 = @(x)x.^2;
%      msg = yes;
%      IsPlot(func_1,func_2,msg)->绘图
%注意事项：MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月1日
%最后更新日期：2023年2月1日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    switch msg
        case "yes"
            fplot(func_in,'-r');
            hold on
            fplot(func,'-b');
            xlabel('x');
            ylabel('y');
            legend('原函数','多项式插值函数');
            title('图像对比');
            hold off
            grid on
        case "no"
            disp("no plot");
        otherwise
                disp("no accept command");
    end
    
end

