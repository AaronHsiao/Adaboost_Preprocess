aaa = randn(5000,2)+repmat([4 4],[5000 1]);
aaa = [aaa;randn(3000,2).*repmat([1 3],[3000 1])+repmat([0 -3],[3000 1])];
RRR = [cosd(45) -sind(45);sind(45) cosd(45)];
aaa = [aaa;(RRR*(randn(2000,2).*repmat([1 4],[2000 1]))')'+repmat([-4 6],[2000 1])];
plot(aaa(:,1),aaa(:,2),'.b');