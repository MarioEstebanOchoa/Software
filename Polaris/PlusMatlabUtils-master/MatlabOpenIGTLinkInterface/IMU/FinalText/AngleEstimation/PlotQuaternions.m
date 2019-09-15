%close all
fingers = ["middle","index","thumb"];
movements = ["random"];

global plot_data_if;
global plot_results_if;
global plot_stats_if;
plot_data_if = false;
plot_results_if = false;
plot_stats_if = false;

mov = "random"
finger = "thumb"
path_l = [char(finger) '\' char(mov) '_t' num2str(1) '_quat.csv'];
data = readtable(path_l);
[input, output] = get_datasets_exp1(data, finger);
if plot_data_if, plot_dataset(input,output); end

figure
plot(input(:,1:4))
xlabel('Quaterions')
legend("R", "i", "j", "k");
grid on

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