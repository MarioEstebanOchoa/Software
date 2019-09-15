close all
name_test_day = '01-Aug-2019';
test_day_path = ['..\data\' name_test_day];
ab_err_t = [];
ab_err_comp_t = [];
trainedDataset = 15;
hidden_time = 3;
delay = 2;
include_train = true;
min_err = 50;
max_err = 0;
p_plot = true;
ranges = [];
finger = "thumb"; % middle, index, thumb
x = -10:.1:20;
init_f_ts = 1;
end_f_ts = 10;
type_of_mov = 2;

if finger == "thumb"
    if type_of_mov == 2 
        init_f_ts = init_f_ts + 10;
        end_f_ts = end_f_ts + 10;    
    end
    name = [char(finger) num2str(type_of_mov)];
else
    name = [char(finger)];
end

folder = 1;
for i = init_f_ts:end_f_ts
    input_test = [];
    output_test = [];
    if i~=trainedDataset
        if include_train
            path = [test_day_path '\' num2str(i) '\train_' char(finger) '.mat'];
            load(path);

            if finger == "thumb"
               input_test = [input_test;input1(:,2) input2(:,2)]; 
            else
                input_test = [input_test;input(:,2)];
            end

            output_test = [output_test;output(:,2:4)];
        end
        path = [test_day_path '\' num2str(i) '\test_' char(finger) '.mat'];
        load(path);
        
        if finger == "thumb"
           input_test = [input_test;input1(:,2) input2(:,2)]; 
        else
            input_test = [input_test;input(:,2)];
        end
        
        output_test = [output_test;output(:,2:4)];
        input_test = input_test*100/5;  % map 0-5 Volts to 0-100
        
        if finger == "thumb"
            input_test1 = SimpleKalmanFilter(input_test(:,1), input_test(1,1), 1, 1, 2);
            input_test2 = SimpleKalmanFilter(input_test(:,2), input_test(1,2), 1, 1, 2);
            input_test = [input_test1 input_test2];
        else
            input_test = SimpleKalmanFilter(input_test, input_test(1,1), 1, 1, 2);
        end
        output_x = SimpleKalmanFilter(output_test(:,1), output_test(1,1), 1, 1, 2);
        output_y = SimpleKalmanFilter(output_test(:,2), output_test(1,2), 1, 1, 2);
        output_z = SimpleKalmanFilter(output_test(:,3), output_test(1,3), 1, 1, 2);
        output_test = [output_x output_y output_z];
        max_o = max(output_test);
        min_o = min(output_test);
        range_o = max_o - min_o;
        ranges = [ranges; range_o];
        output_test = offset(output_test);
        prediction_time_series = test_time_series(input_test, output_test, hidden_time, delay, ['b_flex_' name '_time']);
        output_test = output_test(delay+1:end,:);
        ab_err_comp = abs((output_test-prediction_time_series));
        ab_err = sqrt((output_test(:,1)-prediction_time_series(:,1)).^2+(output_test(:,2)-prediction_time_series(:,2)).^2+(output_test(:,3)-prediction_time_series(:,3)).^2);
        %err = immse(output_test, prediction_time_series);
        err = mean(ab_err);
        if err < min_err
            ab_err_min = ab_err;
            ab_err_comp_min_t = ab_err_comp;
            min_err = err;
            dsmn = i;
        end
        if err > max_err
            ab_err_max = ab_err;
            ab_err_comp_max_t = ab_err_comp;
            max_err = err;
            dsmx = i;
        end
        ab_err_t = [ab_err_t; ab_err];
        ab_err_comp_t = [ab_err_comp_t; ab_err_comp];
    end
end
mean(ab_err_t)

%return

%% Ploting
 
if p_plot
    input_test = [];
    output_test = [];
    timestamp = [];

    path = [test_day_path '\' num2str(dsmn) '\train_' char(finger) '.mat'];
    load(path);

    if finger == "thumb"
       input_test = [input_test;input1(:,2) input2(:,2)]; 
    else
        input_test = [input_test;input(:,2)];
    end

    output_test = [output_test;output(:,2:4)];
    timestamp = [timestamp;output(:,1)];

    path = [test_day_path '\' num2str(dsmn) '\test_' char(finger) '.mat'];
    load(path);

    if finger == "thumb"
    input_test = [input_test;input1(:,2) input2(:,2)]; 
    else
    input_test = [input_test;input(:,2)];
    end

    output_test = [output_test;output(:,2:4)];
    timestamp = [timestamp;output(:,1)];

    figure
    plot(timestamp,input_test)
    xlabel('flex sensor value')


    input_test = input_test*100/5;  % map 0-5 Volts to 0-100

    figure
    plot(timestamp,input_test)
    xlabel('flex sensor value')
    hold on

    if finger == "thumb"
    input_test1 = SimpleKalmanFilter(input_test(:,1), input_test(1,1), 1, 1, 2);
    input_test2 = SimpleKalmanFilter(input_test(:,2), input_test(1,2), 1, 1, 2);
    input_test = [input_test1 input_test2];
    else
    input_test = SimpleKalmanFilter(input_test, input_test(1,1), 1, 1, 2);
    end

    plot(timestamp,input_test)
    legend({'original values','filtered, scaled'},'Location','northeast');

    output_x = SimpleKalmanFilter(output_test(:,1), output_test(1,1), 1, 1, 2);
    output_y = SimpleKalmanFilter(output_test(:,2), output_test(1,2), 1, 1, 2);
    output_z = SimpleKalmanFilter(output_test(:,3), output_test(1,3), 1, 1, 2);
    output_test = [output_x output_y output_z];
    output_test = offset(output_test);
    prediction_time_series = test_time_series(input_test, output_test, hidden_time, delay, ['b_flex_' name '_time']);
    output_test = output_test(delay+1:end,:);

    figure
    plot3(output_test(:,1),output_test(:,2),output_test(:,3),'*')
    hold on
    plot3(prediction_time_series(:,1),prediction_time_series(:,2),prediction_time_series(:,3),'*')
    %title('3D position prediction unseen samples time series')
    legend({'target','estimated'},'Location','northeast');
    xlabel('x position [mm]')
    ylabel('y position [mm]')
    zlabel('z position [mm]')
    axis equal
    grid on

    figure
    subplot(4,1,1)
    plot(timestamp,input_test)
    %title('PREDICTIONS WITH UNSEEN SAMPLES')
    xlabel('flex sensor value')

    subplot(4,1,2)
    plot(timestamp(delay+1:end,:),output_test(:,1))
    hold on
    %plot(timestamp,prediction_regression(:,1))
    plot(timestamp(delay+1:end,:),prediction_time_series(:,1))
    legend({'target','estimated'},'Location','northeast');
    xlabel('x position estimation')
    ylabel('position [mm]')

    subplot(4,1,3)
    plot(timestamp(delay+1:end,:),output_test(:,2))
    hold on
    %plot(timestamp,prediction_regression(:,2))
    plot(timestamp(delay+1:end,:),prediction_time_series(:,2))
    legend({'target','estimated'},'Location','northeast');
    xlabel('y position estimation')
    ylabel('position [mm]')

    subplot(4,1,4)
    plot(timestamp(delay+1:end,:),output_test(:,3))
    hold on
    %plot(timestamp,prediction_regression(:,3))
    plot(timestamp(delay+1:end,:),prediction_time_series(:,3))
    legend({'target','estimated'},'Location','northeast');
    xlabel('z position estimation')
    ylabel('position [mm]')
end
%%

error_min_max = [ab_err_min ab_err_max];

[m,n] = size(error_min_max);


figure
for i = 1:n
    cf = error_min_max(:,i);
    ds = datastats(cf)
    mu = ds.mean;
    sigma = ds.std;
    pd = fitdist(cf, 'normal');
    y = pdf(pd,x);
    plot(x, y,'LineWidth',1.5)
    hold on
%     histogram(cf,'Normalization','pdf')
%     hold on
end

error = ab_err_t;
cf = error;
ds = datastats(cf)
av_mu = ds.mean;
av_sigma = ds.std;
pd = fitdist(cf, 'normal');
y = pdf(pd,x);
plot(x, y,'LineWidth',1.5)
hold on
% histogram(cf, 'Normalization','pdf');
% hold on
grid on

ylabel('Normalized counts')
xlabel('Average Absolute Error [mm]')
legend('min error','max error','average error')

[m,n] = size(ab_err_comp_t);

figure
for i = 1:n
    cf = ab_err_comp_t(:,i);
    ds = datastats(cf)
    mu = ds.mean;
    sigma = ds.std;
    pd = fitdist(cf, 'normal');
    y = pdf(pd,x);
    plot(x, y,'LineWidth',1.5)
    hold on
%     histogram(cf, 'Normalization','pdf');
%     hold on
end
ylabel('Normalized counts')
xlabel('Average Absolute Error [mm]')
legend('x dimension','y dimension','z dimension')
grid on

mr = mean(ranges)
av_pe = av_mu*100/(sqrt(mr(1,1)^2+mr(1,2)^2+mr(1,3)^2))
(sqrt(mr(1,1)^2+mr(1,2)^2+mr(1,3)^2))
av_mu
av_sigma