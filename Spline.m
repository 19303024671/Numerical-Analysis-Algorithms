function [func] = Spline(boundary,table,func_in)
%函数的功能：样条插值算法
%函数的使用：func = Spline(boundary,table,func_in)或者func = Spline(boundary,table)
%      输入：boundary:边界条件类型，一共三种("固支边界条件"，"自然边界条件"，"周期边界条件")
%                     可以直接输入上述字符串名字，也可以直接输入"1","2","3"代表
%            table:坐标值表格，可以是[x,y]也可以是[x]列向量
%            func_in:原函数句柄，如果table为列向量（只有x值），则可以使用原函数计算一下y向量，也可以绘制原函数图像
%      输出：func：插值函数信息元组
%注意事项：1、代码十分混乱，报错在所难免，另外周期边界条件原理存在不确定的情况，暂时不知如何改进，望知悉
%          2、请不要尝试不合理输入，由于缺乏判断输入是否合理的代码，会产生严重后果
%          3、MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月4日
%最后更新日期：2023年2月4日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    if nargin==2
        s = in2(boundary,table);
        func = s{1,2};
        IsP(s);
        return;
    end
    if nargin==3
        s = in3(boundary,table,func_in);
        IsP(s);
        func = s{1,2};
        return;
    end
end

function [s] = in2(boundary,table)
    x = table(:,1);
    y = table(:,2);
    h = h_(x);
    [a,p] = a_p(h,y);
    [A,b] = get_funcs(a,p);
    add_ = get_bou(boundary,y,h);
    quots = get_quots(add_,A,b);
    m = quots{1,2};
    if quots{1,1}=="3"
        temp(1,:) = m(:,1);
        m = temp;
    end
    x = [x,y,m'];
    func = LowOrder3(x,"func_in","n","mode");
    s = {"in2",func};
end

function [s] = in3(boundary,table,func_in)
    y = func_in(table);
    temp = [table,y];
    func = in2(boundary,temp);
    func = func{1,2};
    s = {"in3",func,func_in};
end

%绘图操作
function IsP(s)
    func = s{1,2};
    msg = s{1,1};
    switch msg
        case "in2"    
            [y,x] = MyFunc(func);
            figure(1);
            hold on
            plot(x,y);
            title("样条插值");
            xlabel("x");
            ylabel("y");
            grid on
            hold off
        case "in3"
            figure(1);
            hold on
            fplot(s{1,3},"-r");
            [y,x] = MyFunc(func);
            plot(x,y,"-b");
            title("样条插值");
            xlabel("x");
            ylabel("y");
            grid on
            legend("原函数","插值函数");
            hold off 
    end
end


% α与β获取
function [a,p] = a_p(h,y)
    n = size(y,1)-2;
    a = zeros(1,n);
    p = zeros(1,n);
    for i = 1:n
        a(i) = h(i)/(h(i)+h(i+1));
        p(i) = 3*((1-a(i))/h(i)*(y(i+1)-y(i))+a(i)/h(i+1)*(y(i+2)-y(i+1)));
    end 
end

% h获取
function [h] = h_(x)
    n = size(x,1)-1;
    h = zeros(1,n);
    for i = 1:n
        h(i) = x(i+1)-x(i);
    end
end
% 构造初步方程组
function [A,b] = get_funcs(a,p)
    n = size(a,2);
    b(:,1) = p(1,:);
    A = zeros(n,n+2);
    for i = 1:n
        A(i,i) = 1-a(i);
        A(i,i+1) = 2;
        A(i,i+2) = a(i);
    end
    
end
% 边界条件的处理
function [add_] = get_bou(boundary,y,h)     
    switch boundary
        case {"固支边界条件","1"}
            m0 = str2double(input("请输如第一个点的导数值：","s"));
            m1 = str2double(input("请输如最后一个点的导数值：","s"));
            add_ = {"1",[m0,m1]};
        case {"自然边界条件" ,"2"}
            n = size(y,1);
            q1 = 3/h(1)*(y(2)-y(1));
            q2 = 3/h(n-1)*(y(n)-y(n-1));
            add_ = {"2",[2,1,q1;1,2,q2]};
        case {"周期边界条件","3"}
            n = size(y,1);
            A = zeros(2,n);
            b = zeros(2,1);
            A(1,1) = 1;
            A(1,n) = 1;
            b(1) = 0;
            A(2,1) = (-1)/h(1)*2;
            A(2,2) = (-1)/h(1);
            A(2,n-1) = (-1)/h(n-1)*2;
            A(2,n) = -1/h(n-1);
            b(2) = 3/h(n-1)^2*(y(n-1)-y(n))-3/h(1)^2*(y(2)-y(1));
            add_ = {"3",A,b};
    end
end
% 最终的方程组构造顺便解出结果m矩阵
function [quots] = get_quots(add_,A,b)
    msg = add_{1,1};
    switch msg
        case "1"
            n= size(A,1);
            m0 = add_{1,2}(1);
            m1 = add_{1,2}(2);
            b(1) = b(1)-A(1,1)*m0;
            b(n) = b(n)-A(n,n+2)*m1;
            A_ = A(:,2:n);
            x = ChaseM(A_,b);
            x = [m0,x,m1];
            quots = {"1",x};
        case "2"
            n = size(A,2);
            row1 = add_{1,2}(1,:);
            row2 = add_{1,2}(2,:);
            row_1 = zeros(1,n);
            row_1(1,1:2) = row1(1,1:2);
            row_n = zeros(1,n);
            row_n(1,n-1:n) = row2(1,1:2);
            A_ = [row_1;A;row_n];
            b_ = [row1(3);b;row2(3)];
            x = ChaseM(A_,b_);
            quots = {"2",x};
        case "3"
            add_a = add_{1,2};
            add_b = add_{1,3};
            A_ = [add_a;A];
            b_ = [add_b;b];
            x = GaussX(A_,b_);
            quots = {"3",x};
            
    end
    
end

