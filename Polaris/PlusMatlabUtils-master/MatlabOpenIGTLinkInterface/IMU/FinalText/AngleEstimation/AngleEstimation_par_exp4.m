fingers = ["middle","index","thumb"];
movements = ["random"];
mov = "random";
performance = [];
maxHidden = 10;
timesToTrain = 1;
performance_f = [];
datasets = struct([]);
f = fopen(['nnm_exp4_stats' '.txt'],'w');

tic()
for c =1:length(fingers)
    finger = fingers(c);
    path_l = [char(finger) '\' char(mov) '_t' num2str(1) '_quat.csv'];
    data = readtable(path_l);
    [input, output] = get_datasets_exp4(data, finger);
    input_1 = input;
    output_1 = output;
    path_lt = [char(finger) '\' char(mov) '_t' num2str(2) '_quat.csv']; 
    data_t = readtable(path_lt);
    [input_t, output_t] = get_datasets_exp4(data_t, finger);
    input_2= input_t;
    output_2 = output_t;
    finger = fingers(c);
    performance_h = [];
    for a = 1:maxHidden
        for b = 1:maxHidden
            performance = [];
            for d = 1:timesToTrain
                disp(['finger:' char(finger)])
                disp(['hidden1:' num2str(a)])
                disp(['hidden2:' num2str(b)])
                disp(['timesToTrain:' num2str(d)])
                hidden_arr = [a b];
                per = get_best_model(finger, movements, hidden_arr, input_1, output_1, input_2, output_2)
                performance = [performance per]; 
            end
            performance_f = [performance_f;c a b mean(performance)];
            fprintf(f,[num2str(c) ',' num2str(a) ',' num2str(b) ',' num2str(mean(performance)) '\n']);
        end
    end
end

save('defineHidden_exp4','performance_f')

% figure
% plot(performance_f')
% 
% legend('middle','index','thumb')
% xlabel('# of hidden neurons')
% ylabel('Average Error')

toc()

function [performance] = get_best_model(finger, movements, hidden_n, input_1, output_1, input_2, output_2)
performance_all = [];
name = [char(finger) '_nnm_exp4'];
for i = 1:2
    input = eval(['input_' num2str(i)]);
    output = eval(['output_' num2str(i)]);
    train_estimator(input, output, hidden_n, name);
    performance_t = [];
    for j = 1:2
        if j~=i
            input_t = eval(['input_' num2str(j)]);
            output_t = eval(['output_' num2str(j)]);
            [performance_err, ~ , ~] = test_estimator(input_t, output_t, hidden_n, name);
            performance_t = [performance_t performance_err];
        end
    end
    performance_all = [performance_all mean(performance_t)];
end
performance = mean(performance_all);
end


function [input, output] = get_datasets_exp4(data, finger)
    in1 = data{:,1:4};
    in2 = data{:,5:8};
    in3 = data{:,9:12};
    in4 = data{:,13:16};
    input = [in1 in2 in3 in4];
    output = data{:,21:23};
end

function [] = plot_dataset(input, output)
    close all
    figure
    subplot(2,1,1)
    plot(input)
    subplot(2,1,2)
    plot(output)
    figure
    plot3(output(:,1),output(:,2),output(:,3),'-')
    axis equal
end