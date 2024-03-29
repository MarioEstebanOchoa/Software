clear 
clc
tic()
arch = [1 2 3 4 5];

timesToTrain = 5;

trainAll = true;
testAll = true;

training = true;
testing = true;
p_plot = false;

default_f = 6;

name_test_day = '01-Aug-2019';

test_day_path = ['data\' name_test_day];

%type_of_data = "periodic";  %periodic or random
type_of_mov = 2;

for kk=1:2

if kk == 1
    type_of_data = "periodic";  %periodic or random
elseif kk == 2
    type_of_data = "random";  %periodic or random
end
if length(arch)==1
    type_of_data = "test";
end
    
f = fopen([test_day_path '\thumb_' char(type_of_data) '_' num2str(type_of_mov) '.txt'],'w');

%fprintf(f,'folder,err_independant_train,err_all_dimenssion_regression_train,err_time_series_train,dataset,err_indep_regression_test_t,err_regression_test_t,err_time_series_test_t\n');

if trainAll
    if type_of_data == "periodic"
        init_f_tr = 1;
        end_f_tr = 5;
    elseif type_of_data == "random"
        init_f_tr = 6;
        end_f_tr = 10;
    end
    if type_of_mov == 2
        init_f_tr = init_f_tr + 10;
        end_f_tr = end_f_tr + 10;
    end
else
    init_f_tr = default_f;
    end_f_tr = default_f;
    p_plot = true;
end

if testAll
    if type_of_data == "periodic"
        init_f_ts = 1;
        end_f_ts = 5;
    elseif type_of_data == "random"
        init_f_ts = 6;
        end_f_ts = 10;
    end
    if type_of_mov == 2
        init_f_ts = init_f_ts + 10;
        end_f_ts = end_f_ts + 10;
    end
else
    init_f_ts = default_f;
    end_f_ts = default_f;
    p_plot = true;
end


for l = 1:length(arch)
    cc = arch(l);
    switch cc
       case 1
        n_hidden = [2 2 2];
        hidden_all = 2;
        hidden_time = 2; %time series 
       case 2
        n_hidden = [3 3 3];
        hidden_all = 3;
        hidden_time = 3; %time series   
       case 3
        n_hidden = [5 5 5];
        hidden_all = 5;
        hidden_time = 5; %time series     
       case 4
        n_hidden = [7 7 7];
        hidden_all = 7;
        hidden_time = 7; %time series 
       case 5
        n_hidden = [10 10 10];
        hidden_all = 10;
        hidden_time = 10; %time series 
       otherwise
          return;
    end

    delay = 2;

    for k = init_f_tr:end_f_tr
        
        for i=1:timesToTrain
            
            close all
            
            %% Load and filtering
            folder = k;
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
                    %title('RAW POLARIS DATA')
                    legend({'x position','y position','z position'},'Location','northeast');
                    xlabel('[sec]')
                    ylabel('[mm]')
                    grid on

                    figure
                    plot3(output(:,2),output(:,3),output(:,4),'*')
                    %title('3D raw position Polaris Sensor')
                    xlabel('x position [mm]')
                    ylabel('y position [mm]')
                    zlabel('z position [mm]')
                    axis equal
                    %axis([0 50 75 150 0 70])
                    grid on

                    figure
                    subplot(5,1,1)
                    plot(timestamp,input1(:,2));
                    hold on
                    plot(timestamp,input1_filt);
                    %title('DATA FILTERING')
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
                
                %input_filt = mat2gray(input_filt);
                output_filt = [output_x_filt output_y_filt output_z_filt];
                output_filt = offset(output_filt);
                output_x_filt = output_filt(:,1);
                output_y_filt = output_filt(:,2);
                output_z_filt = output_filt(:,3);

                if p_plot

                    figure
                    subplot(4,1,1)
                    plot(timestamp,input_filt);
                    %title('FILTERED AND OFFSET DATA')
                    xlabel('flex sensor')
                    subplot(4,1,2)
                    plot(timestamp,output_x_filt)
                    xlabel('X position')
                    subplot(4,1,3)
                    plot(timestamp,output_y_filt)
                    xlabel('Y position')
                    subplot(4,1,4)
                    plot(timestamp,output_z_filt)
                    xlabel('Z position')

                    figure
                    plot3(output_x_filt,output_y_filt,output_z_filt,'*')
                    %title('FILTERED AND OFFSET 3D RAW POSITION POLARIS SENSOR')
                    xlabel('x position [mm]')
                    ylabel('y position [mm]')
                    zlabel('z position [mm]')
                    axis equal
                    grid on

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
                    %title('REGRESSION TRAIN ON EACH DIMENSION')
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
                    %title('3D position prediction train on each dimension')
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
                    %title('REGRESSION TRAIN ON ALL DIMENSIONS')
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
                    %title('3D position prediction all dimensions')
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
                    %title('TIME SERIES TRAIN ON ALL DIMENSIONS')
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
                    %title('3D position prediction all dimensions')
                    legend({'real value','prediction'},'Location','northeast');
                    xlabel('x position [mm]')
                    ylabel('y position [mm]')
                    zlabel('z position [mm]')
                    axis equal
                end

                err_time_series_train = immse(real_pos,all_pred_time)


            end

            for j=init_f_ts:end_f_ts

                fprintf(f,[num2str(arch(l)), ',', num2str(folder) ',' num2str(err_independant_train) ',' num2str(err_all_dimenssion_regression_train) ',' num2str(err_time_series_train) ',']);

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
                    
                    %input_filt = mat2gray(input_filt);
                    output_filt = [output_x_filt output_y_filt output_z_filt];
                    output_filt = offset(output_filt);
                    output_x_filt = output_filt(:,1);
                    output_y_filt = output_filt(:,2);
                    output_z_filt = output_filt(:,3);
                    
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
                        %title('3D position prediction unseen samples regression indep')
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
                        %title('3D position prediction unseen samples regression')
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
                        %title('3D position prediction unseen samples time series')
                        legend({'real value','prediction'},'Location','northeast');
                        xlabel('x position [mm]')
                        ylabel('y position [mm]')
                        zlabel('z position [mm]')
                        axis equal


                        figure
                        subplot(4,1,1)
                        plot(timestamp,input_filt)
                        %title('PREDICTIONS WITH UNSEEN SAMPLES')
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
end

%%
data=dlmread([test_day_path '\thumb_' char(type_of_data) '_' num2str(type_of_mov) '.txt'],',');
err_a = mean(data(data(:,1)==1,[3:5 7:9]));
err_b = mean(data(data(:,1)==2,[3:5 7:9]));
err_c = mean(data(data(:,1)==3,[3:5 7:9]));
err_d = mean(data(data(:,1)==4,[3:5 7:9]));
err_e = mean(data(data(:,1)==5,[3:5 7:9]));

err = [err_a;err_b;err_c;err_d;err_e];

name = [test_day_path '\mse_thumb_' char(type_of_data) '_' num2str(type_of_mov) '.txt'];
dlmwrite(name,err)
end
toc()
%%
beep
