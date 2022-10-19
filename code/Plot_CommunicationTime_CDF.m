%Plot_CommunicationTime_CDF
%ȥ��Plot_ComputionTime_CDF��ע�ͣ�ʹ�õ���һ�����ݣ�����ǻ���ͨ��ʱ���CDF
%��ҵ���ļ���������CDF

Possionrate_sum = zeros(1,Tasknum);
for j=1:userNum
    for i=1:Tasknum
        if Taskgraph(i,i,j) ~= 0
            Possionrate_sum(i) = Possionrate_sum(i) + Possionrate(j);
        end
    end
end

%�õ��ϳɺ��DAG
Graph = zeros(Tasknum,Tasknum);
for k=1:userNum
    for i=1:Tasknum
        for j = 1:Tasknum
            if i==j
                Graph(i,j) = 1;
                continue;
            end
            
            if Taskgraph(i,j,k) ~= 0
                Graph(i,j) = Taskgraph(i,j,k);
            end
                
        end 
    end
end




%�ȼ���P3��-------------------------------------------------
Cache = preCache_p3;

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

CommunicationTime_P3 = zeros(1,0);
for i=1:(Tasknum-1)
    for j=(i+1):Tasknum
        if Graph(i,j) == 0
            continue;
        end
        
        locali = Cachelocation(i);
        localj = Cachelocation(j);
        
        if (locali == localj)
            CommunicationTime_P3(end + 1) = 0;
        elseif locali ~= 0 && localj~=0
            data = EdgeWeight(i,j)/Transferrate(locali,localj);
            if Transferrate_network(locali,localj) == 0
                data = 2*data;
            end
            CommunicationTime_P3(end + 1) = data;
        elseif locali == 0
            temp = 0;
            for k=1:userNum
                if(Taskgraph(i,i,k) == 0)
                    continue;
                end
                
                temp = temp + (EdgeWeight(i,j)/Transferrate(Servernum+k, localj)) * Possionrate(k)/Possionrate_sum(i);
            end
            CommunicationTime_P3(end + 1) = temp;
        else
            temp = 0;
            for k=1:userNum
                if(Taskgraph(j,j,k) == 0)
                    continue;
                end
                
                temp = temp + (EdgeWeight(i,j)/Transferrate(locali,Servernum+k)) * Possionrate(k)/Possionrate_sum(j);
            end
            CommunicationTime_P3(end + 1) = temp;
        end
    end
end


%�ٴ���infocom--------------------------
Cache = preCache_infocom;

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

CommunicationTime_infocom = zeros(1,0);
for i=1:(Tasknum-1)
    for j=(i+1):Tasknum
        if Graph(i,j) == 0
            continue;
        end
        
        locali = Cachelocation(i);
        localj = Cachelocation(j);
        
        if (locali == localj)
            CommunicationTime_infocom(end + 1) = 0;
        elseif locali ~= 0 && localj~=0
            data = EdgeWeight(i,j)/Transferrate(locali,localj);
            if Transferrate_network(locali,localj) == 0
                data = 2*data;
            end
            CommunicationTime_infocom(end + 1) = data;
        elseif locali == 0
            temp = 0;
            for k=1:userNum
                if(Taskgraph(i,i,k) == 0)
                    continue;
                end
                
                temp = temp + (EdgeWeight(i,j)/Transferrate(Servernum+k, localj)) * Possionrate(k)/Possionrate_sum(i);
            end
            CommunicationTime_infocom(end + 1) = temp;
        else
            temp = 0;
            for k=1:userNum
                if(Taskgraph(j,j,k) == 0)
                    continue;
                end
                
                temp = temp + (EdgeWeight(i,j)/Transferrate(locali,Servernum+k)) * Possionrate(k)/Possionrate_sum(j);
            end
            CommunicationTime_infocom(end + 1) = temp;
        end
    end
end

%������iwqos---------------------------------
Cache = preCache_iwqos;

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

CommunicationTime_iwqos = zeros(1,0);
for i=1:(Tasknum-1)
    for j=(i+1):Tasknum
        if Graph(i,j) == 0
            continue;
        end
        
        locali = Cachelocation(i);
        localj = Cachelocation(j);
        
        if (locali == localj)
            CommunicationTime_iwqos(end + 1) = 0;
        elseif locali ~= 0 && localj~=0
            data = EdgeWeight(i,j)/Transferrate(locali,localj);
            if Transferrate_network(locali,localj) == 0
                data = 2*data;
            end
            CommunicationTime_iwqos(end + 1) = data;
        elseif locali == 0
            temp = 0;
            for k=1:userNum
                if(Taskgraph(i,i,k) == 0)
                    continue;
                end
                
                temp = temp + (EdgeWeight(i,j)/Transferrate(Servernum+k, localj)) * Possionrate(k)/Possionrate_sum(i);
            end
            CommunicationTime_iwqos(end + 1) = temp;
        else
            temp = 0;
            for k=1:userNum
                if(Taskgraph(j,j,k) == 0)
                    continue;
                end
                
                temp = temp + (EdgeWeight(i,j)/Transferrate(locali,Servernum+k)) * Possionrate(k)/Possionrate_sum(j);
            end
            CommunicationTime_iwqos(end + 1) = temp;
        end
    end
end

