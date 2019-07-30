function prediction = train_prediction(input, output, hidden, name)
% Solve an Input-Output Fitting problem with a Neural Network
% Script generated by Neural Fitting app
% Created 22-Jul-2019 16:31:14
%
% This script assumes these variables are defined:
%
%   filtered - input data.
%   mid_x_filt - target data.

x = input';
t = output';

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainbr';  % Bayesian Regularization backpropagation.

% Create a Fitting Network
hiddenLayerSize = hidden;
net = fitnet(hiddenLayerSize,trainFcn);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivision
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 10/100;
net.divideParam.testRatio = 20/100;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Mean Squared Error

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};

% Train the Network
net.trainParam.showWindow = false;
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
performance = perform(net,t,y); %UNCOMMENT TO SEE PERFORMANCE

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t .* tr.valMask{1};
testTargets = t .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y); %UNCOMMENT TO SEE PERFORMANCE
valPerformance = perform(net,valTargets,y); %UNCOMMENT TO SEE PERFORMANCE
testPerformance = perform(net,testTargets,y); %UNCOMMENT TO SEE PERFORMANCE

% View the Network
%view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, ploterrhist(e)
%figure, plotregression(t,y)
%figure, plotfit(net,x,t)

% Generate a matrix-only MATLAB function for neural network code
% generation with MATLAB Coder tools.
genFunction(net,name,'MatrixOnly','yes');
expression = [name,'(x)'];
prediction = eval(expression);

end
