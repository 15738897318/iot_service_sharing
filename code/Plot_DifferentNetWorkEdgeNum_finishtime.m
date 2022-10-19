%Plot_DifferentNetWorkEdgeNum_finishtime  2021.7.25�ӵ�ʵ��
%��ʵ��Plot_DifferentNetWorkEdgeNum�����᲻ͬ������Ϊ���ʱ��С��ĳ��ֵ��user�������������õ���P3_network_addFinishtime,�ú������صĵ��ĸ�������ÿ��dag�����ʵ�����ʱ��
%��һ��ʱ����ֵ
threshold = 0;%ʱ����ֵ�����ܳ����Ľ���У���ʱ�������������


%GenerateData_Network��һ��������������֮��ı�����ͬ
%��������������������������ͼ Network Connectivity �������������̶���ƽ��ÿ����������ͨ�ȣ��������仯

% userNum = 50;
% Servernum = 30; %���30 * 29/2���Ƿ�����������14.5��
% Tasknum = 100;
% ration = [2,5,8,10,12,14];
userNum = 25;
Servernum = 8; %���30 * 29/2���Ƿ�����������14.5��
Tasknum = 35;
ration = [1,1.5,2,2.5,3];

len = length(ration);

Graph = GenarateGraphParalle(Tasknum,round(Tasknum*0.4));%���ж�
[Taskgraph,Graph] = GenarateGraphCommon_2(Graph,Tasknum,userNum,0.3); %��������ռ��0.3


[ServerMemory,TaskMemory,Possionrate,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server,EdgeWeight,TaskSize] = GenerateData_NetworkConnect(round(Servernum*(Servernum-1)/4),userNum,Servernum,Tasknum);
Taskgraph = FulFillTaskgraph(Taskgraph,EdgeWeight,TaskSize,userNum,Tasknum);

taskset = randperm(Tasknum,Tasknum);

y_a = zeros(1, len);
y2_a = zeros(1, len);
y3_a = zeros(1,len);
y4_a = zeros(1, len);

maxtime = 20;
for times = 1 : maxtime%ע�⣡���������������ظ����飬�����Ҫ���Դ���


%for k=1:len
for k=len:-1:1%�Ӵ���Сȡ
    
%     for kk = 1:20
    
    edgeNum = Servernum * ration(k);
    
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
    
    
   
    [preCache_p3,preTaskComputationSpeed_p3,preFinishTime_p3, taskFinishTime_p3] = P3_network_addFinishtime(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    
%     %��̬����thresholdʱ����ֵ
%     if k==len
%         threshold = max(taskFinishTime_p3);
%     end
    
    count = 0;
    for index = 1:userNum
        if taskFinishTime_p3(index) <= threshold
            count = count + 1;
        end
    end
    y_a(k) = y_a(k)+ count;
    
    %%[preCache_iwqos,preTaskComputationSpeed_iwqos,preFinishTime_iwqos] = P1_iwqos_network(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    [preCache_iwqos2,preTaskComputationSpeed_iwqos2,preFinishTime_iwqos2, taskFinishTime_iwqos2] = P1_iwqos_network_taskset_addFinishtime(taskset,Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    count3 = 0;
    for index = 1:userNum
        if taskFinishTime_iwqos2(index) <= threshold
            count3 = count3 + 1;
        end
    end
    y3_a(k) = y3_a(k) + count3;
    
    [preCache_infocom,preTaskComputationSpeed_infocom,preFinishTime_infocom, taskFinishTime_infocom] = P1_infocom_network_addFinishtime(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Transferrate_network,Computespeed_Local,ComputeSpeed_server);
    count2 = 0;
    for index = 1:userNum
        if taskFinishTime_infocom(index) <= threshold
            count2 = count2 + 1;
        end
    end
    y2_a(k) = y2_a(k)+count2;
    
 
    
    
    
    %ration(k)
    %y(k) = preFinishTime_p3;
    %y2(k) = preFinishTime_infocom;
    %%y3(k) = preFinishTime_iwqos;
    %y4(k) = preFinishTime_iwqos2;
    

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

%plot(ration,y);
%hold on;
%plot(ration,y2);
%%plot(ration,y3);
%plot(ration,y4);
