%close all
fingers = ["middle","index","thumb"];
movements = ["random"];
performance = [];
performance_f = zeros(length(fingers),2);
Hidden = 5;
tic()
dataset = 1;
global plot_data_if;
global plot_results_if;
global plot_stats_if;
plot_data_if = false;
plot_results_if = false;
plot_stats_if = false;

weigthed = false; %dont change
c=3;

finger = fingers(c);
disp(['finger:' char(finger)])
[b_target, b_estimation] = combine_estimation(finger, Hidden, weigthed);
plot_result(b_target, b_estimation)
stats_t = plot_stats(b_target,b_estimation, finger, weigthed);
max_t = max(b_target);
min_t = min(b_target);
range_t = max_t - min_t;
p_error = [stats_t(1).ds.mean*100/range_t(1) stats_t(2).ds.mean*100/range_t(2) stats_t(3).ds.mean*100/range_t(3)]
mean(p_error)

function [b_target, b_estimation] = combine_estimation(finger, hidden_n, weigthed)
global plot_data_if;

mov = "random";

path_lt = [char(finger) '\' char(mov) '_t' num2str(2) '_quat.csv']; 
data_t = readtable(path_lt);
[input_1, output_1] = get_datasets_exp1(data_t, finger);
[input_2, output_2] = get_datasets_exp2(data_t, finger);

if plot_data_if, plot_dataset(input_t,output_t); end

name1 = ['b_' char(finger) '_bm_nnm_exp1'];
name2 = ['b_' char(finger) '_bm_nnm_exp2'];

[p_1, target_1, estimation_1] = test_prediction(input_1, output_1, hidden_n, name1);
[p_2, target_2, estimation_2] = test_prediction(input_2, output_2, hidden_n, name2);

w1 = 0.5;
w2 = 0.5;

if weigthed 
    w1 = p_1/(p_1 + p_2);
    w2 = p_2/(p_1 + p_2);
end

b_estimation = (w1*estimation_1) + (w2*estimation_2);
b_target = target_1;
end


function [input, output] = get_datasets_exp1(data, finger)
    in1 = data{:,9:12};
    in2 = data{:,13:16};
    input = [in1 in2];
    output = data{:,21:23};
end

function [input, output] = get_datasets_exp2(data, finger)
    in1 = data{:,1:4};
    in2 = data{:,5:8};
    input = [in1 in2];
    output = data{:,21:23};
end

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
   [m,n] = size(target);
    nsamples = 200; 
    minlimit = abs(m/2)-nsamples;
    maxlimit = abs(m/2)+nsamples;
    figure
    subplot(3,1,1)
    plot(target(minlimit:maxlimit,1))
    hold on
    plot(estimation(minlimit:maxlimit,1))
    xlabel('yaw')
    ylabel('angle [deg]')
    legend('target','estimation')
    subplot(3,1,2)
    plot(target(minlimit:maxlimit,2))
    hold on
    plot(estimation(minlimit:maxlimit,2))
    xlabel('pitch')
    ylabel('angle [deg]')
    legend('target','estimation')
    subplot(3,1,3)
    plot(target(minlimit:maxlimit,3))
    hold on
    plot(estimation(minlimit:maxlimit,3))
    xlabel('roll')
    ylabel('angle [deg]')
    legend('target','estimation')
end

function [stats] = plot_stats(target, estimation, finger, weighted)

error = abs(gsubtract(estimation(1:end-1,:), target(1:end-1,:)));
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
xlab = ['Yaw:  ' char(181) ' = ' num2str(stats(1).ds.mean) ', ' char(963) ' = ' num2str(stats(1).ds.std) newline ...
    'Pitch: ' char(181) ' = ' num2str(stats(2).ds.mean) ', ' char(963) ' = ' num2str(stats(2).ds.std) newline ...
    'Roll:   ' char(181) ' = ' num2str(stats(3).ds.mean) ', ' char(963) ' = ' num2str(stats(3).ds.std)]

dim = [0.14 0.6 0.3 0.3];
str = {'Straight Line Plot','from 1 to 10'};
a = annotation('textbox',dim,'String',xlab,'FitBoxToText','on');
a.FontSize = 9;

xlabel('Angle error [deg]');
ylabel('Normalized counts')
legend('yaw','pitch','roll')
if weighted
    title([char(finger) ' model / Weighted Average'])
else
    title([char(finger) ' model / Standard Average'])
end
grid on
end

