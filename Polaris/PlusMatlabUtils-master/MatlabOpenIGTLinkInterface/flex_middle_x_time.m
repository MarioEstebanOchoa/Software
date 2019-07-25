function [Y,Xf,Af] = flex_middle_x_time(X,Xi,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Auto-generated by MATLAB, 22-Jul-2019 15:19:27.
%
% [Y,Xf,Af] = myNeuralNetworkFunction(X,Xi,~) takes these arguments:
%
%   X = 2xTS cell, 2 inputs over TS timesteps
%   Each X{1,ts} = 1xQ matrix, input #1 at timestep ts.
%   Each X{2,ts} = 1xQ matrix, input #2 at timestep ts.
%
%   Xi = 2x2 cell 2, initial 2 input delay states.
%   Each Xi{1,ts} = 1xQ matrix, initial states for input #1.
%   Each Xi{2,ts} = 1xQ matrix, initial states for input #2.
%
%   Ai = 2x0 cell 2, initial 2 layer delay states.
%   Each Ai{1,ts} = 10xQ matrix, initial states for layer #1.
%   Each Ai{2,ts} = 1xQ matrix, initial states for layer #2.
%
% and returns:
%   Y = 1xTS cell of 2 outputs over TS timesteps.
%   Each Y{1,ts} = 1xQ matrix, output #1 at timestep ts.
%
%   Xf = 2x2 cell 2, final 2 input delay states.
%   Each Xf{1,ts} = 1xQ matrix, final states for input #1.
%   Each Xf{2,ts} = 1xQ matrix, final states for input #2.
%
%   Af = 2x0 cell 2, final 0 layer delay states.
%   Each Af{1ts} = 10xQ matrix, final states for layer #1.
%   Each Af{2ts} = 1xQ matrix, final states for layer #2.
%
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = 62.4094389919131;
x1_step1.gain = 0.212207306955733;
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = -8.85521507263184;
x2_step1.gain = 0.109215057654308;
x2_step1.ymin = -1;

% Layer 1
b1 = [-0.35358158101372572091;1.4358081779707316805;-0.029900594029994898015;0.22749777457385814139;0.27935495429514423105;0.59954274740702451219;-0.5583864847014796684;-0.082731178838792260311;0.51105558834869502238;0.67874934909377859782];
IW1_1 = [-2.0394565299313294204 1.738481748075141109;-1.7796432259673555798 0.26034992987561994537;-0.08914045516282623205 0.032799301449195676639;2.6119711682368667027 -2.6159461117209801273;2.5176494995987361847 -2.4180041758143584474;-0.12234792249888813698 -2.1498882731681807634;-0.12856823180838844456 2.3555873695599336415;-0.43301423630040120072 0.068203514761767114472;0.24548841627058876069 -2.5074676119638148464;1.0910516813696842231 0.028756855861636298338];
IW1_2 = [0.2871933534744685601 0.62752174526746107297;-3.5857290499540601658 3.7245612249842632302;-3.9880471996140993696 4.0671091133195060863;2.9345626271596292334 -4.2777393732405455395;1.2691698124247792201 -2.4757944992180078714;-0.88429027525417680522 1.1912096626594654847;-0.7224692362755690267 0.61532087740705010415;0.52969106191976345066 -0.80763425894940543692;2.1468519834075632247 -2.2873814379625367899;3.5882545089541828531 -3.3526803834351852629];

% Layer 2
b2 = -0.20966387821171986183;
LW2_1 = [2.1221362535729020316 0.73213763637657580663 -1.838927986936631509 -1.3999836524902626866 2.8847232480109905595 1.6397369712016329757 3.1249556684703323484 -3.8094350390454292388 1.55895084338866452 -1.0021560074554722863];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 0.109215057654308;
y1_step1.xoffset = -8.85521507263184;

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX
    X = {X};
end
if (nargin < 2), error('Initial input states Xi argument needed.'); end

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
    Q = size(X{1},2); % samples/series
elseif ~isempty(Xi)
    Q = size(Xi{1},2);
else
    Q = 0;
end

% Input 1 Delay States
Xd1 = cell(1,3);
for ts=1:2
    Xd1{ts} = mapminmax_apply(Xi{1,ts},x1_step1);
end

% Input 2 Delay States
Xd2 = cell(1,3);
for ts=1:2
    Xd2{ts} = mapminmax_apply(Xi{2,ts},x2_step1);
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS
    
    % Rotating delay state position
    xdts = mod(ts+1,3)+1;
    
    % Input 1
    Xd1{xdts} = mapminmax_apply(X{1,ts},x1_step1);
    
    % Input 2
    Xd2{xdts} = mapminmax_apply(X{2,ts},x2_step1);
    
    % Layer 1
    tapdelay1 = cat(1,Xd1{mod(xdts-[1 2]-1,3)+1});
    tapdelay2 = cat(1,Xd2{mod(xdts-[1 2]-1,3)+1});
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*tapdelay1 + IW1_2*tapdelay2);
    
    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1);
end

% Final Delay States
finalxts = TS+(1: 2);
xits = finalxts(finalxts<=2);
xts = finalxts(finalxts>2)-2;
Xf = [Xi(:,xits) X(:,xts)];
Af = cell(2,0);

% Format Output Arguments
if ~isCellX
    Y = cell2mat(Y);
end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
y = bsxfun(@minus,x,settings.xoffset);
y = bsxfun(@times,y,settings.gain);
y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
x = bsxfun(@minus,y,settings.ymin);
x = bsxfun(@rdivide,x,settings.gain);
x = bsxfun(@plus,x,settings.xoffset);
end