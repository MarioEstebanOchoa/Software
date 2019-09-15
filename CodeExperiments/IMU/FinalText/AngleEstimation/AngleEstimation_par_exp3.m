fingers = ["middle","index","thumb"];
movements = ["random"];

performance = [];
maxHidden = 10;
timesToTrain = 5;
performance_f = zeros(length(fingers),maxHidden);
tic()
parfor c =1:length(fingers)
    finger = fingers(c);
    performance_h = [];
    for a = 1:maxHidden
        performance = [];
        for b = 1:timesToTrain
            disp(['finger:' finger])
            disp(['hidden:' num2str(a)])
            disp(['timesToTrain:' num2str(b)])
            per = get_best_model(finger, movements, a)
            performance = [performance per]; 
        end
        performance_h = [performance_h mean(performance)];
    end
    performance_f(c,:) = performance_h;
end

save('defineHidden_exp3','performance_f')

figure
plot(performance_f')

legend('middle','index','thumb')
xlabel('# of hidden neurons')
ylabel('Average Error')

toc()

function [performance] = get_best_model(finger, movements, hidden_n)
performance_all = [];
for h = 1:length(movements)
    mov = movements(h);
    for i = 1:2
        path_l = [char(finger) '\' char(mov) '_t' num2str(i) '_quat.csv'];
        data = readtable(path_l);
        [input, output] = get_datasets_exp3(data, finger);
        %plot_dataset(input,output)
        name = [char(finger) '_nnm_exp3'];
        train_prediction(input, output, hidden_n, name);
        performance_t = [];
        for k = 1:length(movements)
            mov_t = movements(k);
            for j = 1:2
                if ~((j==i) && (mov_t == mov))
                    path_lt = [char(finger) '\' char(mov_t) '_t' num2str(j) '_quat.csv']; 
                    data_t = readtable(path_lt);
                    [input_t, output_t] = get_datasets_exp3(data_t, finger);
                    [performance_err, ~ , ~] = test_prediction(input_t, output_t, hidden_n, name);
                    performance_t = [performance_t performance_err];
                end
            end
        end
        performance_all = [performance_all mean(performance_t)];
    end
end
performance = mean(performance_all);
end


function [input, output] = get_datasets_exp3(data, finger)
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