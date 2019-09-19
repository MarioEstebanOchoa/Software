Folders index, little, middle and thumb have the data collected from the IMU sensor array and the Polaris

To define the number of hidden neurons Execute the file AngleEstimation_par_expN.m 


To train the best model modify the file bestModel_expN.m Change the number of neurons according to the result from AngleEstimation_par_expN.m 
Then execute the file bestModel_expN.m


To plot the results and obtain the stats execute the file plotDataBestModels.m
It is necesary to modify the variable c to choose the finger c=1 => middle, c=2 => index, c=3 => thumb
And, it is necesary to change the load instruction load('bestModelFingers_expN.mat') according to the experiment that want to evaluate

exp1 = input => IMU over the links, 1 hidden layer, PCA
exp2 = input => IMU over the palm surface, 1 hidden layer, PCA
exp3 = input1 => IMU over the links, input2 => IMU over the palm surface, 1 hidden layer, PCA
exp4 = input1 => IMU over the links, input2 => IMU over the palm surface, 2 hidden layer, PCA
exp5 = input1 => IMU over the links, input2 => IMU over the palm surface, 2 hidden layer, PCA
exp6 = input1 => output_exp1, input2 => output_exp2, 1 hidden layer 