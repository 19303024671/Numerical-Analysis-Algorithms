function [func] = HermiteI(x,func_in)
%函数的功能：三次埃尔米特(Hermitel)插值算法
%函数的使用：func = Hermite(x,func_in)
%      输入：x:坐标矩阵[1,2,3;2,3,4]
%或    输入：x:横坐标矩阵[1;2;]与
%            func_in:原函数句柄如@(x)x+1
%      输出：埃尔米特插值多项式函数func(可选是否化简)以及可选绘图
%注意事项：适合埃尔米特插值算法的问题(函数值与导数值均相等),有且只有指定两个点(只能三次插值),MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月2日
%最后更新日期：2023年2月3日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    if size(x,1)~=2
        disp("只能进行三次的Hermite插值");
        func = "无结果";
        return;
    end
    temp = zeros(2,3);
    if exist('func_in','var')
        temp(:,1)=x(:,1);
        func_dao = diff(str2sym(func2str(func_in))); 
        for i = 1:2
            temp(i,2) = func_in(x(i,1));
            temp(i,3) = func_dao(x(i,1));
        end
    end
    if ~exist('func_in','var')
        temp(:,:) = x(:,:);
    end

    h0_1 = "(x-"+"("+num2str(temp(1,1))+"))"+"/"+"("+num2str(temp(2,1)-temp(1,1))+")";%(x-x0)/(x1-x0)
    h0_2 = "("+"(x-"+"("+num2str(temp(2,1))+"))"+"/"+"("+num2str(temp(1,1)-temp(2,1))+"))^2"; %((x-x1)/(x0-x1))^2
    h0_1 = "(1+"+"2*"+h0_1+")";%(1+2(x-x0)/(x1-x0))
    h0 = h0_1+"*"+h0_2;
    
    h1_1 = "(x-"+"("+num2str(temp(2,1))+"))"+"/"+"("+num2str(temp(1,1)-temp(2,1))+")";%(x-x1)/(x0-x1)
    h1_2 = "("+"(x-"+"("+num2str(temp(1,1))+"))"+"/"+"("+num2str(temp(2,1)-temp(1,1))+"))^2"; %((x-x0)/(x1-x0))^2
    h1_1 = "(1+"+"2*"+h1_1+")";%(1+2(x-x0)/(x1-x0))
    h1 = h1_1+"*"+h1_2;
    
    H0 = "(x-"+num2str(temp(1,1))+")*"+h0_2;
    H1 = "(x-"+num2str(temp(2,1))+")*"+h1_2;
    func = num2str(temp(1,2))+"*" + h0+"+"+num2str(temp(2,2))+"*"+h1;
    func = func + "+" + num2str(temp(1,3))+"*"+H0+"+"+num2str(temp(2,3))+"*"+H1;
    msg = input("化简？yes or no",'s');
    switch msg
        case "yes"
            func = str2sym(func);
            func = simplify(func);
            func = str2func(['@(x)',vectorize(func)]);
        case "no"
            disp("no simplify");
            func = str2func(strcat("@(x)",func));
        otherwise
                func = str2func(strcat("@(x)",func));
                disp("no accept command");
    end
    if exist('func_in','var')
        msg = input("绘图？yes or no",'s');
        IsPlot(func_in,func,msg);
    end
end

