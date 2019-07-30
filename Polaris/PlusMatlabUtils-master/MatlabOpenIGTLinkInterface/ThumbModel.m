timesToTrain = 5;
datasetToCompute = 5;
dstc = 1;

training = true;
testing = true;
p_plot = false;

name_test_day = '29-Jul-2019';

test_day_path = ['data\' name_test_day];

f = fopen([test_day_path '\thumb.txt'],'at');

%fprintf(f,'folder,err_independant_train,err_all_dimenssion_regression_train,err_time_series_train,dataset,err_indep_regression_test_t,err_regression_test_t,err_time_series_test_t\n');

for k = 1:5
for i=1:timesToTrain

    
%clear 
%clc
close all



%% Load and filtering
folder = k;

delay = 2;

n_hidden = [10 10 10];
hidden_all = 10;
hidden_time = 10; %time series

if training

path = [test_day_path '\' num2str(folder) '\train_thumb.mat'];

load(path);

input1(:,2) = input1(:,2)*100/5;  % map 0-5 Volts to 0-100
input2(:,2) = input2(:,2)*100/5;  % map 0-5 Volts to 0-100

timestamp = output(:,1);
input1_filt = SimpleKalmanFilter(input1(:,2), input1(1,2), 1, 1, 2);
input2_filt = SimpleKalmanFilter(input2(:,2), input2(1,2), 1, 1, 2);

output_x_filt = SimpleKalmanFilter(output(:,2), output(1,2), 1, 1, 2);
output_y_filt = SimpleKalmanFilter(output(:,3), output(1,3), 1, 1, 2);
output_z_filt = SimpleKalmanFilter(output(:,4), output(1,4), 1, 1, 2);

if p_plot
    figure
    plot(timestamp,output(:,2))
    hold on
    plot(timestamp,output(:,3))
    plot(timestamp,output(:,4))
    title('RAW POLARIS DATA')
    legend({'x position','y position','z position'},'Location','northeast');
    xlabel('[sec]')
    ylabel('[mm]')
    grid on
    
    figure
    plot3(output(:,2),output(:,3),output(:,4),'*')
    title('3D raw position Polaris Sensor')
    xlabel('x position [mm]')
    ylabel('y position [mm]')
    zlabel('z position [mm]')
    axis equal
    axis([0 75 0 80 -50 0])
    grid on
    
    figure
    subplot(5,1,1)
    plot(timestamp,input1(:,2));
    hold on
    plot(timestamp,input1_filt);
    title('DATA FILTERING')
    legend({'measured','filtered'},'Location','northeast');
    xlabel('flex sensor 1')
    
    subplot(5,1,2)
    plot(timestamp,input2(:,2));
    hold on
    plot(timestamp,input2_filt);
    legend({'measured','filtered'},'Location','northeast');
    xlabel('flex sensor 2')

    subplot(5,1,3)
    plot(timestamp,output(:,2))
    hold on
    plot(timestamp,output_x_filt)
    legend({'measured','filtered'},'Location','northeast');
    xlabel('x position')
    ylabel('position [mm]')

    subplot(5,1,4)
    plot(timestamp,output(:,3))
    hold on
    plot(timestamp,output_y_filt)
    legend({'measured','filtered'},'Location','northeast');
    xlabel('y position')
    ylabel('position [mm]')

    subplot(5,1,5)
    plot(timestamp,output(:,4))
    hold on
    plot(timestamp,output_z_filt)
    legend({'measured','filtered'},'Location','northeast');
    xlabel('z position')
    ylabel('position [mm]')
end

real_pos = [output_x_filt output_y_filt output_z_filt];

%% Training and testing, fitting function, regression
% Training each dimension independantly 

input_filt = [input1_filt input2_filt];

x_pred = train_prediction(input_filt,output_x_filt,n_hidden(1,1),'flex_thumb_x');
y_pred = train_prediction(input_filt,output_y_filt,n_hidden(1,2),'flex_thumb_y');
z_pred = train_prediction(input_filt,output_z_filt,n_hidden(1,3),'flex_thumb_z');

if p_plot
figure
subplot(4,1,1)
plot(timestamp,input_filt)
title('REGRESSION TRAIN ON EACH DIMENSION')
legend({'flex 1','flex 2'},'Location','northeast');
xlabel('flex sensor value')

subplot(4,1,2)
plot(timestamp,output_x_filt)
hold on
plot(timestamp,x_pred)
legend({'real value','prediction'},'Location','northeast');
xlabel('x position prediction')
ylabel('position [mm]')

subplot(4,1,3)
plot(timestamp,output_y_filt)
hold on
plot(timestamp,y_pred)
legend({'real value','prediction'},'Location','northeast');
xlabel('y position prediction')
ylabel('position [mm]')

subplot(4,1,4)
plot(timestamp,output_z_filt)
hold on
plot(timestamp,z_pred)
legend({'real value','prediction'},'Location','northeast');
xlabel('z position prediction')
ylabel('position [mm]')
end

pred_pos = [x_pred' y_pred' z_pred'];

if p_plot
figure
plot3(real_pos(:,1),real_pos(:,2),real_pos(:,3),'*')
hold on
plot3(pred_pos(:,1),pred_pos(:,2),pred_pos(:,3),'*')
title('3D position prediction train on each dimension')
legend({'real value','prediction'},'Location','northeast');
xlabel('x position [mm]')
ylabel('y position [mm]')
zlabel('z position [mm]')
axis equal
end

err_independant_train = immse(real_pos,pred_pos)


%% %Training all dimmensions at once

all_pred = train_prediction(input_filt,real_pos, hidden_all,'flex_thumb')';

if p_plot
figure
subplot(4,1,1)
plot(timestamp,input_filt)
title('REGRESSION TRAIN ON ALL DIMENSIONS')
xlabel('flex sensor value')

subplot(4,1,2)
plot(timestamp,output_x_filt)
hold on
plot(timestamp,all_pred(:,1))
legend({'real value','prediction'},'Location','northeast');
xlabel('x position prediction')
ylabel('position [mm]')


subplot(4,1,3)
plot(timestamp,output_y_filt)
hold on
plot(timestamp,all_pred(:,2))
legend({'real value','prediction'},'Location','northeast');
xlabel('y position prediction')
ylabel('position [mm]')


subplot(4,1,4)
plot(timestamp,output_z_filt)
hold on
plot(timestamp,all_pred(:,3))
legend({'real value','prediction'},'Location','northeast');
xlabel('z position prediction')
ylabel('position [mm]')

figure
plot3(real_pos(:,1),real_pos(:,2),real_pos(:,3),'*')
hold on
plot3(all_pred(:,1),all_pred(:,2),all_pred(:,3),'*')
title('3D position prediction all dimensions')
legend({'real value','prediction'},'Location','northeast');
xlabel('x position [mm]')
ylabel('y position [mm]')
zlabel('z position [mm]')
axis equal
end

err_all_dimenssion_regression_train = immse(real_pos,all_pred)

%% Training and testing, time series
all_pred_time = train_prediction_time(input_filt,real_pos, hidden_time, delay,'flex_thumb_time')';
%all_pred_time = [zeros(delay, 3);all_pred_time];
real_pos = real_pos(delay+1:end,:); 

if p_plot
figure
subplot(4,1,1)
plot(timestamp,input_filt)
title('TIME SERIES TRAIN ON ALL DIMENSIONS')
xlabel('flex sensor value')

subplot(4,1,2)
plot(timestamp(delay+1:end,:),real_pos(:,1))
hold on
plot(timestamp(delay+1:end,:),all_pred_time(:,1))
legend({'real value','prediction'},'Location','northeast');
xlabel('x position prediction')
ylabel('position [mm]')

subplot(4,1,3)
plot(timestamp(delay+1:end,:),real_pos(:,2))
hold on
plot(timestamp(delay+1:end,:),all_pred_time(:,2))
legend({'real value','prediction'},'Location','northeast');
xlabel('y position prediction')
ylabel('position [mm]')

subplot(4,1,4)
plot(timestamp(delay+1:end,:),real_pos(:,3))
hold on
plot(timestamp(delay+1:end,:),all_pred_time(:,3))
legend({'real value','prediction'},'Location','northeast');
xlabel('z position prediction')
ylabel('position [mm]')


figure
plot3(real_pos(:,1),real_pos(:,2),real_pos(:,3),'*')
hold on
plot3(all_pred_time(:,1),all_pred_time(:,2),all_pred_time(:,3),'*')
title('3D position prediction all dimensions')
legend({'real value','prediction'},'Location','northeast');
xlabel('x position [mm]')
ylabel('y position [mm]')
zlabel('z position [mm]')
axis equal
end

err_time_series_train = immse(real_pos,all_pred_time)


end

for j=dstc:datasetToCompute
fprintf(f,[num2str(folder) ',' num2str(err_independant_train) ',' num2str(err_all_dimenssion_regression_train) ',' num2str(err_time_series_train) ',']);

%% Test with unseen data
fprintf(f, [num2str(j) ',']);
if testing
test_day_path = ['data\' name_test_day];

path = [test_day_path '\' num2str(j) '\test_thumb.mat'];

load(path);

input1(:,2) = input1(:,2)*100/5;  % map 0-5 Volts to 0-100
input2(:,2) = input2(:,2)*100/5;  % map 0-5 Volts to 0-100
timestamp = output(:,1);
input1_filt = SimpleKalmanFilter(input1(:,2), input1(1,2), 1, 1, 2);
input2_filt = SimpleKalmanFilter(input2(:,2), input2(1,2), 1, 1, 2);
output_x_filt = SimpleKalmanFilter(output(:,2), output(1,2), 1, 1, 2);
output_y_filt = SimpleKalmanFilter(output(:,3), output(1,3), 1, 1, 2);
output_z_filt = SimpleKalmanFilter(output(:,4), output(1,4), 1, 1, 2);

real_pos = [output_x_filt output_y_filt output_z_filt];
input_filt = [input1_filt input2_filt];


x_pred = flex_thumb_x(input_filt')';
y_pred = flex_thumb_y(input_filt')';
z_pred = flex_thumb_z(input_filt')';
indep_pred_regression = [x_pred y_pred z_pred];
err_indep_regression_test_t = immse(real_pos,indep_pred_regression)
fprintf(f,[num2str(err_indep_regression_test_t) ',']);


if p_plot
figure
plot3(real_pos(:,1),real_pos(:,2),real_pos(:,3),'*')
hold on
plot3(indep_pred_regression(:,1),indep_pred_regression(:,2),indep_pred_regression(:,3),'*')
title('3D position prediction unseen samples regression indep')
legend({'real value','prediction'},'Location','northeast');
xlabel('x position [mm]')
ylabel('y position [mm]')
zlabel('z position [mm]')
axis equal
end

prediction_regression = flex_thumb(input_filt')';
err_regression_test_t = immse(real_pos,prediction_regression)
fprintf(f,[num2str(err_regression_test_t) ',']);

if p_plot
figure
plot3(real_pos(:,1),real_pos(:,2),real_pos(:,3),'*')
hold on
plot3(prediction_regression(:,1),prediction_regression(:,2),prediction_regression(:,3),'*')
title('3D position prediction unseen samples regression')
legend({'real value','prediction'},'Location','northeast');
xlabel('x position [mm]')
ylabel('y position [mm]')
zlabel('z position [mm]')
axis equal
end


% err_regression_test = immse(real_pos(:,1),prediction_regression(:,1))
% err_regression_test1 = immse(real_pos(:,2),prediction_regression(:,2))
% err_regression_test2 = immse(real_pos(:,3),prediction_regression(:,3))

prediction_time_series = test_time_series(input_filt,real_pos, hidden_time, delay, 'flex_thumb_time');
%prediction_time_series = [zeros(delay, 3);prediction_time_series];

real_pos = real_pos(delay+1:end,:); 


err_time_series_test_t = immse(real_pos,prediction_time_series)
fprintf(f,[num2str(err_time_series_test_t) '\n']);

% err_time_series_test = immse(real_pos(:,1),prediction_time_series(:,1))
% err_time_series_test1 = immse(real_pos(:,2),prediction_time_series(:,2))
% err_time_series_test2 = immse(real_pos(:,3),prediction_time_series(:,3))


if p_plot
figure
plot3(real_pos(:,1),real_pos(:,2),real_pos(:,3),'*')
hold on
plot3(prediction_time_series(:,1),prediction_time_series(:,2),prediction_time_series(:,3),'*')
title('3D position prediction unseen samples time series')
legend({'real value','prediction'},'Location','northeast');
xlabel('x position [mm]')
ylabel('y position [mm]')
zlabel('z position [mm]')
axis equal


figure
subplot(4,1,1)
plot(timestamp,input_filt)
title('PREDICTIONS WITH UNSEEN SAMPLES')
xlabel('flex sensor value')

subplot(4,1,2)
plot(timestamp(delay+1:end,:),real_pos(:,1))
hold on
plot(timestamp,prediction_regression(:,1))
plot(timestamp(delay+1:end,:),prediction_time_series(:,1))
legend({'real value','regression','time series'},'Location','northeast');
xlabel('x position prediction')
ylabel('position [mm]')

subplot(4,1,3)
plot(timestamp(delay+1:end,:),real_pos(:,2))
hold on
plot(timestamp,prediction_regression(:,2))
plot(timestamp(delay+1:end,:),prediction_time_series(:,2))
legend({'real value','regression','time series'},'Location','northeast');
xlabel('y position prediction')
ylabel('position [mm]')

subplot(4,1,4)
plot(timestamp(delay+1:end,:),real_pos(:,3))
hold on
plot(timestamp,prediction_regression(:,3))
plot(timestamp(delay+1:end,:),prediction_time_series(:,3))
legend({'real value','regression','time series'},'Location','northeast');
xlabel('z position prediction')
ylabel('position [mm]')
end

end
end
end
end