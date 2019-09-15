function  [performance, performance_ab , prediction] = test_prediction(input, output, hidden, name)
delay = 2;
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

output = output(delay+1:end,:); 
performance = immse(output,prediction);
performance_ab = sqrt((output(:,1)-prediction(:,1)).^2+(output(:,2)-prediction(:,2)).^2+(output(:,3)-prediction(:,3)).^2);
performance_ab = mean(performance_ab);
end
