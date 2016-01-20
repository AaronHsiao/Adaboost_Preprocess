N=xlsread('2001-2012.csv'); %讀取12年分K 所有資料
DD = 20; %delay decision 要自己改 找出最好的值
BH = 10; %buy and hold period 要自己改 找出最好的值
DBN = 100000; %KNN search space from n-1 to n-DBN
K = 10000; 
date1 = floor(N(:,1)/1000000); %每筆資料的日期(只取年月日), 後面被處理掉, 
date2 = union(date1,[]); %所有出現過的日期
F = []; %Feature過往1.5.10分鐘的報酬
T = []; % [往後BH分鐘報酬 延遲DD分鐘再往後BH分鐘的報酬]

%每天都去做
for i = 1 : length(date2)
    disp(i); %第幾天
    data = N(date1==date2(i),5); %取出每一欄
         
    %當天可以往前取出1,5,10 return
    F1 = [data(11 : length(data)-BH-DD)./data(10 : length(data)-BH-DD-1)-1 data(11 : length(data)-BH-DD)./data(6 : length(data)-BH-DD-5)-1 data(11 : length(data)-BH-DD)./data(1 : length(data)-BH-DD-10)-1];
    
    %當天往後可以取出1,20
    T1 = [data(11+BH : length(data)-BH-DD+BH)./data(11 : length(data)-BH-DD)-1 data(11+BH+DD : length(data)-BH-DD+BH+DD)./data(11+DD : length(data)-BH-DD+DD)-1];
    
    F = [F;F1]; %串接下去
    T = [T;T1]; %串接下去
end

R = zeros(size(F,1),1); %放結果的陣列

save status_BeforeKNN


%往前搜尋10萬筆，從裡面挑出最像之1萬筆，把選到最像的1萬筆的索引值存於idx
idx = knnsearch(F(1:DBN,:), F(DBN+1,:),'K', K); 
for i = 1:
    
end













%第1筆開始到760357
for i = DBN+1:size(F,1)
    
    if(mod(i,10000)==0)
        disp(i);
    end
    
    %往前搜尋10萬筆，從裡面挑出最像之1萬筆，把選到最像的1萬筆的索引值存於idx
    idx = knnsearch(F(i-DBN:i-1,:), F(i,:),'K', K); 
    
    %開一個新的陣列，存放往前10萬筆的資料，讓之後index可以正確找到對應的值
    T2 = T(i-DBN:i-1,:); 
    
    %把挑到的一萬筆最像之資料，拿去算技術指標
    if(sum(T2(idx,1)>0)>K/2)
        R(i) = T(i,1)-T(i,2);
    else
        R(i) = -T(i,1)+T(i,2); 
    end
end