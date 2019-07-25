function [y1] = flex_middle_z(x1)
%FLEX_MIDDLE_Z neural network simulation function.
%
% Auto-generated by MATLAB, 25-Jul-2019 20:35:06.
% 
% [y1] = flex_middle_z(x1) takes these arguments:
%   x = 1xQ matrix, input #1
% and returns:
%   y = 1xQ matrix, output #1
% where Q is the number of samples.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = 61.5186524756864;
x1_step1.gain = 0.190907655755773;
x1_step1.ymin = -1;

% Layer 1
b1 = [-0.24339501690999371109;0.20645278715436043981];
IW1_1 = [2.0936641176152752664;1.4420056340227080938];

% Layer 2
b2 = -0.1927710003669341754;
LW2_1 = [-0.52307145689200940097 1.4835913870051871122];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 0.0532231090441924;
y1_step1.xoffset = 6.92316888754443;

% ===== SIMULATION ========

% Dimensions
Q = size(x1,2); % samples

% Input 1
xp1 = mapminmax_apply(x1,x1_step1);

% Layer 1
a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*xp1);

% Layer 2
a2 = repmat(b2,1,Q) + LW2_1*a1;

% Output 1
y1 = mapminmax_reverse(a2,y1_step1);
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