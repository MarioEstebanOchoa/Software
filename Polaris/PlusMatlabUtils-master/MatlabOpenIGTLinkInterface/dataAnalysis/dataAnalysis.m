clc
clear
close all

finger = "middle";
type_of_data = "random";

name_test_day = '01-Aug-2019';
test_day_path = ['..\data\' name_test_day '\offset'];
path = [test_day_path '\' char(finger) '_' char(type_of_data) '.txt'];
data=dlmread(path,',');

a = data(data(:,1)==1,[3:5 7:9]);
b = data(data(:,1)==2,[3:5 7:9]);
c = data(data(:,1)==3,[3:5 7:9]);
d = data(data(:,1)==4,[3:5 7:9]);
e = data(data(:,1)==5,[3:5 7:9]);

A3t = [a(:,3) b(:,3) c(:,3) d(:,3) e(:,3)];
A3 = [a(:,6) b(:,6) c(:,6) d(:,6) e(:,6)];


figure
boxplot(A3)

% [N,edges] = histcounts(A3);
% 
% figure
% hist3(A3)

[m,n] = size(A3);
x = 0:.1:40;
figure
for i = 1:n-1
    cf = A3(:,i);
    ds = datastats(cf);
    mu = ds.mean;
    sigma = ds.std;
    %pd = makedist('Normal','mu',mu,'sigma',sigma);
    pd = fitdist(cf, 'normal');
    y = pdf(pd,x);
    plot(x, y,'LineWidth',1.5)
    hold on
%     histogram(cf)%,'Normalization','pdf')
%     hold on
end
legend('a','b','c','d','e')