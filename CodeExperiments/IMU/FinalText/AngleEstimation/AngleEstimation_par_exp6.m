
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
            per = get_best_model(finger, a, c)
            performance = [performance per]; 
        end
        performance_h = [performance_h mean(performance)];
    end
    performance_f(c,:) = performance_h;
end

save('defineHidden_exp6','performance_f')

figure
plot(performance_f')
legend('middle','index','thumb')
xlabel('# of hidden neurons')
ylabel('Average Error')

toc()

function [performance] = get_best_model(finger, hidden_n, c)
        [XTrain, XTest, YTrain, YTest] = get_datasets_exp6(c);
        %plot_dataset(input,output)
        name = [char(finger) '_nnm'];
        train_prediction(XTrain, YTrain, hidden_n, name);
        [performance, ~ , ~] = test_prediction(XTest, YTest, hidden_n, name);
end

function [XTrain, XTest, YTrain, YTest] = get_datasets_exp6(c)

    model1 = load('bestModelFingers_exp1.mat');
    model2 = load('bestModelFingers_exp2.mat');
    in1 = cell2mat(model1.results_finger(c).b_estimation)';
    out1 = rmmissing(cell2mat(model1.results_finger(c).b_target)');
    in2 = cell2mat(model2.results_finger(c).b_estimation)';
    out2 = rmmissing(cell2mat(model2.results_finger(c).b_target)');

    XTrain = [in1(1:end-1,:) in2(1:end-1,:)];
    YTrain = out1;
    
    in1 = model1.results_finger(c).b_estimation_t;
    out1 = model1.results_finger(c).b_target_t;
    in2 = model2.results_finger(c).b_estimation_t;
    out2 = model2.results_finger(c).b_target_t;
    
    XTest = [in1 in2];
    YTest = out1;
    
end
