function [y1,xf1,xf2] = imu_thumb2_model(x1,x2,xi1,xi2)
%IMU_THUMB2_MODEL neural network simulation function.
%
% Auto-generated by MATLAB, 13-Aug-2019 18:17:29.
% 
% [y1,xf1,xf2] = imu_thumb2_model(x1,x2,xi1,xi2) takes these arguments:
%   x1 = 6xTS matrix, input #1
%   x2 = 3xTS matrix, input #2
%   xi1 = 6x2 matrix, initial 2 delay states for input #1.
%   xi2 = 3x2 matrix, initial 2 delay states for input #2.
% and returns:
%   y1 = 3xTS matrix, output #1
%   xf1 = 6x2 matrix, final 2 delay states for input #1.
%   xf2 = 3x2 matrix, final 2 delay states for input #2.
% where TS is the number of timesteps.

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [-39.5814202801957;-33.4308049557301;19.0002317167649;-44.1577593052167;-17.2162419428127;-14.6323239927647];
x1_step1.gain = [0.272119631152624;0.127788634674506;0.153480033001078;0.0612382787802275;0.212617392349855;0.134009155806164];
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = [0;0;0];
x2_step1.gain = [0.0791754664967608;0.169360254337403;0.161009431206112];
x2_step1.ymin = -1;

% Layer 1
b1 = [-0.083432537986037225153;-0.14013298666247181457;-0.010780165625461590045];
IW1_1 = [-0.056912653928829923244 -0.073205442316375379797 -0.028349873361839614955 -0.12648843291318315196 0.01896479607199213005 -0.13862486732998938188 0.058319977031636771603 0.07025788725864044737 0.018598535775319561397 0.1036387444246747308 -0.0037205669423494404716 0.11146186549191045012;0.038857132274330630217 0.27644869619225198587 -0.087082369930986697204 -0.1744330128507028399 -0.11985730712636345763 -0.042790199682134821835 -0.032807500252204295499 -0.24966592804424342367 0.067760906203478410426 0.15758546006934126549 0.10164565021359774077 0.045942580771255139838;-0.035535867082095329295 -0.14575902735023629764 -0.13857381653564790347 -0.0084178594733053512672 0.015022129814014469062 -0.037618331937340959703 0.044697203429546278342 0.13592426001637733513 0.12407407261930683551 -0.0025616772928007017045 -0.0032682177172434672199 0.030225251438752188948];
IW1_2 = [0.32839449829809863601 -0.74455916766528584816 0.62624590438396332548 -0.11433388569251524969 0.20991864763781936665 -0.16533871101154520855;0.48301612425894818736 0.75786455237075212032 0.72430594914733592571 -0.006318413713001556388 -0.16266734172147714887 -0.20862089550019272122;0.70511637986508801657 0.17986624359810740592 -0.43520913550297068983 -0.26346079892105672693 -0.094570349203739564881 0.12866084151071832675];

% Layer 2
b2 = [0.10667116357741013299;0.027697603284046079519;0.14760484227911435662];
LW2_1 = [0.6298201767031702536 0.40176250908560845465 1.6264589673152540783;-1.0457178051338533731 0.70656408362712996851 -0.385648906847464501;0.63844697007372985809 0.70309170643123497513 -1.1349769058989662707];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.0791754664967608;0.169360254337403;0.161009431206112];
y1_step1.xoffset = [0;0;0];

% ===== SIMULATION ========

% Dimensions
TS = size(x1,2); % timesteps

% Input 1 Delay States
xd1 = mapminmax_apply(xi1,x1_step1);
xd1 = [xd1 zeros(6,1)];

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
    tapdelay1 = reshape(xd1(:,mod(xdts-[1 2]-1,3)+1),12,1);
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