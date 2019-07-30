function [y1] = flex_thumb_x(x1)
%FLEX_THUMB_X neural network simulation function.
%
% Auto-generated by MATLAB, 29-Jul-2019 20:54:48.
% 
% [y1] = flex_thumb_x(x1) takes these arguments:
%   x = 2xQ matrix, input #1
% and returns:
%   y = 1xQ matrix, output #1
% where Q is the number of samples.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [52.4964427338317;33.7437982467825];
x1_step1.gain = [0.116423921759623;0.149465087282209];
x1_step1.ymin = -1;

% Layer 1
b1 = [-0.0003983921857103758595;0.00039341062358425884452;0.0004316897857229712982;0.41369815385688890608;-0.00027594321506811523735;-0.34654407862215852454;-0.00045403817944198387405;-0.00044457060703775240192;0.0002409639026258812277;-0.00044549542114012398398];
IW1_1 = [0.00096415427907907956008 -0.00052810989715008959181;-0.00095209818602839035515 0.00052150618412634321824;-0.0010447393833387145449 0.00057225036665337525484;-1.1826215997659268453 -1.1067645401761139201;0.00066781171284116059086 -0.00036578912607308907909;-0.56750621597932071616 0.31515710884792175195;0.0010988259450397971743 -0.00060187632638408490159;0.0010759129433077739557 -0.00058932570430059269973;-0.00058315766930654340267 0.0003194203111542588268;0.0010781511366541819599 -0.00059055167678746561984];

% Layer 2
b2 = 0.33736533597928103356;
LW2_1 = [-0.0011692807521618369098 0.0011546596068633084575 0.0012670112149335284023 -0.92651561445494712288 -0.00080988923759662395912 0.6193961318437493091 -0.0013326053694421547639 -0.0013048173309517547159 0.00070722473286262529848 -0.0013075317282305036915];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 0.0388481887614866;
y1_step1.xoffset = 20.8867392410723;

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
