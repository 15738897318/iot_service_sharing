%Plot_DifferentNetWorkEdgeNum
%GenerateData_Network��һ��������������֮��ı�����ͬ
%��������������������������ͼ Network Connectivity �������������̶���ƽ��ÿ����������ͨ�ȣ��������仯

% userNum = 50;
% Servernum = 30; %���30 * 29/2���Ƿ�����������14.5��
% Tasknum = 100;
% 
% ration = [2,5,8,10,12,14];
userNum = 1;
Servernum = 8; %���30 * 29/2���Ƿ�����������14.5��
Tasknum = 20;

ration = [1,1.5,2,2.5,3];

len = length(ration);

Graph = GenarateGraphParalle(Tasknum,round(Tasknum*0.4));%���ж�
% [Taskgraph,Graph] = GenarateGraphCommon_2(Graph,Tasknum,userNum,0.3); %��������ռ��0.3
    % ��������userNumΪ1��ֱ�Ӹ�Taskgraph��ֵ������
    Taskgraph = zeros(Tasknum,Tasknum,userNum);
    Taskgraph(:,:,1) = Graph;
    

[ServerMemory,TaskMemory,Possionrate,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server,EdgeWeight,TaskSize] = GenerateData_NetworkConnect(round(Servernum*(Servernum-1)/4),userNum,Servernum,Tasknum);
Taskgraph = FulFillTaskgraph(Taskgraph,EdgeWeight,TaskSize,userNum,Tasknum);

for j = 1 : userNum
        [~, ~] = countTaskLayer(Taskgraph(:,:,j),Tasknum,1,1,j);
end

taskset = randperm(Tasknum,Tasknum);

for k=1:len
    
    edgeNum = Servernum * ration(k);
    
   for times = 1:20
    
    
    %edgeNum�ı䣬������������
    Transferrate_network = Transferrate;


%----------------��Ӵ��룬������ͨ�ԣ���Ե������֮���е�����ͨ���еĲ�����ͨ��һ��edgeNum���ߣ�---------------------------------------
    NetworkTopo = zeros(Servernum, Servernum);

    n = Servernum;
    rowLast = zeros(1,n - 1);
    rowLast(1) = n-1;
    for i=2:(n - 1)
        rowLast(i) = rowLast(i-1) + n-i;
    end

    MAX_EDGE_NUM = n * (n - 1)/2;
%���ϰ벿�֣��������м�б�ߣ���n*(n-1)/2���㣬��һ�е���(n-1)����n-1�е���1���ֱ���Ϊ1 ~ n*(n-1)/2
    edgeset = randperm(MAX_EDGE_NUM,edgeNum); %��1~n * (n - 1)/2�У����ѡ��edgeNum����

    for index = 1:edgeNum
    %�ֱ��ҵ�edgeset(index)���������к����±꣬���������һ����
        row = 1;
        while edgeset(index) > rowLast(row)
            row = row + 1;
        end
    
    %��row�й���Tasknum - row����
        col = n - (rowLast(row) - edgeset(index));
    
        NetworkTopo(row, col) = 1;
        NetworkTopo(col, row) = 1;
    end

    for i=1:Servernum
        for j=1:Servernum
            if i==j
                continue;
            end
        
            if NetworkTopo(i,j) == 0
                Transferrate_network(i,j) = Transferrate_network(i,j) * NetworkTopo(i,j); %NetworkTopo(i,j)Ϊ1������������������ͨ��Ϊ0�Ļ�����ͨ
            end
        
        end
    end
    
    
    
    
    
    
    
    
   
    [preCache_p3,preTaskComputationSpeed_p3,preFinishTime_p3] = P3_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
    %[preCache_iwqos,preTaskComputationSpeed_iwqos,preFinishTime_iwqos] = P1_iwqos_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    [preCache_iwqos2,preTaskComputationSpeed_iwqos2,preFinishTime_iwqos2] = P1_iwqos_network_taskset(taskset,Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
    
    [preCache_infocom,preTaskComputationSpeed_infocom,preFinishTime_infocom] = P1_infocom_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);

    [~,~,preFinishTime_best] = P1_IterateNum_network(5000,Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
     ration(k)
%     y(k) = preFinishTime_p3;
%     y2(k) = preFinishTime_infocom;
%     y3(k) = preFinishTime_iwqos2;
%     y4(k) = preFinishTime_best;
    
         z(k,times) = preFinishTime_p3;
        z2(k,times) = preFinishTime_infocom;
        z3(k,times) = preFinishTime_iwqos2;
        z4(k,times) = preFinishTime_best;
        
    end 
end

for i = 1 : len
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

