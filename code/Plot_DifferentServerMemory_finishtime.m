%Plot_DifferentServerMemory_finishtime

%��һ��ʱ����ֵ
threshold = 0;%ʱ����ֵ�����ܳ����Ľ���У���ʱ�������������

Tasknum = 35;
Servernum = 8;
userNum = 25;

ration = [0.2,0.4,0.6,0.8,1];
len = length(ration);

%�õ�����
Graph = GenarateGraphParalle(Tasknum,round(Tasknum*0.4)); %���ж�
[Taskgraph,Graph] = GenarateGraphCommon_2(Graph,Tasknum,userNum,0.3); %��������ռ��0.3


%�������ݶ����䣬��ServerMemory�Ǳ���
[ServerMemory,TaskMemory,Possionrate,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server,EdgeWeight,TaskSize] = GenerateData_NetworkConnect(round(Servernum*(Servernum-1)/4),userNum,Servernum,Tasknum);
%GenerateData������TaskMemory�ķ�Χ��[20,80]������̫���ˣ���Сһ��
TaskMemory = randi([40 60],1,Tasknum);


Taskgraph = FulFillTaskgraph(Taskgraph,EdgeWeight,TaskSize,userNum,Tasknum);


taskset = randperm(Tasknum,Tasknum);

y_a = zeros(1, len);
y2_a = zeros(1, len);
y3_a = zeros(1,len);
y4_a = zeros(1, len);


maxtime = 20;
for times = 1 : maxtime%ע�⣡���������������ظ����飬�����Ҫ���Դ���

for k=len:-1:1

    cacheNum = Tasknum * ration(k);
    %ServerMemory = normrnd(cacheNum/2 * 50 + 25,1,[1 Servernum]);
    ServerMemory =  normrnd(cacheNum/Servernum * 50 + 25,1,[1 Servernum]);
    
%     [preCache_p3,preTaskComputationSpeed_p3,preFinishTime_p3] = P3_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
%     
%     [preCache_iwqos,preTaskComputationSpeed_iwqos,preFinishTime_iwqos] = P1_iwqos_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
%     
%     [preCache_infocom,preTaskComputationSpeed_infocom,preFinishTime_infocom] = P1_infocom_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
%     
%      [~,~,preFinishTime_best] = P1_IterateNum_network(7000,Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
%     
     
     
      [~,~,~, taskFinishTime_best] =  P1_IterateNum_network_addFinishtime(10000, Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
     
    %��̬����thresholdʱ����ֵ
    if k==len
        threshold = max(taskFinishTime_best);
    end
    
        count4 = 0;
    for index = 1:userNum
        if taskFinishTime_best(index) <= threshold
            count4 = count4 + 1;
        end
    end
    y4_a(k) = y4_a(k)+count4;
    
    
    
    [~,~,~, taskFinishTime_p3] = P3_network_addFinishtime(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
     
        count = 0;
    for index = 1:userNum
        if taskFinishTime_p3(index) <= threshold
            count = count + 1;
        end
    end
    y_a(k) = y_a(k)+ count;
    
    
     [~,~,~, taskFinishTime_iwqos2] = P1_iwqos_network_taskset_addFinishtime(taskset,Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
        count3 = 0;
    for index = 1:userNum
        if taskFinishTime_iwqos2(index) <= threshold
            count3 = count3 + 1;
        end
    end
    y3_a(k) = y3_a(k) + count3;
    
    
      [~,~,~, taskFinishTime_infocom] = P1_infocom_network_addFinishtime(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    count2 = 0;
    for index = 1:userNum
        if taskFinishTime_infocom(index) <= threshold
            count2 = count2 + 1;
        end
    end
    y2_a(k) = y2_a(k)+count2;
     
     
     
     
    
    

end

times

end

%��������maxtimes���ظ����飬�����Ҫ����maxtimes
y_a = y_a/maxtime;
y2_a = y2_a/maxtime;
y3_a = y3_a/maxtime;
y4_a = y4_a/maxtime;


hold on;
plot(ration, y4_a);
plot(ration, y_a);
plot(ration, y2_a);
plot(ration, y3_a);


