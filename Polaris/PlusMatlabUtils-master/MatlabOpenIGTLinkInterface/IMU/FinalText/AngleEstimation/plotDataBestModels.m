close all
fingers = ["middle","index","thumb"];
c = 3;
finger = fingers(c);

load('bestModelFingers_exp4.mat')

% target = results_finger(c).b_target;
% estimation = results_finger(c).b_estimation;
% plot_result(target, estimation)
% stats = plot_stats(target, estimation);

target = results_finger(c).b_target_t;
estimation = results_finger(c).b_estimation_t;
plot_result(target, estimation)
stats_t = plot_stats(target, estimation);

max_t = max(target);
min_t = min(target);
range_t = max_t - min_t;
p_error = [abs(stats_t(1).ds.mean*100/range_t(1)) abs(stats_t(2).ds.mean*100/range_t(2)) abs(stats_t(3).ds.mean*100/range_t(3))]
mean(p_error)

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

function [stats] = plot_stats(target, estimation)
er = (abs(mean(gsubtract(estimation(1:end-1,:),target(1:end-1,:)))));
error = gsubtract(estimation(1:end-1,:), target(1:end-1,:));
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




