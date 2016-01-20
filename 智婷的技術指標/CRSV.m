% 實驗組C(RSI[週])  
load SP500;

year = 2000;
n=length(find(SP500(1).data(:,1)>20000000));
APL=ones(length(SP500),n)*-1;
APH=ones(length(SP500),n)*-1;
AP=ones(length(SP500),n)*-1;

day = SP500(1).data(1:n,1)';

for i=1:length(SP500)
    AP(i,1:min(n,length(SP500(i).data(:,1)))) = SP500(i).data(1:min(n,length(SP500(i).data(:,1))),5)';
    APH(i,1:min(n,length(SP500(i).data(:,1)))) = SP500(i).data(1:min(n,length(SP500(i).data(:,1))),3)';
    APL(i,1:min(n,length(SP500(i).data(:,1)))) = SP500(i).data(1:min(n,length(SP500(i).data(:,1))),4)';

end  
 

target = [];
for i = 2001 : 2015
    for j = 1 : 12
        target = [target i*10000+j*100];
    end
end
target(end-3:end) = [];

PN=10;
FutureDay=20; %未來5,10,20天的波動率
PerDay=9;   



center=ones(15,length(target))*0;

for i=1:length(target)
    index=find(day>target(i));
    m=index(end);
    index=find(AP(:,m+PerDay)~=-1);
    
    RSV = zeros(length(index),1);
    
    RSV = ((AP(index,m)-min(APL(index,m:m+PerDay)')')./(max(APH(index,m:m+PerDay)')'-min(APL(index,m:m+PerDay)')'))*100;
    
    m2d = [RSV]; % (return 特徵值:[週])

     sim = zeros(length(index),length(index));
    
    for m = 1 : length(index)
        for n = 1 : length(index)
            
             % Return
            x=m2d(m,:);
            y=m2d(n,:);
           
            sim(m,n)= -abs(x-y); % 價格差取負號
        
        end
    end
    
    p = ones(length(index),1).*(median(sim(:)).*3); % Perefence 權重
  
   [idx,netsim,dpsim,expref]=apcluster(sim,p);

   TAB = tabulate(index(idx));  
   %表格　ｖａｌｕｅ（值），ｃｏｕｎｔ（出現次數），ｐｅｒｃｅｎｔ（佔百分比）　
   
   [B,IX]=sortrows(TAB,2);
   TenCenterNode = B(length(TAB)-9:length(TAB),1); %10間主要中心點
   
   var(i)=std(mean(AP(TenCenterNode,m-FutureDay:m-1)./AP(TenCenterNode,m-FutureDay+1:m)-1));
   
  % a = unique(index(idx));
  % center(1:length(unique(index(idx))),i) = a;
   disp(i);

end


format long;finres = mean(var);


k=1;

for i=1:length(target)
   
    if(rem(i,12)==0)
        avgyear2(k)=mean(var(i-11:i));
         disp(k);
        disp(avgyear2(k));
        k=k+1;
    end
    
end
