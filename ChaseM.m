function [x] = ChaseM(A,b)
%函数的功能：追赶法解三对角线性方程组
%函数的使用：x = ChaseM(A,b)
%      输入：A：系数矩阵，必须是三对角矩阵且满足对角完全占优
%            b：常数矩阵，请输入列向量
%      输出：x：解，一个行向量
%注意事项：如果报告“矩阵输入有误”请检查A与b（必须完全按照上方所说格式输入）,
%          MATLAB版本R2020b
%作者：粤地小蜜蜂
%创建日期：2023年2月3日
%最后更新日期：2023年2月3日
%CSDN：see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    if nargin~=2
       x="有误";
       disp("输入矩阵有误！");
       return;        
    end
   msg = Is(A,b);
   if msg==0
       x="有误";
       disp("输入矩阵有误！");
       return;
   end
  [u,q] = chase(A,b);
  x = catch_up(u,q);   
end

%追 求u与q
function [u,q] = chase(A,b)
    n = size(A,1);
    u = zeros(n-1,1);
    q = zeros(n,1);
    u(1) = A(1,2)/A(1,1);
    q(1) = b(1)/A(1,1);
    for i = 2:n-1
        u(i) = A(i,i+1)/(A(i,i)-A(i,i-1)*u(i-1));
        q(i) = (b(i)-A(i,i-1)*q(i-1))/(A(i,i)-A(i,i-1)*u(i-1));
    end
    q(n) = (b(n)-A(n,n-1)*q(n-1))/(A(n,n)-A(n,n-1)*u(i-1));
end
% 赶：得到解x
function [x] = catch_up(u,q)
    n = size(q,1);
    x = zeros(1,n);
    x(n) = q(n);
    i = n-1;
    while i >=1
        x(i) = q(i)-u(i)*x(i+1);
        i = i-1;
    end
end


%判断是三对角方程组且对角完全占优可解
function [msg] = Is(A,b)
    msg = 1;
   if size(A,1)~=size(b,1)||size(A,1)~=size(A,2)||size(b,2)~=1
      msg = 0;  
      return;
   end 
   if size(A,1)<=2
       msg = 0;
       return;
   end
   n = size(A,1);
   for i = 1:n
       for j = 1:i-2
           if A(i,j)~=0
               msg = 0;
               return;
           end
       end
       for j = i+2:n
           if A(i,j)~=0
               msg = 0;
               return;
           end
       end
       if i~=1&&i~=n&&abs(A(i,i))>=abs(A(i,i-1))+abs(A(i,i+1))
           continue;
       elseif i==1&&abs(A(i,i))>abs(A(i,i+1))
           continue;
       elseif i==n&&abs(A(i,i-1))<abs(A(i,i))
           continue;
       else
           msg = 0;
           return;
       end
   end


end
      

