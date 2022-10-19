%Plot_DifferentUserNum_finishtime 7.25�ӵ�ʵ��
%�������û���������ʵ��DAG������������Ϊÿ���û�dag����ͬ����������ʱ����ֵ����ɵ��û��������

%��һ��ʱ����ֵ
threshold = 0;

% Servernum = 30;
% Tasknum = 100;
% 
% userNumlist = [20, 30, 40, 50, 60];
Servernum = 5;
Tasknum = 25;
userNumlist = [4, 8, 12,16, 20];

maxuserNum = max(userNumlist);%userNumlist�����ֵ

len = length(userNumlist);
y = zeros(1, len);
y2 = zeros(1,len);
y3 = zeros(1, len);
y4 = zeros(1, len);

maxtime = 30;
for times = 1:maxtime

Graph = GenarateGraphParalle(Tasknum,round(Tasknum*0.4));%���ж�
[Taskgraph,Graph] = GenarateGraphCommon_2(Graph,Tasknum,maxuserNum,0.3); %��������ռ��0.3

[ServerMemory,TaskMemory,Possionrate,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server,EdgeWeight,TaskSize] = GenerateData_NetworkConnect(round(Servernum*(Servernum-1)/4),maxuserNum,Servernum,Tasknum);
Taskgraph = FulFillTaskgraph(Taskgraph,EdgeWeight,TaskSize,maxuserNum,Tasknum);



for k= 1: len
    userNum = userNumlist(k);
    
    [preCache_p3,preTaskComputationSpeed_p3,preFinishTime_p3, taskFinishTime_p3] = P3_network_addFinishtime(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
    [preCache_iwqos,preTaskComputationSpeed_iwqos,preFinishTime_iwqos, taskFinishTime_iwqos] = P1_iwqos_network_addFinishtime(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
    [preCache_infocom,preTaskComputationSpeed_infocom,preFinishTime_infocom, taskFinishTime_infocom] = P1_infocom_network_addFinishtime(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
   
    [~,~,~, taskFinishTime_best] =  P1_IterateNum_network_addFinishtime(5000, Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
    %��̬����thresholdʱ����ֵ
    if k == 1
        %threshold = max(taskFinishTime_p3);
        threshold = max(taskFinishTime_best);
    end
    
    count = 0;
    for index = 1:userNum
        if taskFinishTime_p3(index) <= threshold
            count = count + 1;
        end
    end
    y(k) = y(k) + count;
    
    count2 = 0;
    for index = 1:userNum
        if taskFinishTime_iwqos(index) <= threshold
            count2 = count2 + 1;
        end
    end
    y2(k) = y2(k) + count2;
    
    count3 = 0;
    for index = 1:userNum
        if taskFinishTime_infocom(index) <= threshold
            count3 = count3 + 1;
        end
    end
    y3(k) = y3(k) + count3;
    
    count4 = 0;
    for index = 1:userNum
        if taskFinishTime_best(index) <= threshold
            count4 = count4 + 1;
        end
    end
    y4(k) = y4(k) + count4;
    
%     y(k) = y(k) + preFinishTime_p3;
%     y2(k) = y2(k)+ preFinishTime_iwqos;
%     y3(k) = y3(k) +  preFinishTime_infocom;
    
end

times

end

%���ڹ涨ʱ����ֵ����ɵ����������ı�����Ҫ����������
for i=1:len
    y(i) = y(i)/userNumlist(i);
    y2(i) = y2(i)/userNumlist(i);
    y3(i) = y3(i)/userNumlist(i);
    y4(i) = y4(i)/userNumlist(i);
end

y = y/maxtime * 100;
y2 = y2/maxtime * 100;
y3 = y3/maxtime * 100;
y4 = y4/maxtime * 100;

hold on;
plot(userNumlist,y4);
plot(userNumlist,y);
plot(userNumlist,y2);
plot(userNumlist,y3);

   