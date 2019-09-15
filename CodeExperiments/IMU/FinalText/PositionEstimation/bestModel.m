close all

fingers = ["middle","index","thumb1","thumb2"];
movements = ["periodic","random"];

performance = [];
Hidden = 3;
timesToTrain = 1;
performance_f = zeros(length(fingers),Hidden);
% tic()
for c =1:length(fingers)
    finger = fingers(c);
    performance_h = [];
        performance = [];
        for b = 1:timesToTrain
            disp(['finger:' finger])
            disp(['timesToTrain:' num2str(b)])
            per = get_best_model(finger, movements, Hidden)
            performance = [performance per]; 
        end
        performance_h = [performance_h mean(performance)];
    performance_f(c,:) = performance_h;
end

% figure
% plot(performance_f')
% 
% legend('middle','index','thumb1','thumb2')
% xlabel('# of hidden neurons')
% ylabel('Average Error')
% 
% toc()

function [performance] = get_best_model(finger, movements, hidden_n)
performance_all = [];
for h = 1:length(movements)
    mov = movements(h);
    for i = 1:5
        path_l = [char(finger) '\' char(mov) '_t' num2str(i) '_quat1.csv'];
        data = readtable(path_l);
        [input, output] = get_datasets(data, finger);
        plot_dataset(input, output)
        name = [char(finger) '_nnm'];
        p = train_prediction(input, output, hidden_n, name);
        performance_t = [];
        for k = 1:length(movements)
            mov_t = movements(k);
            for j = 1:5
                if ~((j==i) && (mov_t == mov))
                    path_lt = [char(finger) '\' char(mov_t) '_t' num2str(j) '_quat1.csv']; 
                    data_t = readtable(path_lt);
                    [input_t, output_t] = get_datasets(data_t, finger);
                    [~, performance_ab , ~] = test_prediction(input_t, output_t, hidden_n, name);
                    performance_t = [performance_t performance_ab];
                end
            end
        end
        performance_all = [performance_all mean(performance_t)];
    end
end
performance = mean(performance_all);
end

function [input, output] = get_datasets(data, finger)
    if (finger == "middle") || (finger == "index")
        ref = data{:,1:4};
        loc = data{:,5:8};
        input = loc - ref;
        output = data{:,9:11};
    elseif (finger == "thumb1") || (finger == "thumb2")
        ref = data{:,1:4};
        loc1 = data{:,5:8};
        loc2 = data{:,9:12};
        in1 = loc1 - ref;
        in2 = loc2 - ref;
        input = [in1 in2];
        output = data{:,13:15};   
    end
    output = offset(output);
end


function [] = plot_dataset(input, output)
    figure
    subplot(2,1,1)
    plot(input)
    subplot(2,1,2)
    plot(output)
    figure
    plot3(output(:,1),output(:,2),output(:,3),'-')
    axis equal
end