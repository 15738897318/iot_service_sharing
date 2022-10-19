%��Graphȷ��������GenarateGraphCommon���벻ͬ����������ͬ�������õ���ͬ��Taskgraph����������ʱ��ı仯
%Plot_DifferentCommonRatio
% 2021/1/20 �о������⣬�����ܳ�������ǹ�ͬ��������Խ�࣬�����ӳ�Խ��
%    ��Ϊ���ڹ̶��ϳɺ�DAG���˵�����£����ɸ��û�DAG����ͬ��������Խ�࣬ƽ��ÿ���û�DAG������������Խ�࣬������ʱ������
%    ����Ԥ���ҹ���Ӧ���ǹ�ͬ������������ʱ�򣬷����ӳټ�С�Ŷ԰�
% 2021/1/21 ʹ�������������ݼ��е�DAG�����������ֱ���10��8����ͬ����������1~8
%����������ʹ��������������ɵ�ͼ

graph1(1,1:10) = [1,1,0,0,0,0,0,0,0,0];
graph1(2,1:10) = [-1 8 0 0 0 0 0 0 1 0];
graph1(3,1:10) = [0 0 11 0 0 0 0 0 1 0];
graph1(4,1:10) = [0 0 0 1 1 0 0 0 0 0];
graph1(5,1:10) = [0 0 0 -1 2 0 0 1 0 0];
graph1(6,1:10) = [0 0 0 0 0 1 1 0 0 0];
graph1(7,1:10) = [0 0 0 0 0 -1 2 1 0 0];
graph1(8,1:10) = [0 0 0 0 -1 0 -1 22 1 0];
graph1(9,1:10) = [0 -1 -1 0 0 0 0 -1 34 1];
graph1(10,1:10) = [0 0 0 0 0 0 0 0 -1 51];

graph2(1,1:8)=[30 1 0 0 0 0 0 0];
graph2(2,1:8)=[-1 133 0 0 0 0 1 0];
graph2(3,1:8)=[0 0 31 1 0 0 0 0];
graph2(4,1:8)=[0 0 -1 64 0 0 1 0];
graph2(5,1:8)=[0 0 0 0 26 1 0 0];
graph2(6,1:8)=[0 0 0 0 -1 56 1 0];
graph2(7,1:8)=[0 -1 0 -1 0 -1 164 1];
graph2(8,1:8)=[0 0 0 0 0 0 -1 164];

for i=1:10
    if graph1(i,i) < 1
        graph1(i,i) = 1;
    end
    if graph1(i,i) > 1
        graph1(i,i) = 1;
    end
end
for i=1:8
    if graph2(i,i) < 1
        graph2(i,i) = 1;
    end
    if graph2(i,i) > 1
        graph2(i,i) = 1;
    end
end

user1_tasknum = 10;%J_34
user2_tasknum = 8;%J_657
%��ͬ��������0 ~ 8
%Tasknum ��Χ  user1_tasknum + user2_tasknum  - 10  ~  user1_tasknum + user2_tasknum 
Tasknum_min = user1_tasknum + user2_tasknum  - 8;
Tasknum_max = user1_tasknum + user2_tasknum ;
Tasknum_mean =  round((Tasknum_min + Tasknum_max)/2);

userNum = 2;
Servernum = 2;


%���ɵĸ������ݶ�����
%[ServerMemory,TaskMemory,Possionrate,Transferrate,Computespeed_Local,ComputeSpeed_server,EdgeWeight,TaskSize] = GenerateData(userNum,Servernum,Tasknum_max);
[ServerMemory,TaskMemory,Possionrate,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server,EdgeWeight,TaskSize] = GenerateData_NetworkConnect(round(Servernum*(Servernum-1)/4),userNum,Servernum,Tasknum_max);

TaskMemory = randi([20 80],1,Tasknum_max);

cacheRation = 0.8;
low = round(20 * Tasknum_mean * cacheRation/Servernum + 25);
high =  round(80 * Tasknum_mean * cacheRation/Servernum + 25);
ServerMemory = randi([low high],1,Servernum);%ÿ����Ե���������ڴ��С

Computespeed_Local = 3 + 2*rand(Tasknum_max,userNum);  %��ʱ���ؼ���Ħ̷�Χ�� (0.1, 0.5)

ComputationSpeedRatio = 20; %�ڷ�����ִ�е������ھ����ٶȷ���󣬷��䵽���ٶȶ�Ӧ�Ħ��Ǳ���ִ�еĶ��ٱ�
%Tasknum * cacheRation/Servernumƽ��ÿ�����������м�������Ϸ��ٶ�
low = round(3 * Tasknum_mean * cacheRation/Servernum * ComputationSpeedRatio);
high = round(5 * Tasknum_mean * cacheRation/Servernum * ComputationSpeedRatio);
ComputeSpeed_server = randi([low high],1,Servernum);

EdgeWeight = zeros(Tasknum_max,Tasknum_max);
for i = 1:(Tasknum_max-1)
    for j=(i+1):Tasknum_max
        EdgeWeight(i,j) = randi([8 32]); 
    end
end

TaskSize =  randi([10 30],1,Tasknum_max);


x = 0:1:8;
for commonTaskNum = 0:8
    
    Tasknum = user1_tasknum + user2_tasknum - commonTaskNum;
    Taskgraph = zeros(Tasknum, Tasknum, 2);
    
    %ǰcommonTaskNum����������DAG�ж���
    for i=1:commonTaskNum
        Taskgraph(i,i,1:2) = 1;
    end
    %��һ��DAG�б��Ϊ1~user1_tasknum������
    for i = (commonTaskNum+1):user1_tasknum
         Taskgraph(i,i,1) = 1;
         Taskgraph(i,i,2) = 0;
    end
    
    for i = (user1_tasknum + 1):Tasknum
        Taskgraph(i,i,1) = 0;
        Taskgraph(i,i,2) = 1;
    end
    
    %�����һ���û�DAG�ı�
    for i=1:user1_tasknum
        for j=1:user1_tasknum
            if i==j
                continue;
            end
            
           Taskgraph(i,j,1) = graph1(i,j);
        end
    end
    
    %����ڶ����û��ı�
    for i=1:Tasknum
        for j=1:Tasknum
            if i==j
                continue;
            end
            
            if i > commonTaskNum && i <= user1_tasknum
                Taskgraph(i,j,2) = 0;
                continue;
            end
            
            if j > commonTaskNum && j <= user1_tasknum
                Taskgraph(i,j,2) = 0;
                continue;
            end
            
            if i <= commonTaskNum && j <= commonTaskNum
                Taskgraph(i,j,2) = graph2(i,j);
            elseif i > user1_tasknum && j > user1_tasknum
                Taskgraph(i,j,2) = graph2(i - (user1_tasknum - commonTaskNum),j - (user1_tasknum - commonTaskNum));
            elseif i <= commonTaskNum && j > user1_tasknum
                Taskgraph(i,j,2) = graph2(i,j - (user1_tasknum-commonTaskNum));
            else
                Taskgraph(i,j,2) = graph2(i  - (user1_tasknum-commonTaskNum), j);
            end
            

        end
    end
    
    %����Taskgraph�������Ѿ����
    Taskgraph = FulFillTaskgraph(Taskgraph,EdgeWeight,TaskSize,userNum,Tasknum);
    for j = 1 : userNum
        [~, ~] = countTaskLayer(Taskgraph(:,:,j),Tasknum,1,commonTaskNum,j);
    end
    
    %[preCache,preTaskComputationSpeed,preFinishTime] = P1_RankOnNum(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
    [preCache_p3,preTaskComputationSpeed_p3,preFinishTime_p3] = P3_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
    %[preCache_infocom,preTaskComputationSpeed_infocom,preFinishTime_infocom] = P1_infocom(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
    %[preCache_iwqos,preTaskComputationSpeed_iwqos,preFinishTime_iwqos] = P1_iwqos(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
    [preCache_iwqos,preTaskComputationSpeed_iwqos,preFinishTime_iwqos] = P1_iwqos_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
    %[preCache_infocom2,preTaskComputationSpeed_infocom2,preFinishTime_infocom2] = Copy_of_P1_infocom(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
    [preCache_infocom,preTaskComputationSpeed_infocom,preFinishTime_infocom] = P1_infocom_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);

     [~,~,preFinishTime_best] = P1_IterateNum_network(10000,Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
    
    y(commonTaskNum + 1) = preFinishTime_p3;
    y2(commonTaskNum + 1) = preFinishTime_iwqos;
    y3(commonTaskNum + 1) = preFinishTime_infocom;
    y4(commonTaskNum + 1) = preFinishTime_best;
end

z(1:9) = x(1:9)/8 * 100;

% plot(x,y);
% hold on;
% %plot(x,y2);
% plot(x,y4);
% plot(x,y3);

hold on;
plot(z,y4);
plot(z,y);
plot(z,y2);
plot(z,y3);








