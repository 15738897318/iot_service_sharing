%�����������̶������Ƿ�������memory�仯�������ܹ���cache�����������ı�
%Plot_DifferentServerMemory
%����û�����ͼ�����Ǳ�����Կ��ǡ�ע������ʹ�õĻ���P1��������P3

Tasknum = 10;
Servernum = 2;
userNum = 1;

%�õ�����
Graph = GenarateGraphParalle(Tasknum,round(Tasknum*0.4)); %���ж�
%[Taskgraph,Graph] = GenarateGraphCommon_2(Graph,Tasknum,userNum,0.3); %��������ռ��0.3
% ��������userNumΪ1��ֱ�Ӹ�Taskgraph��ֵ������
Taskgraph = zeros(Tasknum,Tasknum,userNum);
Taskgraph(:,:,1) = Graph;

%�������ݶ����䣬��ServerMemory�Ǳ���
[ServerMemory,TaskMemory,Possionrate,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server,EdgeWeight,TaskSize] = GenerateData_NetworkConnect(round(Servernum*(Servernum-1)/4),userNum,Servernum,Tasknum);
%GenerateData������TaskMemory�ķ�Χ��[20,80]������̫���ˣ���Сһ��
TaskMemory = randi([40 60],1,Tasknum);


Taskgraph = FulFillTaskgraph(Taskgraph,EdgeWeight,TaskSize,userNum,Tasknum);


ration = [0.2,0.4,0.6,0.8,1];
%  x = 0:2:28;
for k=1:length(ration)
for times = 1:30
    cacheNum = Tasknum * ration(k);
    %ServerMemory = normrnd(cacheNum/2 * 50 + 25,1,[1 Servernum]);
    ServerMemory =  normrnd(cacheNum/Servernum * 50 + 25,1,[1 Servernum]);
    
    [preCache_p3,preTaskComputationSpeed_p3,preFinishTime_p3] = P3_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
    [preCache_iwqos,preTaskComputationSpeed_iwqos,preFinishTime_iwqos] = P1_iwqos_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
    [preCache_infocom,preTaskComputationSpeed_infocom,preFinishTime_infocom] = P1_infocom_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
     [~,~,preFinishTime_best] = P1_IterateNum_network(7000,Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
    
    ration(k)
%     y(k) = preFinishTime_p3;
%     y2(k) = preFinishTime_infocom;
%     y3(k) = preFinishTime_iwqos;
         z(k,times) = preFinishTime_p3;
        z2(k,times) = preFinishTime_infocom;
        z3(k,times) = preFinishTime_iwqos;
        z4(k,times) = preFinishTime_best;
    
    
end
end

for i = 1 : length(ration)
    y(i) = mean(z(i,:));
    y2(i) = mean(z2(i,:));
    y3(i) = mean(z3(i,:));
    y4(i) = mean(z4(i,:));
end

hold on;
plot(ration,y4);
plot(ration,y);
plot(ration,y2);
plot(ration,y3);


