%close all
fingers = ["middle","index","thumb"];
movements = ["random"];
performance = [];
performance_f = zeros(length(fingers),2);
Hidden = 5;
timesToTrain = 5;
tic()
dataset = 1;
global plot_data_if;
global plot_results_if;
global plot_stats_if;
plot_data_if = false;
plot_results_if = false;
plot_stats_if = false;

parfor c =1:length(fingers)
    finger = fingers(c);
    disp(['finger:' char(finger)])
    [b_p, b_p_t ,b_target, b_estimation, b_target_t, b_estimation_t] = get_best_model(finger, Hidden, timesToTrain);
    results_finger(c).b_p = b_p;
    results_finger(c).b_p = b_p;
    results_finger(c).b_p_t = b_p_t;
    results_finger(c).b_target = b_target;
    results_finger(c).b_estimation = b_estimation;
    results_finger(c).b_target_t = b_target_t;
    results_finger(c).b_estimation_t = b_estimation_t;
end

save('bestModelFingers_exp3','results_finger');


function [b_p, b_p_t ,b_target, b_estimation, b_target_t, b_estimation_t] = get_best_model(finger, hidden_n, timesToTrain)
global plot_data_if;

min_p_t = 100;
mov = "random";

name = [char(finger) '_bm_nnm_exp3'];

for i = 1:timesToTrain
    for j = 1:2
        path_l = [char(finger) '\' char(mov) '_t' num2str(j) '_quat.csv'];
        data = readtable(path_l);
        [input, output] = get_datasets_exp3(data, finger);
        if plot_data_if, plot_dataset(input,output); end

        % path_lt = [char(finger) '\' char(mov) '_t' num2str(2) '_quat.csv']; 
        % data_t = readtable(path_lt);
        % [input_t, output_t] = get_datasets_exp1(data_t, finger);
        % if plot_data_if, plot_dataset(input_t,output_t); end

        numTimeStepsTrain = floor(0.5*size(input,1));

        XTrain = input(1:numTimeStepsTrain+1,:);
        XTest = input(numTimeStepsTrain+1:end,:);
        YTrain = output(1:numTimeStepsTrain+1,:);
        YTest = output(numTimeStepsTrain+1:end,:);

        [coeff,scoreTrain,~,~,explained,mu] = pca(XTrain);

        sum_explained = 0;
        idx = 0;
        while sum_explained < 95
            idx = idx + 1;
            sum_explained = sum_explained + explained(idx);
        end

        scoreTrain95 = scoreTrain(:,1:idx);

        [p, target, estimation] = train_prediction(scoreTrain95, YTrain, hidden_n, name);

        scoreTest95 = (XTest-mu)*coeff(:,1:idx);

        [p_t, target_t, estimation_t] = test_prediction(scoreTest95, YTest, hidden_n, name);
        
if p_t < min_p_t
    min_p_t = p_t;
    expression = ['copyfile ' name '.m b_' name '.m'];
    eval(expression)
    b_p = p;
    b_target = target;
    b_estimation = estimation;
    b_p_t = p_t;
    b_target_t = target_t;
    b_estimation_t = estimation_t;
end
    end
end
end


function [input, output] = get_datasets_exp3(data, finger)
    in1 = data{:,1:4};
    in2 = data{:,5:8};
    in3 = data{:,9:12};
    in4 = data{:,13:16};
    input = [in1 in2 in3 in4];
    output = data{:,21:23};
end

% function [input, output] = get_datasets_exp3(data, finger)
%     if (finger == "middle") || (finger == "index")
%         in1 = data{:,9:12};
%         in2 = data{:,13:16};
%         input = [in1 in2];
%         output = data{:,21:23};
%     elseif (finger == "thumb") 
%         in1 = data{:,9:12};
%         in2 = data{:,13:16};
%         input = [in1 in2];
%         output = data{:,21:23}; 
%     end
%     %output = offset(output);
% end

function [] = plot_dataset(input, output)
    figure
    subplot(2,1,1)
    plot(input)
    xlabel('input Quaternions')
    subplot(2,1,2)
    plot(output)
    xlabel('Joint Euler Angles')
    ylabel('Angle [deg]')
    legend('yaw','pitch','roll')
%     figure
%     plot3(output(:,1),output(:,2),output(:,3),'-')
%     axis equal
end

function [] = plot_result(target, estimation)
    figure
    subplot(3,1,1)
    plot(target(:,1))
    hold on
    plot(estimation(:,1))
    xlabel('yaw')
    ylabel('angle [deg]')
    legend('target','estimation')
    subplot(3,1,2)
    plot(target(:,2))
    hold on
    plot(estimation(:,2))
    xlabel('pitch')
    ylabel('angle [deg]')
    legend('target','estimation')
    subplot(3,1,3)
    plot(target(:,3))
    hold on
    plot(estimation(:,3))
    xlabel('roll')
    ylabel('angle [deg]')
    legend('target','estimation')
%     figure
%     plot3(target(:,1),target(:,2),target(:,3),'-')
%     hold on
%     plot3(estimation(:,1),estimation(:,2),estimation(:,3),'-')
%     axis equal
end

function [stats] = plot_stats(target, estimation)

error = (gsubtract(estimation(1:end-1,:), target(1:end-1,:)));
figure
[m,n] = size(error);
stats = struct([]);
for i = 1:n
    cf = error(:,i);
    ds = datastats(cf);
    stats(i).ds = ds;
    mu = ds.mean;
    sigma = ds.std;
    pd = fitdist(cf, 'normal');
    x = mu-(4*sigma):0.01:mu+(4*sigma);
    y = pdf(pd,x);
    plot(x, y,'LineWidth',1.5)
    hold on
end
xlabel('Angle error [deg]')
ylabel('Normalized counts')
legend('yaw','pitch','roll')
grid on
end