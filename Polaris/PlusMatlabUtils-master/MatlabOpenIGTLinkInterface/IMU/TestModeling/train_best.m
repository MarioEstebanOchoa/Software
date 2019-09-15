close all

finger = "index";

hidden = 3;
delay = 2;

mov_thumb = [];

timesToTrain = 10;
min_per = 100;
per_arr = [];

disc_data = 3;

p_plot = true;
train = false;
ranges = [];
%% Periodic
mov = ['periodic' num2str(mov_thumb)];

path = [char(finger) '\' char(mov) '.csv'];
data = readtable(path);

p_S8 = [data.S8_x(disc_data:end) data.S8_y(disc_data:end) data.S8_z(disc_data:end)];
p_S9 = [data.S9_x(disc_data:end) data.S9_y(disc_data:end) data.S9_z(disc_data:end)];
p_S10 = [data.S10_x(disc_data:end) data.S10_y(disc_data:end) data.S10_z(disc_data:end)];
p_S11 = [data.S11_x(disc_data:end) data.S11_y(disc_data:end) data.S11_z(disc_data:end)];

p_S8 = recover(p_S8);
p_S9 = recover(p_S9);
p_S10 = recover(p_S10);
p_S11 = recover(p_S11);

p_middle_position = [data.middle_pose_position_x(disc_data:end) data.middle_pose_position_y(disc_data:end) data.middle_pose_position_z(disc_data:end)];
p_index_position = [data.index_pose_position_x(disc_data:end) data.index_pose_position_y(disc_data:end) data.index_pose_position_z(disc_data:end)];
p_thumb_position = [data.thumb_pose_position_x(disc_data:end) data.thumb_pose_position_y(disc_data:end) data.thumb_pose_position_z(disc_data:end)];

p_middle_position = p_middle_position*1000;
p_index_position = p_index_position*1000;
p_thumb_position = p_thumb_position*1000;

p_middle_position_f = SimpleKalmanFilter(p_middle_position,p_middle_position(1,:),1,1,1);
p_index_position_f = SimpleKalmanFilter(p_index_position,p_index_position(1,:),1,1,1);
p_thumb_position_f = SimpleKalmanFilter(p_thumb_position,p_thumb_position(1,:),1,1,1);

p_middle_position_o = offset(p_middle_position_f);
p_index_position_o = offset(p_index_position_f);
p_thumb_position_o = offset(p_thumb_position_f);

p_S8_f = SimpleKalmanFilter(p_S8,p_S8(1,:),1,1,3);
p_S9_f = SimpleKalmanFilter(p_S9,p_S9(1,:),1,1,3);
p_S10_f = SimpleKalmanFilter(p_S10,p_S10(1,:),1,1,3);
p_S11_f = SimpleKalmanFilter(p_S11,p_S11(1,:),1,1,3);

if finger == "middle"
    p_S = p_S9_f - p_S8_f;
elseif finger == "index"
    p_S = p_S9_f - p_S8_f;
elseif finger == "thumb"
    p_S1 = p_S11_f - p_S8_f;
    if mov == "periodic1" || mov == "random1" 
        p_S2 = p_S9_f - p_S8_f;
    else
        p_S2 = p_S10_f - p_S8_f;
    end
    p_S1 = offset_imu(p_S1);
    p_S2 = offset_imu(p_S2);
    p_S = [p_S1 p_S2];
end

%% random
mov = ['random' num2str(mov_thumb)];

path = [char(finger) '\' char(mov) '.csv'];
data = readtable(path);

r_S8 = [data.S8_x(disc_data:end) data.S8_y(disc_data:end) data.S8_z(disc_data:end)];
r_S9 = [data.S9_x(disc_data:end) data.S9_y(disc_data:end) data.S9_z(disc_data:end)];
r_S10 = [data.S10_x(disc_data:end) data.S10_y(disc_data:end) data.S10_z(disc_data:end)];
r_S11 = [data.S11_x(disc_data:end) data.S11_y(disc_data:end) data.S11_z(disc_data:end)];

r_S8 = recover(r_S8);
r_S9 = recover(r_S9);
r_S10 = recover(r_S10);
r_S11 = recover(r_S11);

r_middle_position = [data.middle_pose_position_x(disc_data:end) data.middle_pose_position_y(disc_data:end) data.middle_pose_position_z(disc_data:end)];
r_index_position = [data.index_pose_position_x(disc_data:end) data.index_pose_position_y(disc_data:end) data.index_pose_position_z(disc_data:end)];
r_thumb_position = [data.thumb_pose_position_x(disc_data:end) data.thumb_pose_position_y(disc_data:end) data.thumb_pose_position_z(disc_data:end)];

r_middle_position = r_middle_position*1000;
r_index_position = r_index_position*1000;
r_thumb_position = r_thumb_position*1000;

r_middle_position_f = SimpleKalmanFilter(r_middle_position,r_middle_position(1,:),1,1,1);
r_index_position_f = SimpleKalmanFilter(r_index_position,r_index_position(1,:),1,1,1);
r_thumb_position_f = SimpleKalmanFilter(r_thumb_position,r_thumb_position(1,:),1,1,1);

r_middle_position_o = offset(r_middle_position_f);
r_index_position_o = offset(r_index_position_f);
r_thumb_position_o = offset(r_thumb_position_f);

r_S8_f = SimpleKalmanFilter(r_S8,r_S8(1,:),1,1,3);
r_S9_f = SimpleKalmanFilter(r_S9,r_S9(1,:),1,1,3);
r_S10_f = SimpleKalmanFilter(r_S10,r_S10(1,:),1,1,3);
r_S11_f = SimpleKalmanFilter(r_S11,r_S11(1,:),1,1,3);

if finger == "middle"
    r_S = r_S9_f - r_S8_f;
elseif finger == "index"
    r_S = r_S9_f - r_S8_f;
elseif finger == "thumb"
    r_S1 = r_S11_f - r_S8_f;
    if mov == "periodic1" || mov == "random1" 
        r_S2 = r_S9_f - r_S8_f;
    else
        r_S2 = r_S10_f - r_S8_f;
    end
    r_S1 = offset_imu(r_S1);
    r_S2 = offset_imu(r_S2);
    r_S = [r_S1 r_S2];
end

%%

p_input = p_S;
r_input = r_S;
expression = ['p_' char(finger) '_position_o'];
p_output = eval(expression); 
expression = ['r_' char(finger) '_position_o'];
r_output = eval(expression); 

name = ['imu_' char(finger) num2str(mov_thumb) '_model'];
t_input = [p_input;r_input];
t_output = [p_output;r_output];
max_o = max(t_output);
min_o = min(t_output);
range_o = max_o - min_o;
ranges = [ranges; range_o];

if train
    
f = fopen(['b_stats_imu_' char(finger) num2str(mov_thumb) '_model.txt'],'w');

for k=1:2
   if k==1
       input = p_input;
       output = p_output;
   elseif k==2
       input = r_input;
       output = r_output;
   end
    for j=1:timesToTrain
        train_prediction(input, output, hidden, delay, name);
        [performance, performance_ab, ~] = test_prediction(t_input, t_output, hidden, delay, name);
        %beep
        if performance < min_per
            min_per = performance;
            expression = ['copyfile ' name '.m b_' name '.m'];
            eval(expression)
            ds = j;
        end
        fprintf(f,[num2str(performance) ',' num2str(performance_ab) ',' num2str(j) '\n']);
    end
end
end

%% Testing
b_name = ['b_' name];
[~, ~, p_prediction] = test_prediction(p_input, p_output, hidden, delay, b_name);
p_output = p_output(delay+1:end,:);
[~, ~, r_prediction] = test_prediction(r_input, r_output, hidden, delay, b_name);
r_output = r_output(delay+1:end,:);
p_error_ab = sqrt((p_output(:,1)-p_prediction(:,1)).^2+(p_output(:,2)-p_prediction(:,2)).^2+(p_output(:,3)-p_prediction(:,3)).^2);
r_error_ab = sqrt((r_output(:,1)-r_prediction(:,1)).^2+(r_output(:,2)-r_prediction(:,2)).^2+(r_output(:,3)-r_prediction(:,3)).^2);
error = [p_error_ab;r_error_ab];
b_name = ['b_' name];
[~, ~, t_prediction] = test_prediction(t_input, t_output, hidden, delay, b_name);
t_output = t_output(delay+1:end,:);
error = sqrt((t_output(:,1)-t_prediction(:,1)).^2+(t_output(:,2)-t_prediction(:,2)).^2+(t_output(:,3)-t_prediction(:,3)).^2);
comp_error = abs(([t_output]-[t_prediction]));



%%
if p_plot
    figure
    if finger == "thumb"
        subplot(5,1,1)
        plot(t_input(:,1:3))
        xlabel('IMU 1 sensor data')
        ylabel('angle [deg]')
        legend('yaw', 'pitch', 'roll')
        subplot(5,1,2)
        plot(t_input(:,4:6))
        xlabel('IMU 2 sensor data')
        ylabel('angle [deg]')
        legend('yaw', 'pitch', 'roll')
        subplot(5,1,3)
        plot(t_output(:,1))
        hold on
        plot(t_prediction(:,1))
        xlabel('X position')
        ylabel('[mm]')
        legend('real value', 'estimation')
        subplot(5,1,4)
        plot(t_output(:,2))
        hold on
        plot(t_prediction(:,2))
        xlabel('Y position')
        ylabel('[mm]')
        legend('real value', 'estimation')
        subplot(5,1,5)
        plot(t_output(:,3))
        hold on
        plot(t_prediction(:,3))
        xlabel('Z position')
        ylabel('[mm]')
        legend('real value', 'estimation')
    else
        subplot(4,1,1)
        plot(t_input)
        xlabel('IMU sensor data')
        ylabel('angle [deg]')
        legend('yaw', 'pitch', 'roll')
        subplot(4,1,2)
        plot(t_output(:,1))
        hold on
        plot(t_prediction(:,1))
        xlabel('X position')
        ylabel('[mm]')
        legend('real value', 'estimation')
        subplot(4,1,3)
        plot(t_output(:,2))
        hold on
        plot(t_prediction(:,2))
        xlabel('Y position')
        ylabel('[mm]')
        legend('real value', 'estimation')
        subplot(4,1,4)
        plot(t_output(:,3))
        hold on
        plot(t_prediction(:,3))
        xlabel('Z position')
        ylabel('[mm]')
        legend('real value', 'estimation')
    end
    
    figure
    plot(r_input)
    xlabel('IMU sensor data')
    ylabel('angle [deg]')
    legend('yaw', 'pitch', 'roll')
    grid on
    
    p_S_nf = p_S9 - p_S8;
    p_middle_position_o_nf = offset(p_middle_position);
    
    figure
    subplot(2,1,1)
    plot(normalize(p_S_nf,'range'))
    xlabel('IMU sensor data')
    ylabel('angle [deg]')
    legend('yaw', 'pitch', 'roll')
    subplot(2,1,2)
    plot(p_middle_position_o_nf)
    xlabel('3D Position')
    ylabel('[mm]')
    legend('x position','y position', 'z position')
   
    
    figure
    subplot(2,1,1)
    plot(normalize(p_S,'range'))
    xlabel('IMU sensor data')
    ylabel('angle [deg]')
    legend('yaw', 'pitch', 'roll')
    subplot(2,1,2)
    plot(p_middle_position_o)
    xlabel('3D Position')
    ylabel('[mm]')
    legend('x position','y position', 'z position')
    
    figure 
    plot3(t_output(:,1),t_output(:,2),t_output(:,3),'*')
    hold on
    plot3(t_prediction(:,1),t_prediction(:,2),t_prediction(:,3),'x');
    axis equal
    grid on
    xlabel('X position')
    ylabel('Y position')
    zlabel('Z position')
    legend('real value', 'estimation') 
end



%%


figure
cf = error;
ds = datastats(cf)
mu = ds.mean;
sigma = ds.std;
pd = fitdist(cf, 'normal');
x = mu-(4*sigma):0.01:mu+(4*sigma);
y = pdf(pd,x);
plot(x, y,'LineWidth',1.5)
% hold on
% histogram(error , 10,'Normalization','count')
ylabel('Normalized counts')
xlabel('Average Absolute Error [mm]')
hold on
grid on


figure
[m,n] = size(comp_error);
stats = struct([]);
for i = 1:n
    cf = comp_error(:,i);
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
xlabel('Average Absolute Error [mm]')
ylabel('Normalized counts')
legend('x dimension','y dimension','z dimension')
grid on

ranges