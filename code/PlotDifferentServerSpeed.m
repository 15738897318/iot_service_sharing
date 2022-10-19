%server�ļ����ٶȱ仯���ص����û�����CPU�ٶ� �� server�ļ����ٶ� ֮��ı�ֵ������ѡ��ı�������ٶȶ����Ǳ����ٶ�
%PlotDifferentServerSpeed
%server�ļ����ٶ�̫�����ǻ�����ȫ���ڱ���ִ�У���Ϊ��serverִ�л�������ͨ���ӳ�
%����ûʹ������ű�������ͼ

Tasknum = 10;
Servernum = 2;
userNum = 2;

[ServerMemory,TaskMemory,Possionrate,Transferrate,Computespeed_Local,ComputeSpeed_server,EdgeWeight,TaskSize] = GenerateData(userNum,Servernum,Tasknum);
TaskMemory = normrnd(50 ,1,[1 Tasknum]);
ServerMemory =  normrnd(50*Tasknum*0.5/Servernum +25 ,1,[1 Servernum]);
%GenerateData��Computespeed_Local��Χ��(3,5) ����ֵ4

 Graph = GenarateGraphParalle(Tasknum,4); %���ж�4
 [Taskgraph,Graph] = GenarateGraphCommon(Graph,Tasknum,userNum,0.3); %��������ռ��0.3
 Taskgraph = FulFillTaskgraph(Taskgraph,EdgeWeight,TaskSize,userNum,Tasknum);
 
 ComputationSpeedRatio = [0.25,0.5, 1, 2, 4, 10, 15, 20, 25];
 [~,length] = size(ComputationSpeedRatio);
 for k = 1:length
     %low = 3 * Tasknum * cacheRation/Servernum * ComputationSpeedRatio
    ComputeSpeed_server = normrnd(4 * Tasknum*0.5/2 *ComputationSpeedRatio(k) ,1,[1 Servernum]);
    
    [preCache,preTaskComputationSpeed,preFinishTime] = P1_RankOnNum(Tasknum,userNum,Servernum,ServerMemory,TaskMemory,Possionrate,Taskgraph,Transferrate,Computespeed_Local,ComputeSpeed_server);
    
    k
    y(k) = preFinishTime;
     
 end
 
 plot(ComputationSpeedRatio,y)

 