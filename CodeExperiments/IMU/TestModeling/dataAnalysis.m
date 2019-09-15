finger = "thumb";

mov_thumb = 1;

min_hidden = 1;
max_hidden = 10;
delay = 2;

timesToTrain = 5;
min_per = 100;
per_arr = [];

disc_data = 3;

p_plot = true;
train = true;

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

if p_plot
    figure
    if finger == "thumb"
        subplot(3,1,1)
        plot(p_S1)
        subplot(3,1,2)
        plot(p_S2)
        subplot(3,1,3)
        expression = ['plot(p_' char(finger) '_position_o)'];
        eval(expression);
    else
        subplot(2,1,1)
        plot(p_S)
        subplot(2,1,2)
        expression = ['plot(p_' char(finger) '_position_o)'];
        eval(expression);
    end

    figure 
    expression = ['plot3(p_' char(finger) '_position_o(:,1),p_' char(finger) '_position_o(:,2),p_' char(finger) '_position_o(:,3),' char(39) '*' char(39) ')'];
    eval(expression);
    axis equal
    
    figure
    if finger == "thumb"
        subplot(3,1,1)
        plot(r_S1)
        subplot(3,1,2)
        plot(r_S2)
        subplot(3,1,3)
        expression = ['plot(r_' char(finger) '_position_o)'];
        eval(expression);
    else
        subplot(2,1,1)
        plot(r_S)
        subplot(2,1,2)
        expression = ['plot(r_' char(finger) '_position_o)'];
        eval(expression);
    end

    figure 
    expression = ['plot3(r_' char(finger) '_position_o(:,1),r_' char(finger) '_position_o(:,2),r_' char(finger) '_position_o(:,3),' char(39) '*' char(39) ')'];
    eval(expression);
    axis equal
    
end

%%

if train
    
f = fopen(['stats_imu_' char(finger) num2str(mov_thumb) '_model.txt'],'w');

p_input = p_S;
r_input = r_S;
expression = ['p_' char(finger) '_position_o'];
p_output = eval(expression); 
expression = ['r_' char(finger) '_position_o'];
r_output = eval(expression); 

name = ['imu_' char(finger) '_model'];
t_input = [p_input;r_input];
t_output = [p_output;r_output];

for k=1:2
   if k==1
       input = p_input;
       output = p_output;
   elseif k==2
       input = r_input;
       output = r_output;
   end
for i = min_hidden:max_hidden
    per_arr = [];
    for j=1:timesToTrain
        train_prediction(input, output, i, delay, name);
        [performance, prediction] = test_prediction(t_input, t_output, i, delay, name);
        per_arr = [per_arr performance];
    end
    %beep
    mean_per = mean(per_arr);
    if mean_per < min_per
        min_per = mean_per;
        expression = ['copyfile ' name '.m b_' name '.m'];
        eval(expression)
    end
    fprintf(f,[num2str(mean_per) ',' num2str(i) '\n']);
end
end
end

%%

