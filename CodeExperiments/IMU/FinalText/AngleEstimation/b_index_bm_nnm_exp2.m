function [y1,xf1,xf2] = index_bm_nnm_exp2(x1,x2,xi1,xi2)
%INDEX_BM_NNM_EXP2 neural network simulation function.
%
% Auto-generated by MATLAB, 19-Sep-2019 16:59:01.
% 
% [y1,xf1,xf2] = index_bm_nnm_exp2(x1,x2,xi1,xi2) takes these arguments:
%   x1 = 5xTS matrix, input #1
%   x2 = 3xTS matrix, input #2
%   xi1 = 5x2 matrix, initial 2 delay states for input #1.
%   xi2 = 3x2 matrix, initial 2 delay states for input #2.
% and returns:
%   y1 = 3xTS matrix, output #1
%   xf1 = 5x2 matrix, final 2 delay states for input #1.
%   xf2 = 3x2 matrix, final 2 delay states for input #2.
% where TS is the number of timesteps.

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [-0.243305173348851;-0.219825888098686;-0.114146581971269;-0.122262021623615;-0.0996763403382762];
x1_step1.gain = [4.34104126660651;4.49298712468227;8.96062932618266;9.14244933957193;11.3103470004906];
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = [-34.63462114;-56.51672659;-19.90957524];
x2_step1.gain = [0.0209968573482885;0.041868259268193;0.0430280155650301];
x2_step1.ymin = -1;

% Layer 1
b1 = [0.12776284977210822236;0.12010060459777623099;-0.083591928917071317562;0.044873633660096522158;-0.46781052570575959448];
IW1_1 = [-0.050495930524197464584 0.063370575925431008035 -0.06877782074495200626 -0.16575325342581781474 -0.28298134892561044307 -0.059801808803421452332 -0.12895352241016963535 0.045147292163895069717 0.066483307596184121335 0.15990679941258201247;0.084151742996142558928 0.26012750996707362239 0.13429079669771759598 0.10493809010085645983 0.24124695278487473526 0.14320006990588113327 -0.0082614868647674765539 -0.070648728660907628152 -0.0750253866442326528 -0.27473472608779386794;0.05505748554995328059 0.59202357491228652098 0.11227455880603225136 -0.10631982625713577717 -0.37753523313022313568 -0.091017540548502848252 -0.4363004526044796938 -0.048830881070074848294 -0.069547412645514200547 0.024936245285232094132;0.0052287086600695852415 -0.31570330217502534653 -0.024946679017151064672 -0.053351874091166179293 0.013354317791137493288 -0.060975215806388538553 0.088813704571734222726 -0.023854675413480776192 0.063945485062468027104 0.085778696302825321873;-0.20240458865934221611 -0.82644698319304632506 -0.15941560060235562823 0.015149086644701562077 0.095185021633591146428 0.12545165035249705721 0.5309049281203345183 0.075229569573455404297 0.15399356401745856182 0.21849623009202523427];
IW1_2 = [2.1858278611646362322 -0.46215901579418766643 -0.36908798246113561081 -1.7203693244678952556 0.28388432368060395605 0.49959601204471226765;-0.79254419944187981528 -0.32329195773980634598 0.31191201409145796752 0.88468396481663869046 -0.0099420190092387936143 -0.48636520938747257459;1.171724196307574184 -0.032973311123082722773 -2.0220105145092714949 -1.1705408452950081255 0.03686585054480107787 1.4779417584714231726;0.83593069191492586079 0.53204674248652628066 1.1391220811806439528 -0.30586298377274734328 -0.1148394251866061283 -0.43358356196122421755;-0.48400317250488367193 0.1612863959103982836 -0.25209501561398384162 0.28803316516515081736 -0.0032680948620211207507 -0.23278782210045434464];

% Layer 2
b2 = [0.075089077107302143466;0.33563856842493589028;-0.44447855959423748784];
LW2_1 = [0.80091425131916860192 1.2864242651428063891 0.63977781419903634319 0.93464102940721471846 0.71624275950299487459;-1.3706488321733341085 -0.16106857543551494905 1.2914575074547520739 1.2793687168414136224 0.28603644359088331584;0.099886058323344184551 -0.69744802138274863967 -1.0733929376118824806 -0.18830054380431060501 -1.027693014201611188];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.0209968573482885;0.041868259268193;0.0430280155650301];
y1_step1.xoffset = [-34.63462114;-56.51672659;-19.90957524];

% ===== SIMULATION ========

% Dimensions
TS = size(x1,2); % timesteps

% Input 1 Delay States
xd1 = mapminmax_apply(xi1,x1_step1);
xd1 = [xd1 zeros(5,1)];

% Input 2 Delay States
xd2 = mapminmax_apply(xi2,x2_step1);
xd2 = [xd2 zeros(3,1)];

% Allocate Outputs
y1 = zeros(3,TS);

% Time loop
for ts=1:TS

      % Rotating delay state position
      xdts = mod(ts+1,3)+1;
    
    % Input 1
    xd1(:,xdts) = mapminmax_apply(x1(:,ts),x1_step1);
    
    % Input 2
    xd2(:,xdts) = mapminmax_apply(x2(:,ts),x2_step1);
    
    % Layer 1
    tapdelay1 = reshape(xd1(:,mod(xdts-[1 2]-1,3)+1),10,1);
    tapdelay2 = reshape(xd2(:,mod(xdts-[1 2]-1,3)+1),6,1);
    a1 = tansig_apply(b1 + IW1_1*tapdelay1 + IW1_2*tapdelay2);
    
    % Layer 2
    a2 = b2 + LW2_1*a1;
    
    % Output 1
    y1(:,ts) = mapminmax_reverse(a2,y1_step1);
end

% Final delay states
finalxts = TS+(1: 2);
xits = finalxts(finalxts<=2);
xts = finalxts(finalxts>2)-2;
xf1 = [xi1(:,xits) x1(:,xts)];
xf2 = [xi2(:,xits) x2(:,xts)];
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
