function [func] = NewtonI(x,func_in)
    if ~exist('func_in','var')
        table = DiffQuot(x);
    end
    if exist('func_in','var')
        table = DiffQuot(x,func_in);
    end
    n = size(x,1);
    func = "("+num2str(table(1,2))+")"+"+";
    for i = 2:n
        temp = "("+num2str(table(i,i+1))+")*";
        for j = 1:i-1
            temp = temp + "(x-" + num2str(table(j,1))+")*";
        end
        temp = extractBetween(temp,1,strlength(temp)-1);
        func = func + temp + "+";
    end
    func = extractBetween(func,1,strlength(func)-1);
    msg = input('化简？yes or no','s');
    switch msg
        case 'yes'
                func = str2sym(func);
                func = simplify(func);
                func = str2func(['@(x)',vectorize(func)]);
        case 'no'
            disp('no simplify');
            func = str2func(strcat("@(x)",func));
        otherwise
            disp('no accept command');
    end
end

