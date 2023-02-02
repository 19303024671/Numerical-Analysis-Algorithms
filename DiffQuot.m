function [table] = DiffQuot(x,func)
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

