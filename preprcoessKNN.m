N=xlsread('2001-2012.csv'); %Ū��12�~��K �Ҧ����
DD = 20; %delay decision �n�ۤv�� ��X�̦n����
BH = 10; %buy and hold period �n�ۤv�� ��X�̦n����
DBN = 100000; %KNN search space from n-1 to n-DBN
K = 10000; 
date1 = floor(N(:,1)/1000000); %�C����ƪ����(�u���~���), �᭱�Q�B�z��, 
date2 = union(date1,[]); %�Ҧ��X�{�L�����
F = []; %Feature�L��1.5.10���������S
T = []; % [����BH�������S ����DD�����A����BH���������S]

%�C�ѳ��h��
for i = 1 : length(date2)
    disp(i); %�ĴX��
    data = N(date1==date2(i),5); %���X�C�@��
         
    %��ѥi�H���e���X1,5,10 return
    F1 = [data(11 : length(data)-BH-DD)./data(10 : length(data)-BH-DD-1)-1 data(11 : length(data)-BH-DD)./data(6 : length(data)-BH-DD-5)-1 data(11 : length(data)-BH-DD)./data(1 : length(data)-BH-DD-10)-1];
    
    %��ѩ���i�H���X1,20
    T1 = [data(11+BH : length(data)-BH-DD+BH)./data(11 : length(data)-BH-DD)-1 data(11+BH+DD : length(data)-BH-DD+BH+DD)./data(11+DD : length(data)-BH-DD+DD)-1];
    
    F = [F;F1]; %�걵�U�h
    T = [T;T1]; %�걵�U�h
end

R = zeros(size(F,1),1); %�񵲪G���}�C

save status_BeforeKNN


%���e�j�M10�U���A�q�̭��D�X�̹���1�U���A����̹���1�U�������ޭȦs��idx
idx = knnsearch(F(1:DBN,:), F(DBN+1,:),'K', K); 
for i = 1:
    
end













%��1���}�l��760357
for i = DBN+1:size(F,1)
    
    if(mod(i,10000)==0)
        disp(i);
    end
    
    %���e�j�M10�U���A�q�̭��D�X�̹���1�U���A����̹���1�U�������ޭȦs��idx
    idx = knnsearch(F(i-DBN:i-1,:), F(i,:),'K', K); 
    
    %�}�@�ӷs���}�C�A�s�񩹫e10�U������ơA������index�i�H���T����������
    T2 = T(i-DBN:i-1,:); 
    
    %��D�쪺�@�U���̹�����ơA���h��޳N����
    if(sum(T2(idx,1)>0)>K/2)
        R(i) = T(i,1)-T(i,2);
    else
        R(i) = -T(i,1)+T(i,2); 
    end
end