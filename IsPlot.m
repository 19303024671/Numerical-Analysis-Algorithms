function  IsPlot(func,msg,func_in)
%�����Ĺ��ܣ������������������ͼ��
%����������������������������Լ��ж��Ƿ��ͼ����Ϣ�ַ���yes or no������ͼ��
%������ʹ�ã�IsPlot(func_1,msg,func_2)����IsPlot(func_1)
%���룺
%     func_1:��һ�����������@(x)x+1
%     func_2:�ڶ������������@(x)x.^2
%     msg:�ж���Ϣ�ַ�����yes no
%�����
%     ѡ��yes����ͼ
%     ѡ��no������ͼ
%���ӣ�func_1 = @(x)x+1;
%      func_2 = @(x)x.^2;
%      msg = yes;
%      IsPlot(func_1,func_2,msg)->��ͼ
%ע�����MATLAB�汾R2020b,2��4���޸���ӻ���һ����������Ĳ���
%���ߣ�����С�۷�
%�������ڣ�2023��2��1��
%���������ڣ�2023��2��4��
%CSDN��see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    if nargin==3
        switch msg
        case "yes"
            fplot(func_in,'-r');
            hold on
            fplot(func,'-b');
            xlabel('x');
            ylabel('y');
            legend('ԭ����','����ʽ����');
            title('ͼ��Ա�');
            hold off
            grid on
        case "no"
            disp("no plot");
        otherwise
                disp("no accept command");
        end
        return;
    end
    if nargin==1
        figure(1);
        hold on
        fplot(func,'-b');
        xlabel('x');
        ylabel('y');
        title("����"+func2str(func)+"ͼ�����");
        hold off
        grid on
    end   
end

