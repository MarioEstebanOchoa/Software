function [y1,xf1,xf2] = thumb_bm_nnm_exp2(x1,x2,xi1,xi2)
%THUMB_BM_NNM_EXP2 neural network simulation function.
%
% Auto-generated by MATLAB, 27-Aug-2019 18:46:58.
% 
% [y1,xf1,xf2] = thumb_bm_nnm_exp2(x1,x2,xi1,xi2) takes these arguments:
%   x1 = 8xTS matrix, input #1
%   x2 = 3xTS matrix, input #2
%   xi1 = 8x2 matrix, initial 2 delay states for input #1.
%   xi2 = 3x2 matrix, initial 2 delay states for input #2.
% and returns:
%   y1 = 3xTS matrix, output #1
%   xf1 = 8x2 matrix, final 2 delay states for input #1.
%   xf2 = 3x2 matrix, final 2 delay states for input #2.
% where TS is the number of timesteps.

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [0.2185;0.0567;0.9076;0.0855;0.2868;-0.0432;0.7555;0.1799];
x1_step1.gain = [12.5234815278647;11.5606936416185;45.7665903890159;16.6666666666667;7.46825989544436;10.4112441436752;11.8764845605701;7.69526741054252];
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = [19.91904251;2.583829047;15.72255665];
x2_step1.gain = [0.0470926729892737;0.0376234231319031;0.06953254154686];
x2_step1.ymin = -1;

% Layer 1
b1 = [0.15719431983834836197;0.11534373824881048731;0.059842553875497028759;0.036224079838350069227;0.21961469041873932229];
IW1_1 = [-0.098795592681670124646 0.053820291514496659824 -0.23724370015089718544 0.17416126648196508797 -0.12934011193765454495 -0.15270120580769439012 0.014706024163132689481 -0.23235705637127529455 0.12013500938924938366 -0.04318562877403838568 0.26275495016882083332 -0.1522661772262090818 -0.032505313322115231278 0.12918276227349489993 -0.21047135738821778905 0.076135435376846929967;-0.19852540632887152872 0.46604478554061812279 0.64737353360851457307 0.67884234547737221099 0.13843050426773112482 0.034861529652514877675 0.016691423396981507066 0.26027319459625003484 0.2841954132264279953 -0.1482713383892100556 -0.48128107003529801977 -0.42348563245791520648 -0.40829616311560484876 -0.030907457272842712992 -0.16136802717973350307 -0.11978670011280560803;-0.12817532821669236354 0.72953355454629731369 0.05919386822469071413 1.1768525843340160719 -0.53117829704813646075 0.081156690961551675167 -0.13993251979158038978 -0.26662582848895355347 0.19761911778942783946 -0.30917663238082698784 0.2195529412944745018 -0.70624871203557049171 -0.17882426678624768757 -0.35978007876498696582 -0.69619185917080050885 -0.36054449228434104491;0.52667899646831140004 0.19072425681765561856 -0.83322951328951022631 0.22879809618254071113 -0.87348371839204264067 -0.13973458849964026651 -0.31771963779388134874 -0.96632377036494054856 -0.66526790080169284636 -0.32581722079123065505 0.77627638357226524946 -0.23430447989810720966 0.61213386688044069128 -0.13930401720158139267 -0.29378014696249477034 0.11324044695505798563;0.43372470124759598953 -0.72665593413863471817 -0.63343500926318052624 -1.2209874130100974998 0.21847393221226027449 -0.14423952437355125333 0.080911190908949839895 -0.1234479005274332214 -0.60324699283699723118 0.1984849686633982091 0.28058861326731071584 0.69731984604618602042 0.48388015457109562201 0.35642209832270660419 0.60239303727537363287 0.46108814043818552308];
IW1_2 = [0.13257547715769779639 0.38950597792782692963 -0.51530966123117760702 0.010501953330528782798 -0.37985780643105843124 0.20774869058850101156;-0.38313442900298105842 -0.92263131148949417693 0.39150627820676553448 0.31214123585015546292 0.62615376060799632363 -0.75193289768501214709;-0.31148526087547889762 -0.32889160514964238535 0.15423007782026285084 0.58654896130066302984 -0.15807635063670918973 -0.50821747960728269611;0.35704017257678682951 2.1822706557667737037 -1.0536390928680139378 -0.00054955112527809541704 -1.6353749169749518533 1.0735878758714427761;1.2729551996751582443 1.8926346175671351357 -1.1011793261940612254 -0.91311932399835615826 -0.87335819498695055341 1.3991829793839873908];

% Layer 2
b2 = [-0.35952387271054697671;-0.18074918560406227908;0.35794394180050215226];
LW2_1 = [0.20500497636167341886 -1.5181777712081518938 2.8039051001432251375 -1.9396952123130752899 1.9140211685067181069;-1.6446990238383005778 3.0401700460043867835 -1.1476980802247465085 1.8295466889925058318 0.36602461903409228006;-3.2269054136884496309 -0.34441966453403399795 1.0392365607681439688 0.059182926266721454234 0.28043535990337992159];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.0470926729892737;0.0376234231319031;0.06953254154686];
y1_step1.xoffset = [19.91904251;2.583829047;15.72255665];

% ===== SIMULATION ========

% Dimensions
TS = size(x1,2); % timesteps

% Input 1 Delay States
xd1 = mapminmax_apply(xi1,x1_step1);
xd1 = [xd1 zeros(8,1)];

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
    tapdelay1 = reshape(xd1(:,mod(xdts-[1 2]-1,3)+1),16,1);
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