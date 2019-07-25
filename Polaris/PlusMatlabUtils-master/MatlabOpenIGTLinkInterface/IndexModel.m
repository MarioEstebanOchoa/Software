clear 
clc
close all

%% Load and filtering
folder = 1;

path = ['data\' num2str(folder) '\train_index.mat'];

load(path);


n_hidden = [2 2 2];
input(:,2) = input(:,2)*100/5;  % map 0-5 Volts to 0-100

timestamp = output(:,1);
input_filt = SimpleKalmanFilter(input(:,2), input(1,2), 1, 1, 2);
output_x_filt = SimpleKalmanFilter(output(:,2), output(1,2), 1, 1, 2);
output_y_filt = SimpleKalmanFilter(output(:,3), output(1,3), 1, 1, 2);
output_z_filt = SimpleKalmanFilter(output(:,4), output(1,4), 1, 1, 2);

figure
subplot(4,1,1)
plot(timestamp,input(:,2));
hold on
plot(timestamp,input_filt);
title('DATA FILTERING')
legend({'measured','filtered'},'Location','northeast');
xlabel('flex sensor')

subplot(4,1,2)
plot(timestamp,output(:,2))
hold on
plot(timestamp,output_x_filt)
legend({'measured','filtered'},'Location','northeast');
xlabel('x position')
ylabel('position [mm]')

subplot(4,1,3)
plot(timestamp,output(:,3))
hold on
plot(timestamp,output_y_filt)
legend({'measured','filtered'},'Location','northeast');
xlabel('y position')
ylabel('position [mm]')

subplot(4,1,4)
plot(timestamp,output(:,4))
hold on
plot(timestamp,output_z_filt)
legend({'measured','filtered'},'Location','northeast');
xlabel('z position')
ylabel('position [mm]')

real_pos = [output_x_filt output_y_filt output_z_filt];

%% Training and testing, fitting function, regression
% Training each dimension independantly 

x_pred = train_prediction(input_filt,output_x_filt,n_hidden(1,1),'flex_index_x');
y_pred = train_prediction(input_filt,output_y_filt,n_hidden(1,2),'flex_index_y');
z_pred = train_prediction(input_filt,output_z_filt,n_hidden(1,3),'flex_index_z');

%figure
figure
subplot(4,1,1)
plot(timestamp,input_filt)
title('REGRESSION TRAIN ON EACH DIMENSION')
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


pred_pos = [x_pred' y_pred' z_pred'];

%figure
figure
plot3(real_pos(:,1),real_pos(:,2),real_pos(:,3),'*')
hold on
plot3(pred_pos(:,1),pred_pos(:,2),pred_pos(:,3),'*')
title('3D position prediction train on each dimension')
legend({'real value','prediction'},'Location','northeast');
xlabel('x position [mm]')
ylabel('y position [mm]')
zlabel('z position [mm]')

err_independant_train = immse(real_pos,pred_pos)

%% %Training all dimmensions at once

all_pred = train_prediction(input_filt,real_pos, 2,'flex_index')';


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

err_all_dimenssion_regression_train = immse(real_pos,all_pred)

%% Training and testing, time series
delay = 2;
hidden = 10;
all_pred_time = train_prediction_time(input_filt,real_pos, hidden, delay,'flex_index_time')';
%all_pred_time = [zeros(delay, 3);all_pred_time];
real_pos = real_pos(delay+1:end,:); 


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

err_time_series_train = immse(real_pos,all_pred_time)

%% Test with unseen data

path = ['data\' num2str(folder) '\test_index.mat'];

load(path);

input(:,2) = input(:,2)*100/5;  % map 0-5 Volts to 0-100
timestamp = output(:,1);
input_filt = SimpleKalmanFilter(input(:,2), input(1,2), 1, 1, 2);
output_x_filt = SimpleKalmanFilter(output(:,2), output(1,2), 1, 1, 2);
output_y_filt = SimpleKalmanFilter(output(:,3), output(1,3), 1, 1, 2);
output_z_filt = SimpleKalmanFilter(output(:,4), output(1,4), 1, 1, 2);

real_pos = [output_x_filt output_y_filt output_z_filt];

prediction_regression = flex_index(input_filt')';

figure
plot3(real_pos(:,1),real_pos(:,2),real_pos(:,3),'*')
hold on
plot3(prediction_regression(:,1),prediction_regression(:,2),prediction_regression(:,3),'*')
title('3D position prediction unseen samples regression')
legend({'real value','prediction'},'Location','northeast');
xlabel('x position [mm]')
ylabel('y position [mm]')
zlabel('z position [mm]')

err_regression_test = immse(real_pos,prediction_regression)

prediction_time_series = test_time_series(input_filt,real_pos, hidden, delay, 'flex_index_time');
%prediction_time_series = [zeros(delay, 3);prediction_time_series];

real_pos = real_pos(delay+1:end,:); 

figure
plot3(real_pos(:,1),real_pos(:,2),real_pos(:,3),'*')
hold on
plot3(prediction_time_series(:,1),prediction_time_series(:,2),prediction_time_series(:,3),'*')
title('3D position prediction unseen samples time series')
legend({'real value','prediction'},'Location','northeast');
xlabel('x position [mm]')
ylabel('y position [mm]')
zlabel('z position [mm]')


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

err_time_series_test = immse(real_pos,prediction_time_series)
