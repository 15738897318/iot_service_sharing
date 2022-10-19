%��ͬ��������
%Plot_DifferentTaskNum
%����ûʹ�����ͼ����������Կ���ʹ��

%ServerMemory��ComputeSpeed_server֮�����Ӧ�ñ��ֲ���
%Tasknum 4~40
Servernum = 2;
userNum = 2;
% Tasknum_mean = 22; %4 ~ 40 
% Tasknum_max = 40;
Tasknum_mean = 42; %4 ~ 80
Tasknum_max = 80;


[ServerMemory,TaskMemory,Possionrate,Transferrate,Computespeed_Local,ComputeSpeed_server,EdgeWeight,TaskSize] = GenerateData(userNum,Servernum,Tasknum_mean);
%���漸��������length��Tasknum�йأ�Ӧ�ð���Tasknum_max������
TaskMemory = randi([20 80],1,Tasknum_max);
Computespeed_Local = 3 + 2*rand(Tasknum_max,userNum);

EdgeWeight = zeros(Tasknum_max,Tasknum_max);
for i = 1:(Tasknum_max-1)
    for j=(i+1):Tasknum_max
        EdgeWeight(i,j) = randi([2 8]);
    end
end

TaskSize =  randi([10 30],1,Tasknum_max);

% x = 4:4:40;
x = 4:4:80;
index = 1;
for Tasknum = 4:4:80 
    Graph = GenarateGraphParalle(Tasknum,Tasknum*0.5); %���ж�Ϊһ��
    [Taskgraph,Graph] = GenarateGraphCommon_2(Graph,Tasknum,userNum,0.3); %��������ռ��0.3
    Taskgraph = FulFillTaskgraph(Taskgraph,EdgeWeight,TaskSize,userNum,Tasknum);
    
    [preCache,preTaskComputationSpeed,preFinishTime] = P1_RankOnNum(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
    
    %[preCache_infocom,preTaskComputationSpeed_infocom,preFinishTime_infocom] = P1_infocom(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
    [preCache_iwqos,preTaskComputationSpeed_iwqos,preFinishTime_iwqos] = P1_iwqos(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
   [preCache_iwqos2,preTaskComputationSpeed_iwqos2,preFinishTime_iwqos2] = Copy_of_P1_iwqos(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
    
    
     [preCache_infocom2,preTaskComputationSpeed_infocom2,preFinishTime_infocom2] = Copy_of_P1_infocom(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
    
    Tasknum
    y(index) = preFinishTime;
    %y2(index) = preFinishTime_infocom;
    y3(index) = preFinishTime_iwqos;
    y4(index) = preFinishTime_infocom2;
    y5(index) = preFinishTime_iwqos2;

    index = index + 1;
end

plot(x,y);
hold on;
%plot(x,y2);
plot(x,y4);
plot(x,y3);
plot(x,y5);

