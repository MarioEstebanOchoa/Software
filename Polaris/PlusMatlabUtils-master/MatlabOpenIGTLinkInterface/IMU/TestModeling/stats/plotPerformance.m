%close all
finger = "thumb1";
name = ['stats_imu_' char(finger) '_model.txt'];

data = dlmread(name);

p1 = data(1:10,:);
p2 = data(11:20,:);

figure
plot(p1(:,1),'-*');
hold on
plot(p2(:,1),'-*');
legend('peridic data','random data')
xlabel('# of hidden neurons')
ylabel('Performance: MSE')
grid on