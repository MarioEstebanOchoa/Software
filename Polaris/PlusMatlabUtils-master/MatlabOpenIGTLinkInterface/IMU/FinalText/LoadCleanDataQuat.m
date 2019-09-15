clc
clear
close all

folder = "AngleEstimation";  %Position estimation: euler angles, Angle estimation: quaternions

if folder == "PositionEstimation"
    angle = "QuatToPos";
    fingers = ["middle","index","thumb1","thumb2"];
    movements = ["periodic","random"];
    max_test = 5;
elseif folder == "AngleEstimation"
    angle = "QuatToQuat";
    fingers = ["middle","index","thumb"];
    movements = ["random"];
    max_test = 2;
end

discardSamples = 5;

if angle == "QuatToPos"
    in_meas = [];
    in_dimension = 'wxyz';   %Quat angles
    out_dimension = 'xyz';  %Position
    out_meas = 'position';
elseif angle == "QuatToQuat"
    in_meas = [];
    in_dimension = 'wxyz';  %Quat angles
    out_dimension = 'xyz';  %Euler angles MUST change to Quaternions to compare
    out_meas = 'orientation';
end

for c =1:length(fingers)
    
    finger = fingers(c);
    finger_d = finger;
        
    
if angle == "QuatToPos"    
switch finger
    case "middle"
        IMUs = [10, 6];
    case "index"
        IMUs = [10, 8];
    case "thumb1"    
        IMUs = [10, 11, 7];
        finger_d = "thumb";
    case "thumb2"
        IMUs = [10, 11, 8];
        finger_d = "thumb";
    otherwise
end
elseif angle == "QuatToQuat"
switch finger
    case "middle"
        IMUs = [8, 11, 4, 5];
    case "index"
        IMUs = [8, 6, 4, 5];
    case "thumb"
        IMUs = [8, 9, 4 ,5];
    otherwise
end   
end


for b = 1:length(movements)
    mov = movements(b);
for a = 1:max_test
close all
    
path = [char(folder) '\' char(finger) '\' char(mov) '_t' num2str(a) '.csv']
data = readtable(path);

input_tmp = [];
output_tmp = [];
title = [];

for i = 1:length(IMUs)
    for j  = 1:length(in_dimension)
        expression = ['data.S' num2str(IMUs(i)) in_meas '_' in_dimension(j) '(discardSamples:end)'];
        name = ['S' num2str(IMUs(i)) in_meas '_' in_dimension(j)];
        title = [title string(name)];
        in = eval(expression);
        if iscell(in)
            in = str2double(in);
        end
        input_tmp = [input_tmp in];
    end
end

if angle == "QuatToQuat"
    for j  = 1:length(in_dimension)
        expression = ['data.S5_4_rel' in_meas '_' in_dimension(j) '(discardSamples:end)'];
        name = ['S5_4_rel' in_meas '_' in_dimension(j)];
        title = [title string(name)];
        in = eval(expression);
        if iscell(in)
            in = str2double(in);
        end
        input_tmp = [input_tmp in];
    end
    finger_d = "middle";
end


for j  = 1:length(out_dimension)
    expression = ['data.' char(finger_d) '_pose_' out_meas '_' out_dimension(j) '(discardSamples:end)'];
    name = [char(finger_d) '_pose_' out_meas '_' out_dimension(j)];
    title = [title string(name)];
    out = eval(expression);
        if iscell(out)
            out = str2double(out);
        end
    output_tmp = [output_tmp out];
end


% figure('units','normalized','outerposition',[0 0.5 0.5 0.5])
% plot(input_tmp)
% figure('units','normalized','outerposition',[0 0 0.5 0.5])
% plot(output_tmp)

%[output_tmp, ind, ~] = unique(output_tmp,'stable','rows');
%input_tmp = input_tmp(ind,:);

input_tmp = rmmissing(input_tmp);
output_tmp = rmmissing(output_tmp);

f1 = find(~any(input_tmp,2));
for i=1:length(f1)
    input_tmp(f1(i),:)=[];
    output_tmp(f1(i),:)=[];
end
f2 = find(~any(output_tmp,2));
for i=1:length(f2)
    input_tmp(f2(i),:)=[];
    output_tmp(f2(i),:)=[];
end

%input_tmp = input_tmp(any(input_tmp,2),:);
%output_tmp = output_tmp(any(output_tmp,2),:);

% figure('units','normalized','outerposition',[0.5 0.5 0.5 0.5])
% plot(input_tmp)
% figure('units','normalized','outerposition',[0.5 0 0.5 0.5])
% plot(output_tmp)


input = input_tmp;
if angle == "QuatToPos"
    output = output_tmp*1000; 
elseif angle == "QuatToQuat"
    output = output_tmp;
    %output = eul2quat(output_tmp);
end

figure('units','normalized','outerposition',[0 0.5 0.5 0.5])
plot(input)
figure('units','normalized','outerposition',[0 0 0.5 0.5])
plot(output)
pause(5)

T = array2table([input output],'VariableNames',title);

filename = [char(folder) '\' char(finger) '\' char(mov) '_t' num2str(a)  '_quat1.csv'];
writetable(T,filename)

end
end
end


