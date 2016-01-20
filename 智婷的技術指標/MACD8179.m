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
    
    


    DI8179 = zeros(length(index),35);     
    EMA8 = zeros(length(index),27);
    EMA17 = zeros(length(index),19);
    DIF = zeros(length(index),19);
    Total8=zeros(length(index),1);
    Total17=zeros(length(index),1);
    Total9=zeros(length(index),1);
    MACDP = zeros(length(index),11);

    

        %算35天DI
        for n = 1 : 35
            
            DI8179(index,n) = ((2*AP(index,m+n-1))+APH(index,m+n-1)+APL(index,m+n-1))./4;
                   
        end
        
        
        %算8天EMA
        for n = 1:8
            
             Total8 = Total8 + DI8179(index,27+n) ;
        end
        
        EMA8(index,28)=Total8/8;
        
       for n = 27:-1:1
            
            EMA8(index,n) = (EMA8(index,n+1)*11+ DI8179(index,n)*2)/13;
            
       end
        
        %算17天EMA
       for n = 1:17
            
             Total17 = Total17 + DI8179(index,18+n) ;
        end
        
        EMA17(index,19)=Total17/17;
        
       for n = 18:-1:1
            
         EMA17(index,n) = (EMA17(index,n+1)*11+ DI8179(index,n)*2)/13;
            
       end
       
    
       %算DIF
               
        for n = 19:-1:1
            
            DIF(index,n) =EMA8(index,n)-EMA17(index,n);
        
        end
      
         %算MACD
         
         
       for n = 1:9
            
           Total9 = Total9 + DIF(index,n+10) ;
       end
    
         MACDP(index,11) = Total9/9;
   
        for n = 10:-1:1
            
         MACDP(index,n) = (MACDP(index,n+1)*8+DIF(index,n)*2)/10;
            
       end
         
         
    
    m2d = [MACDP(index,1)]; % (return 特徵值:[週])

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
