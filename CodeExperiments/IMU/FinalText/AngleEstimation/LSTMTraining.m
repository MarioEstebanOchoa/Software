fingers = ["middle","index","thumb"];
mov = "random";
f = fopen(['nnm_exp5_stats' '.txt'],'w');
c = 1;

finger = fingers(c);
path_l = [char(finger) '\' char(mov) '_t' num2str(1) '_quat.csv'];
data = readtable(path_l);
[input, output] = get_datasets_exp5(data, finger);


path_lt = [char(finger) '\' char(mov) '_t' num2str(2) '_quat.csv']; 
data_t = readtable(path_lt);
[input_t, output_t] = get_datasets_exp5(data_t, finger);
X = input';
Y = output';
X_t = input_t';
Y_t = output_t';

XValidation = X_t;
YValidation = Y_t;

%%

mu = mean(X,2);
sig = std(X,0,2);

dataTrainStandardized = zeros(size(X));

for i = 1:size(X,2)
    dataTrainStandardized(:,i) = (X(:,i) - mu) ./ sig;
end
X = dataTrainStandardized;

numTimeStepsTrain = floor(0.5*size(X,2));

XTrain = X(:,1:numTimeStepsTrain+1);
XTest = X(:,numTimeStepsTrain+1:end);
YTrain = Y(:,1:numTimeStepsTrain+1);
YTest = Y(:,numTimeStepsTrain+1:end);

numFeatures = size(XTrain,1);
numResponses = size(YTrain,1);
numHiddenUnits1 = 50;
numHiddenUnits2 = 120;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits1)
    %dropoutLayer(0.5)
    %lstmLayer(numHiddenUnits2)
    %dropoutLayer(0.5)
    fullyConnectedLayer(numResponses)
    regressionLayer];

options = trainingOptions('adam', ...
    'MaxEpochs',250, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');


net = trainNetwork(XTrain,YTrain,layers,options);


%%
YPred = predict(net,XTrain);
error = gsubtract(YPred', YTrain');
m_error = mean(error);
max_t = max(YTrain');
min_t = min(YTrain');
range_t = max_t - min_t;
p_error = [abs(m_error(1)*100/range_t(1)) abs(m_error(2)*100/range_t(2)) abs(m_error(3)*100/range_t(3))];
performance = mean(p_error)

YPred = predict(net,XTest);
error = gsubtract(YPred', YTest');
m_error = mean(error);
max_t = max(YTest');
min_t = min(YTest');
range_t = max_t - min_t;
p_error = [abs(m_error(1)*100/range_t(1)) abs(m_error(2)*100/range_t(2)) abs(m_error(3)*100/range_t(3))];
performance = mean(p_error)

%%

%fprintf(f,[num2str(c) ',' num2str(a) ',' num2str(b) ',' num2str(mean(performance)) '\n']);

%save('defineHidden_exp5','performance_f')
toc()



function [input, output] = get_datasets_exp5(data, finger)
    in1 = data{:,1:4};
    in2 = data{:,5:8};
    in3 = data{:,9:12};
    in4 = data{:,13:16};
    input = [in1 in2 in3 in4];
    output = data{:,21:23};
end
