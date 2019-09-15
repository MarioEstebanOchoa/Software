close all
path1 = 'data\01-Aug-2019\1\train_middle.mat';
path2 = 'data\01-Aug-2019\2\train_middle.mat';

load(path1);

plot3(output(:,2),output(:,3),output(:,4),'*')
hold on
load(path2);
plot3(output(:,2),output(:,3),output(:,4),'*')
legend({'dataset A','dataset B'},'Location','northeast');
xlabel('x position [mm]')
ylabel('y position [mm]')
zlabel('z position [mm]')
axis equal
grid on

load(path1);

output_filt = output(:,2:4);
output_filt = offset(output_filt);

figure
plot3(output_filt(:,1),output_filt(:,2),output_filt(:,3),'*')
hold on
load(path2);
output_filt = output(:,2:4);
output_filt = offset(output_filt);
plot3(output_filt(:,1),output_filt(:,2),output_filt(:,3),'*')
legend({'dataset A','dataset B'},'Location','northeast');

xlabel('x position [mm]')
ylabel('y position [mm]')
zlabel('z position [mm]')
axis equal
grid on
