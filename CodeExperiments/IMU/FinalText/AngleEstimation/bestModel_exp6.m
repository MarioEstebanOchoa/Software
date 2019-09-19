%close all
fingers = ["middle","index","thumb"];
movements = ["random"];
performance = [];
performance_f = zeros(length(fingers),2);
Hidden =[4 4 3];
timesToTrain = 10;
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
    [b_p, b_p_t ,b_target, b_estimation, b_target_t, b_estimation_t] = get_best_model(finger, Hidden(c), timesToTrain, c);
    results_finger(c).b_p = b_p;
    results_finger(c).b_p = b_p;
    results_finger(c).b_p_t = b_p_t;
    results_finger(c).b_target = b_target;
    results_finger(c).b_estimation = b_estimation;
    results_finger(c).b_target_t = b_target_t;
    results_finger(c).b_estimation_t = b_estimation_t;
end

save('bestModelFingers_exp6','results_finger');


function [b_p, b_p_t ,b_target, b_estimation, b_target_t, b_estimation_t] = get_best_model(finger, hidden_n, timesToTrain, c)

    min_p_t = 100;

    name = [char(finger) '_bm_nnm_exp6'];

    for i = 1:timesToTrain
        [XTrain, XTest, YTrain, YTest] = get_datasets_exp6(c);

        [p, target, estimation] = train_prediction(XTrain, YTrain, hidden_n, name);

        [p_t, target_t, estimation_t] = test_prediction(XTest, YTest, hidden_n, name);

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

function [XTrain, XTest, YTrain, YTest] = get_datasets_exp6(c)

    model1 = load('bestModelFingers_exp1.mat');
    model2 = load('bestModelFingers_exp2.mat');
    in1 = cell2mat(model1.results_finger(c).b_estimation)';
    out1 = rmmissing(cell2mat(model1.results_finger(c).b_target)');
    in2 = cell2mat(model2.results_finger(c).b_estimation)';
    out2 = rmmissing(cell2mat(model2.results_finger(c).b_target)');

    XTrain = [in1(1:end-1,:) in2(1:end-1,:)];
    YTrain = out1;
    
    in1 = model1.results_finger(c).b_estimation_t;
    out1 = model1.results_finger(c).b_target_t;
    in2 = model2.results_finger(c).b_estimation_t;
    out2 = model2.results_finger(c).b_target_t;
    
    XTest = [in1 in2];
    YTest = out1;
    
end

% function [input, output] = get_datasets_exp6(data, finger)
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