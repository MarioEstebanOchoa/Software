function  [performance, output, prediction] = test_estimator(input, output, hidden, name)
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
%performance = mean(abs(mean(gsubtract(output,prediction))));
error = gsubtract(prediction(1:end-1,:), output(1:end-1,:));
m_error = mean(error);
max_t = max(output);
min_t = min(output);
range_t = max_t - min_t;
p_error = [abs(m_error(1)*100/range_t(1)) abs(m_error(2)*100/range_t(2)) abs(m_error(3)*100/range_t(3))];
performance = mean(p_error);
end
