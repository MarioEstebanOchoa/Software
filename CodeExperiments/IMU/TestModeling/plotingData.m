finger = "middle";
mov = "periodic";

path = [char(finger) '\' char(mov) '.csv'];
data = readtable(path);

disc_data = 3;

S8 = [data.S8_x(disc_data:end) data.S8_y(disc_data:end) data.S8_z(disc_data:end)];
S9 = [data.S9_x(disc_data:end) data.S9_y(disc_data:end) data.S9_z(disc_data:end)];
S10 = [data.S10_x(disc_data:end) data.S10_y(disc_data:end) data.S10_z(disc_data:end)];
S11 = [data.S11_x(disc_data:end) data.S11_y(disc_data:end) data.S11_z(disc_data:end)];

middle_position = [data.middle_pose_position_x(disc_data:end) data.middle_pose_position_y(disc_data:end) data.middle_pose_position_z(disc_data:end)];
index_position = [data.index_pose_position_x(disc_data:end) data.index_pose_position_y(disc_data:end) data.index_pose_position_z(disc_data:end)];
thumb_position = [data.thumb_pose_position_x(disc_data:end) data.thumb_pose_position_y(disc_data:end) data.thumb_pose_position_z(disc_data:end)];

middle_position = middle_position*1000;
index_position = index_position*1000;
thumb_position = thumb_position*1000;

middle_position_f = SimpleKalmanFilter(middle_position,middle_position(1,:),1,1,1);
index_position_f = SimpleKalmanFilter(index_position,index_position(1,:),1,1,1);
thumb_position_f = SimpleKalmanFilter(thumb_position,thumb_position(1,:),1,1,1);

middle_position_o = offset(middle_position_f);
index_position_o = offset(index_position_f);
thumb_position_o = offset(thumb_position_f);

S8_f = SimpleKalmanFilter(S8,S8(1,:),1,1,3);
S9_f = SimpleKalmanFilter(S9,S9(1,:),1,1,3);
S10_f = SimpleKalmanFilter(S10,S10(1,:),1,1,3);
S11_f = SimpleKalmanFilter(S11,S11(1,:),1,1,3);

if finger == "middle"
    S = S9_f - S8_f;
elseif finger == "index"
    S = S9_f - S8_f;
elseif finger == "thumb"
    S1 = S11_f - S8_f;
    if mov == "periodic1" || mov == "random1" 
        S2 = S9_f - S8_f;
    else
        S2 = S10_f - S8_f;
    end
end

figure
if finger == "thumb"
    subplot(3,1,1)
    plot(S1)
    subplot(3,1,2)
    plot(S2)
    subplot(3,1,3)
    expression = ['plot(' char(finger) '_position_o)'];
    eval(expression);
else
    subplot(2,1,1)
    plot(S)
    subplot(2,1,2)
    expression = ['plot(' char(finger) '_position_o)'];
    eval(expression);
end

figure 
expression = ['plot3(' char(finger) '_position_o(:,1),' char(finger) '_position_o(:,2),' char(finger) '_position_o(:,3),' char(39) '*' char(39) ')'];
eval(expression);
axis equal


