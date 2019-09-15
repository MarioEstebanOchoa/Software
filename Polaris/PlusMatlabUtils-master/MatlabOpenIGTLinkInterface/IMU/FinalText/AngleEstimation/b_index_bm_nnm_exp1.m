function [y1,xf1,xf2] = index_bm_nnm_exp1(x1,x2,xi1,xi2)
%INDEX_BM_NNM_EXP1 neural network simulation function.
%
% Auto-generated by MATLAB, 13-Sep-2019 14:48:07.
% 
% [y1,xf1,xf2] = index_bm_nnm_exp1(x1,x2,xi1,xi2) takes these arguments:
%   x1 = 4xTS matrix, input #1
%   x2 = 3xTS matrix, input #2
%   xi1 = 4x2 matrix, initial 2 delay states for input #1.
%   xi2 = 3x2 matrix, initial 2 delay states for input #2.
% and returns:
%   y1 = 3xTS matrix, output #1
%   xf1 = 4x2 matrix, final 2 delay states for input #1.
%   xf2 = 3x2 matrix, final 2 delay states for input #2.
% where TS is the number of timesteps.

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [-0.371862690036612;-0.198067671995971;-0.191015447811475;-0.129623597510109];
x1_step1.gain = [2.8290149021078;4.5126842411244;5.54697661976749;8.56584163065018];
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = [-29.69847451;-53.08714143;-33.15052065];
x2_step1.gain = [0.0215259017867669;0.0437499215793593;0.0404677022966254];
x2_step1.ymin = -1;

% Layer 1
b1 = [-0.07583825664482127249;-0.011905723380159905292;-0.10434822719442900241;-0.030678043669432233931;-0.17675591775128926542];
IW1_1 = [-0.0076757105882814483794 0.3451053106251574798 -0.16112027922116572975 0.1977561705762790889 0.082432951597556633483 -0.33201364380898112927 0.19859917848795255457 -0.32480148686656862278;-0.011074980575146551806 -0.098826912627187277205 -0.080515670947295336912 -0.033720487939881874095 -0.029484393904402592113 0.053515073944925724281 0.046498932142657864452 0.076018876927047590586;0.60258971468929745097 0.26820271986438487533 1.0185905291037347098 0.085825238155660940609 -0.34204753918209934715 -0.09900936026776777088 -1.4650818925710478169 -0.16814509630799276407;0.021924783118777671498 0.30314382054144350942 -0.094441505812004833409 0.078631260076722442331 0.091736344416685752789 -0.2436514102982516583 0.13496444082843109258 -0.23319526757050876298;-0.31157051090493709244 -0.22185947837431044261 -0.54697920051004311759 -0.036405549404104675659 0.11692874563294583523 0.11048501958903446385 0.69960133248458855615 0.16471820269199374809];
IW1_2 = [-1.9043486885744844717 0.88923940917914712223 0.0003501297299134503954 1.6610509267993323057 -0.67856172574660389429 -0.085161122208890771557;0.33766240420215615226 0.33462864805275444047 0.63322754777234679935 -0.19523960479685803504 -0.061781245448854847646 -0.1837583890432062661;0.38999949744929640616 0.34239749618961529132 -2.4655159337778735917 -0.55066901994575079282 -0.24900717203519787124 1.7328201948495847162;-0.70385058317625148749 0.69633657749482180677 0.21281593354856379041 1.1042133569265684123 -0.58819067118158385732 -0.16741017542981845301;-0.030781336643006911025 0.26090988415710336668 0.29087840841486800603 -0.13447587591977416821 0.10848715826651149363 -0.32033283895203962244];

% Layer 2
b2 = [0.044718596712925648418;0.31636027976666686312;-0.20904559488244886523];
LW2_1 = [-1.6384411591809537878 -0.17670734623468967173 0.23802665910335488175 1.6914434782001566138 0.59024540273003900381;0.40763145673818157455 0.94651040435190059164 0.75868277913857606887 0.41572795139287155308 1.1565477888324766642;0.46052705003086291669 1.4965954638892138284 -0.60324445750392796661 -0.70738307975865233335 -1.091941420804596774];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.0215259017867669;0.0437499215793593;0.0404677022966254];
y1_step1.xoffset = [-29.69847451;-53.08714143;-33.15052065];

% ===== SIMULATION ========

% Dimensions
TS = size(x1,2); % timesteps

% Input 1 Delay States
xd1 = mapminmax_apply(xi1,x1_step1);
xd1 = [xd1 zeros(4,1)];

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
    tapdelay1 = reshape(xd1(:,mod(xdts-[1 2]-1,3)+1),8,1);
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