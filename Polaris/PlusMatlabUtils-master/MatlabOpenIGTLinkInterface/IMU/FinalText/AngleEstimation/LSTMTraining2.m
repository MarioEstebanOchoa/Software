fingers = ["middle","index","thumb"];
mov = "random";
f = fopen(['nnm_exp5_stats' '.txt'],'w');
c = 1;

finger = fingers(c);
path_l = [char(finger) '\' char(mov) '_t' num2str(1) '_quat.csv'];
data = readtable(path_l);
[data] = get_datasets_exp5(data);

chk = floor(0.01*size(data,1));
d1 = []

for i = chk:chk:size(data,1)
    d1 = [d1 chk]
end
d1 = [d1 size(data,1)-sum(d1)]
    
d2 =  size(data,2);   
data = mat2cell(data',[d2],[d1]);

[XTrain,YTrain] = prepareDataTrain(data);

m = min([XTrain{:}],[],2);
M = max([XTrain{:}],[],2);
idxConstant = M == m;

for i = 1:numel(XTrain)
    XTrain{i}(idxConstant,:) = [];
end

mu = mean([XTrain{:}],2);
sig = std([XTrain{:}],0,2);

for i = 1:numel(XTrain)
    XTrain{i} = (XTrain{i} - mu) ./ sig;
end


for i=1:numel(XTrain)
    sequence = XTrain{i};
    sequenceLengths(i) = size(sequence,2);
end

[sequenceLengths,idx] = sort(sequenceLengths,'descend');
XTrain = XTrain(idx);
YTrain = YTrain(idx);


% figure
% bar(sequenceLengths)
% xlabel("Sequence")
% ylabel("Length")
% title("Sorted Data")

miniBatchSize = 20;

numResponses = size(YTrain{1},1);
featureDimension = size(XTrain{1},1);
numHiddenUnits = 100;

layers = [ ...
    sequenceInputLayer(featureDimension)
    lstmLayer(numHiddenUnits,'OutputMode','sequence')
    %fullyConnectedLayer(50)
    dropoutLayer(0.5)
    fullyConnectedLayer(numResponses)
    regressionLayer];

maxEpochs = 250;
miniBatchSize = 20;

options = trainingOptions('adam', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',0.01, ...
    'GradientThreshold',1, ...
    'Shuffle','never', ...
    'Plots','training-progress',...
    'Verbose',0);

net = trainNetwork(XTrain,YTrain,layers,options);


finger = fingers(c);
path_l = [char(finger) '\' char(mov) '_t' num2str(2) '_quat.csv'];
data = readtable(path_l);
[data] = get_datasets_exp5(data);

chk = floor(0.01*size(data,1));
d1 = []

for i = chk:chk:size(data,1)
    d1 = [d1 chk]
end
d1 = [d1 size(data,1)-sum(d1)]
    
d2 =  size(data,2);   
data = mat2cell(data',[d2],[d1]);

[XTest,YTest] = prepareDataTrain(data);

YPred = predict(net,XTest);



%%

YPred = predict(net,XTrain);
error = gsubtract(YPred', YTrain');
m_error = mean(error{1,1}');
max_t = max(YTrain{1,1}');
min_t = min(YTrain{1,1}');
range_t = max_t - min_t;
p_error = [abs(m_error(1)*100/range_t(1)) abs(m_error(2)*100/range_t(2)) abs(m_error(3)*100/range_t(3))];
performance = mean(p_error)


YPred = predict(net,XTest);
error = gsubtract(YPred', YTest');
m_error = mean(error{1,1}');
max_t = max(YTest{1,1}');
min_t = min(YTest{1,1}');
range_t = max_t - min_t;
p_error = [abs(m_error(1)*100/range_t(1)) abs(m_error(2)*100/range_t(2)) abs(m_error(3)*100/range_t(3))];
performance = mean(p_error)


%%




mu = mean(X,2);
sig = std(X,0,2);

dataTrainStandardized = zeros(size(X));

for i = 1:size(X,2)
    dataTrainStandardized(:,i) = (X(:,i) - mu) ./ sig;
end
X = dataTrainStandardized;

numTimeStepsTrain = floor(0.75*size(X,2));

XTrain = X(:,1:numTimeStepsTrain+1);
XTest = X(:,numTimeStepsTrain+1:end);
YTrain = Y(:,1:numTimeStepsTrain+1);
YTest = Y(:,numTimeStepsTrain+1:end);

numFeatures = size(XTrain,1);
numResponses = size(YTrain,1);
numHiddenUnits1 = 20;

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits1)
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
    'ValidationData',{XValidation,YValidation}, ...
    'ValidationFrequency',1, ...
    'Plots','training-progress');


net = trainNetwork(XTrain,YTrain,layers,options);

YPred = predict(net,XTrain);

%%
error = gsubtract(YPred', YTrain');
m_error1 = mean(error);
YPred = predict(net,X_t);
error = gsubtract(YPred', Y_t');
m_error = mean(error);
max_t = max(Y_t');
min_t = min(Y_t');
range_t = max_t - min_t;
p_error = [abs(m_error(1)*100/range_t(1)) abs(m_error(2)*100/range_t(2)) abs(m_error(3)*100/range_t(3))];
performance = mean(p_error)


%%

fprintf(f,[num2str(c) ',' num2str(a) ',' num2str(b) ',' num2str(mean(performance)) '\n']);

%save('defineHidden_exp5','performance_f')
toc()

function [data] = get_datasets_exp5(data)
    in1 = data{:,1:4};
    in2 = data{:,5:8};
    in3 = data{:,9:12};
    in4 = data{:,13:16};
    input = [in1 in2 in3 in4];
    output = data{:,21:23};
    data = [input output]
end


function [XTrain,YTrain] = prepareDataTrain(dataTrain)


numObservations = size(dataTrain,2);

XTrain = cell(numObservations,1);
YTrain = cell(numObservations,1);
for i = 1:numObservations
    
    X = dataTrain{:,i}(1:16,:);
    XTrain{i} = X;
    Y = dataTrain{:,i}(17:19,:);
    YTrain{i} = Y;
end

end