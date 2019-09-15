function [y1,xf1,xf2] = flex_thumb2_time(x1,x2,xi1,xi2)
%FLEX_THUMB2_TIME neural network simulation function.
%
% Auto-generated by MATLAB, 06-Aug-2019 18:36:38.
% 
% [y1,xf1,xf2] = flex_thumb2_time(x1,x2,xi1,xi2) takes these arguments:
%   x1 = 2xTS matrix, input #1
%   x2 = 3xTS matrix, input #2
%   xi1 = 2x1 matrix, initial 1 delay states for input #1.
%   xi2 = 3x1 matrix, initial 1 delay states for input #2.
% and returns:
%   y1 = 3xTS matrix, output #1
%   xf1 = 2x1 matrix, final 1 delay states for input #1.
%   xf2 = 3x1 matrix, final 1 delay states for input #2.
% where TS is the number of timesteps.

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [55.0872957664198;27.1156434515906];
x1_step1.gain = [0.137170066897646;0.347969480641399];
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = [0;0;0];
x2_step1.gain = [0.0665354379391824;0.135326913911388;0.239879029576595];
x2_step1.ymin = -1;

% Layer 1
b1 = [-0.71077188527770851501;-0.92413814864717003239;0.14541766936380137731];
IW1_1 = [-1.1223031286721387723 0.028660098217693833617 0.43289701941686142828 -0.0060616951782788315584;0.41502173756401355975 -0.34143602134664940984 0.72750356841626506732 0.37644563503395456205;-0.38684846405307332651 -0.47517111741564954652 -0.17190242500445979124 0.33342211100763408105];
IW1_2 = [0.035966912081879992558 0.3457908287902360378 0.32038182701112127848 -0.33436121984562761078 -0.25303669903817410658 -0.097745770956679994823;-0.51364472498059909888 0.26603245139038955713 -0.19303099189325581553 -1.215565504364563898 0.20553302417324717521 0.32364513053059762449;-0.28938347329281155496 -0.15371269355449848626 -0.32239388327343615481 0.84858724794531370517 0.46203747957817764558 -0.32116399533038114678];

% Layer 2
b2 = [-0.47389127001712771925;0.62512995563761852846;0.24857474278875493767];
LW2_1 = [-0.68959814726446799771 -0.53787865092990616578 -0.72042812139229472912;0.81917356502674543162 0.48717835435671147382 0.57970819038405174695;0.91445736180974024343 -0.47654715860027679897 -0.72782729641522869724];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.0665354379391824;0.135326913911388;0.239879029576595];
y1_step1.xoffset = [0;0;0];

% ===== SIMULATION ========

% Dimensions
TS = size(x1,2); % timesteps

% Input 1 Delay States
xd1 = mapminmax_apply(xi1,x1_step1);
xd1 = [xd1 zeros(2,1)];

% Input 2 Delay States
xd2 = mapminmax_apply(xi2,x2_step1);
xd2 = [xd2 zeros(3,1)];

% Allocate Outputs
y1 = zeros(3,TS);

% Time loop
for ts=1:TS

      % Rotating delay state position
      xdts = mod(ts+0,2)+1;
    
    % Input 1
    xd1(:,xdts) = mapminmax_apply(x1(:,ts),x1_step1);
    
    % Input 2
    xd2(:,xdts) = mapminmax_apply(x2(:,ts),x2_step1);
    
    % Layer 1
    tapdelay1 = reshape(xd1(:,mod(xdts-[0 1]-1,2)+1),4,1);
    tapdelay2 = reshape(xd2(:,mod(xdts-[0 1]-1,2)+1),6,1);
    a1 = tansig_apply(b1 + IW1_1*tapdelay1 + IW1_2*tapdelay2);
    
    % Layer 2
    a2 = b2 + LW2_1*a1;
    
    % Output 1
    y1(:,ts) = mapminmax_reverse(a2,y1_step1);
end

% Final delay states
finalxts = TS+(1: 1);
xits = finalxts(finalxts<=1);
xts = finalxts(finalxts>1)-1;
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