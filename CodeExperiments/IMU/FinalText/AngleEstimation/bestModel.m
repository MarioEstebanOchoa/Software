close all
fingers = ["middle","index","thumb"];
movements = ["random"];
performance_f = zeros(length(fingers),2);
performance = [];
Hidden = 3;
timesToTrain = 10;
tic()
dataset = 1;
global plot_data_if;
global plot_results_if;
global plot_stats_if;
plot_data_if = false;
plot_results_if = true;
plot_stats_if = true;

for c =1:length(fingers)
    finger = fingers(c);
    disp(['finger:' char(finger)])
    disp(['timesToTrain:' num2str(b)])
    [b_p, b_p_t ,b_target, b_estimation, b_target_t, b_estimation_t] = get_best_model(finger, Hidden, timesToTrain);
    if plot_results_if, plot_result(b_target, b_estimation); end
    if plot_stats_if, stats = plot_stats(b_target, b_estimation); end
    if plot_results_if, plot_result(b_target_t, b_estimation_t);end
    if plot_stats_if, stats_t = plot_stats(b_target_t, b_estimation_t);end
    eval([char(finger) '.b_p = b_p;'])
    eval([char(finger) '.b_p_t = b_p_t;'])
    eval([char(finger) '.b_target = b_target;'])
    eval([char(finger) '.b_estimation = b_estimation;'])
    eval([char(finger) '.b_target_t = b_target_t;'])
    eval([char(finger) '.b_estimation_t = b_estimation_t;'])
    eval([char(finger) '.stats = stats;'])
    eval([char(finger) '.stats_t = stats_t;'])
end

function [b_p, b_p_t ,b_target, b_estimation, b_target_t, b_estimation_t] = get_best_model(finger, hidden_n, timesToTrain)
global plot_data_if;

min_p_t = 100;
mov = "random";

path_l = [char(finger) '\' char(mov) '_t' num2str(1) '_quat.csv'];
data = readtable(path_l);
[input, output] = get_datasets_exp1(data, finger);
if plot_data_if, plot_dataset(input,output); end

path_lt = [char(finger) '\' char(mov) '_t' num2str(2) '_quat.csv']; 
data_t = readtable(path_lt);
[input_t, output_t] = get_datasets_exp1(data_t, finger);
if plot_data_if, plot_dataset(input_t,output_t); end

name = [char(finger) '_nnm'];

for i = 1:timesToTrain
[p, target, estimation] = train_prediction(input, output, hidden_n, name);
target = cell2mat(target)';
estimation = cell2mat(estimation)';


[p_t, target_t, estimation_t] = test_prediction(input_t, output_t, hidden_n, name);

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





function [input, output] = get_datasets_exp1(data, finger)
    in1 = data{:,9:12};
    in2 = data{:,13:16};
    input = [in1 in2];
    output = data{:,21:23};
end

% function [input, output] = get_datasets_exp2(data, finger)
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