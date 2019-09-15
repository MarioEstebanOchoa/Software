function  prediction = test_time_series(input, output, hidden, delay, name)

X = tonndata(input,false,false);
T = tonndata(output,false,false);
trainFcn = 'trainbr';  % Bayesian Regularization backpropagation.
inputDelays = 1:delay;
feedbackDelays = 1:delay;
hiddenLayerSize = hidden;
net = narxnet(inputDelays,feedbackDelays,hiddenLayerSize,'open',trainFcn);
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.inputs{2}.processFcns = {'removeconstantrows','mapminmax'};
[x,xi,~,~] = preparets(net,X,{},T);

x1 = cell2mat(x(1,:));
x2 = cell2mat(x(2,:));
xi1 = cell2mat(xi(1,:));
xi2 = cell2mat(xi(2,:));

expression = [name '(x1,x2,xi1,xi2)'];
prediction = eval(expression)';

end
