function  IsPlot(func_in,func,msg)
%�����Ĺ��ܣ������������������ͼ��
%����������������������������Լ��ж��Ƿ��ͼ����Ϣ�ַ���yes or no������ͼ��
%������ʹ�ã�IsPlot(func_1,func_2,msg)
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
%ע�����MATLAB�汾R2020b
%���ߣ�����С�۷�
%�������ڣ�2023��2��1��
%���������ڣ�2023��2��1��
%CSDN��see <a href=
%"https://blog.csdn.net/m0_67194505">my CSDN blogs</a>.
    switch msg
        case "yes"
            fplot(func_in,'-r');
            hold on
            fplot(func,'-b');
            xlabel('x');
            ylabel('y');
            legend('ԭ����','����ʽ��ֵ����');
            title('ͼ��Ա�');
            hold off
            grid on
        case "no"
            disp("no plot");
        otherwise
                disp("no accept command");
    end
    
end

