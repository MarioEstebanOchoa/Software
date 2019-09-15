close all
clear 
clc

name_test_day = '01-Aug-2019';
test_day_path = ['data\' name_test_day];
    
hidden_time = 4; %time series   
delay = 2;
init_f_tr = 1;
end_f_tr = 10;
init_f_ts = 1;
end_f_ts = 10;
timesToTrain = 10;
min_error = 100;

f = fopen(['stats_' 'flex_index_time' '.txt'],'w');

for k = init_f_tr:end_f_tr
    
    for i=1:timesToTrain
        
        folder = k;
        path = [test_day_path '\' num2str(folder) '\train_index.mat'];

        load(path);

        input(:,2) = input(:,2)*100/5;  % map 0-5 Volts to 0-100

        timestamp = output(:,1);
        input_filt = SimpleKalmanFilter(input(:,2), input(1,2), 1, 1, 2);
        output_x_filt = SimpleKalmanFilter(output(:,2), output(1,2), 1, 1, 2);
        output_y_filt = SimpleKalmanFilter(output(:,3), output(1,3), 1, 1, 2);
        output_z_filt = SimpleKalmanFilter(output(:,4), output(1,4), 1, 1, 2);

        output_filt = [output_x_filt output_y_filt output_z_filt];
        output_filt = offset(output_filt);
        output_x_filt = output_filt(:,1);
        output_y_filt = output_filt(:,2);
        output_z_filt = output_filt(:,3);

        real_pos = [output_x_filt output_y_filt output_z_filt];

%% Training 

        all_pred_time = train_prediction_time(input_filt,real_pos, hidden_time, delay,'flex_index_time')';
        real_pos = real_pos(delay+1:end,:); 
        err_time_series_train = immse(real_pos,all_pred_time);
        
%% Test with unseen data
err_time_series_test_t = [];
        for j=init_f_ts:end_f_ts
            if j~=k
                close all
                test_day_path = ['data\' name_test_day];

                path = [test_day_path '\' num2str(j) '\test_index.mat'];

                load(path);

                input(:,2) = input(:,2)*100/5;  % map 0-5 Volts to 0-100
                timestamp = output(:,1);
                input_filt = SimpleKalmanFilter(input(:,2), input(1,2), 1, 1, 2);
                output_x_filt = SimpleKalmanFilter(output(:,2), output(1,2), 1, 1, 2);
                output_y_filt = SimpleKalmanFilter(output(:,3), output(1,3), 1, 1, 2);
                output_z_filt = SimpleKalmanFilter(output(:,4), output(1,4), 1, 1, 2);

                output_filt = [output_x_filt output_y_filt output_z_filt];
                output_filt = offset(output_filt);
                output_x_filt = output_filt(:,1);
                output_y_filt = output_filt(:,2);
                output_z_filt = output_filt(:,3);

                real_pos = [output_x_filt output_y_filt output_z_filt];

                prediction_time_series = test_time_series(input_filt,real_pos, hidden_time, delay, 'flex_index_time');

                real_pos = real_pos(delay+1:end,:); 

                err_time_series_test_t = [err_time_series_test_t immse(real_pos,prediction_time_series)];
            end
        end
        mse = mean(err_time_series_test_t);
        if mse < min_error
            min_error = mse
            copyfile flex_index_time.m b_flex_index_time.m
            fprintf(f,[num2str(err_time_series_train) ',' num2str(min_error) ',' num2str(k) ',' num2str(hidden_time) '\n']);
        end
    end
end
