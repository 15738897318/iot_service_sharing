%Plot_ComputionTime_CDF
%ʹ�õ���code_v1.6/data/TaskNumToServerNumRation_data2��������������������㷨�Ļ���ͼ�����Դ������������������Ϊ600ʱ�Ľ��


Possionrate_sum = zeros(1,Tasknum);
for j=1:userNum
    for i=1:Tasknum
        if Taskgraph(i,i,j) ~= 0
            Possionrate_sum(i) = Possionrate_sum(i) + Possionrate(j);
        end
    end
end


%�ȼ���P3��
Cache = preCache_p3;
TaskComputationSpeed = preTaskComputationSpeed_p3;

%����Cachelocation��Cachestatus
Cachelocation = zeros(1,Tasknum);%Cachelocation(i)��ʾ����i�����浽��̨��������0��ʾû������
Cachestatus = zeros(1,Tasknum);%0��ʾû�����棬1��ʾû�м�����Դ������2��ʾ���ڼ�����Դ����
for j=1:Servernum
    count = 0; %��j̨��Ե�����������˼�����������
    for i=1:Tasknum
        if Cache(i,j) == 1
            count = count + 1;
        end
    end
    
    for i=1:Tasknum
        if Cache(i,j) == 1
            Cachelocation(i) = j;
            if count == 1
                Cachestatus(i) = 1;
            else
                Cachestatus(i) = 2;
            end
        end
    end
end

ComputationTime_p3 = zeros(1,Tasknum);

for i=1:Tasknum
    if(Cachelocation(i) == 0)%����i�ڱ���ִ��
        for k = 1:userNum
            if(Taskgraph(i, i, k) == 0)
                continue;
            end
            
             r = Computespeed_Local(i,k); %��k������CPU�Ե�i������ı��ش����ٶ�
             B = TaskSize(i);
             time = 1/(r/B - Possionrate(k));
             
             ComputationTime_p3(i) = ComputationTime_p3(i) + time*Possionrate(k)/Possionrate_sum(i);
        end
        
    else %����i�ڷ�������ִ�У��ٶȴ�TaskComputationSpeed�л�ȡ
        ComputationTime_p3(i) = 1/((TaskComputationSpeed(i)/TaskSize(i)) - Possionrate_sum(i));      
    end   
    
end




%�ټ���infocom��------------------------------------------------------------------
Cache = preCache_infocom;
TaskComputationSpeed = preTaskComputationSpeed_infocom;

%����Cachelocation��Cachestatus
Cachelocation = zeros(1,Tasknum);%Cachelocation(i)��ʾ����i�����浽��̨��������0��ʾû������
Cachestatus = zeros(1,Tasknum);%0��ʾû�����棬1��ʾû�м�����Դ������2��ʾ���ڼ�����Դ����
for j=1:Servernum
    count = 0; %��j̨��Ե�����������˼�����������
    for i=1:Tasknum
        if Cache(i,j) == 1
            count = count + 1;
        end
    end
    
    for i=1:Tasknum
        if Cache(i,j) == 1
            Cachelocation(i) = j;
            if count == 1
                Cachestatus(i) = 1;
            else
                Cachestatus(i) = 2;
            end
        end
    end
end

ComputationTime_infocom = zeros(1,Tasknum);

for i=1:Tasknum
    if(Cachelocation(i) == 0)%����i�ڱ���ִ��
        for k = 1:userNum
            if(Taskgraph(i, i, k) == 0)
                continue;
            end
            
             r = Computespeed_Local(i,k); %��k������CPU�Ե�i������ı��ش����ٶ�
             B = TaskSize(i);
             time = 1/(r/B - Possionrate(k));
             
             ComputationTime_infocom(i) = ComputationTime_infocom(i) + time*Possionrate(k)/Possionrate_sum(i);
        end
        
    else %����i�ڷ�������ִ�У��ٶȴ�TaskComputationSpeed�л�ȡ
        ComputationTime_infocom(i) = 1/((TaskComputationSpeed(i)/TaskSize(i)) - Possionrate_sum(i));      
    end   
    
end



%������iwqos��------------------------------------------------------------------
Cache = preCache_iwqos;
TaskComputationSpeed = preTaskComputationSpeed_iwqos;

%����Cachelocation��Cachestatus
Cachelocation = zeros(1,Tasknum);%Cachelocation(i)��ʾ����i�����浽��̨��������0��ʾû������
Cachestatus = zeros(1,Tasknum);%0��ʾû�����棬1��ʾû�м�����Դ������2��ʾ���ڼ�����Դ����
for j=1:Servernum
    count = 0; %��j̨��Ե�����������˼�����������
    for i=1:Tasknum
        if Cache(i,j) == 1
            count = count + 1;
        end
    end
    
    for i=1:Tasknum
        if Cache(i,j) == 1
            Cachelocation(i) = j;
            if count == 1
                Cachestatus(i) = 1;
            else
                Cachestatus(i) = 2;
            end
        end
    end
end

ComputationTime_iwqos = zeros(1,Tasknum);

for i=1:Tasknum
    if(Cachelocation(i) == 0)%����i�ڱ���ִ��
        for k = 1:userNum
            if(Taskgraph(i, i, k) == 0)
                continue;
            end
            
             r = Computespeed_Local(i,k); %��k������CPU�Ե�i������ı��ش����ٶ�
             B = TaskSize(i);
             time = 1/(r/B - Possionrate(k));
             
             ComputationTime_iwqos(i) = ComputationTime_iwqos(i) + time*Possionrate(k)/Possionrate_sum(i);
        end
        
    else %����i�ڷ�������ִ�У��ٶȴ�TaskComputationSpeed�л�ȡ
        ComputationTime_iwqos(i) = 1/((TaskComputationSpeed(i)/TaskSize(i)) - Possionrate_sum(i));      
    end   
    
end

cdfplot(ComputationTime_p3);
%cdfplot(ComputationTime_infocom);
%cdfplot(ComputationTime_iwqos);

