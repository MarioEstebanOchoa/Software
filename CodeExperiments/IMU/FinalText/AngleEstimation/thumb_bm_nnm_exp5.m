function [y1,xf1,xf2] = thumb_bm_nnm_exp5(x1,x2,xi1,xi2)
%THUMB_BM_NNM_EXP5 neural network simulation function.
%
% Auto-generated by MATLAB, 13-Sep-2019 14:39:00.
% 
% [y1,xf1,xf2] = thumb_bm_nnm_exp5(x1,x2,xi1,xi2) takes these arguments:
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
x1_step1.xoffset = [-0.272484189700909;-0.21676763725856;-0.180517740526315;-0.162560619199683];
x1_step1.gain = [3.00685442929844;3.19703941041068;4.74195484082141;7.50272416774596];
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = [-4.60253906;8.007185151;25.69303831];
x2_step1.gain = [0.0354831019441904;0.0377222788091497;0.0621721513247483];
x2_step1.ymin = -1;

% Layer 1
b1 = [-0.22047418620602587946;0.12064662800636161144;0.47684781247059748743;-0.11232278874339915453;-0.30370414264995687637;0.034584021791883315378;0.43940394425526785316];
IW1_1 = [0.43088635340564296339 0.20377788288077286483 -0.56207300060467590974 0.31582734370710024985 -0.85152326028571201366 -0.51962995290827063144 -0.30470349492446180406 0.030047714441154692311;-0.10514880863223256824 0.59577490900943030905 0.75117568746235174881 -0.63578144985032480907 0.8884619969004129425 -0.53677014007066825574 -0.77944844571765892205 0.57106882286469751175;-0.13281043491921237787 0.20505110274589147257 0.57465722341223746117 -0.53484251204965682636 0.96419756763557051826 -0.25480935530460574467 -0.39442051348011303302 0.44538413931274883906;0.1450024031980756134 0.037975517514944670538 -0.25903504144145289567 0.012551948658201618481 0.28604564178125457818 -0.14946703566580016309 0.39903293079852641956 -0.080082486696742519183;-0.041687275760213589326 0.03871231974111568469 0.38227355884901803584 -0.24073220112325172115 0.14137182204562140364 -0.0564691184919591041 -0.50608788915217128856 0.29789651263674332693;-0.09029563283379145322 -0.59355544406943616664 0.2378559214957333412 -0.0086919996826080054425 -0.21065544445616857239 0.32561741959758161435 -0.27273330915485177739 0.20232192498662215918;0.53752516765155400336 0.90766067094689961703 -0.55200740718097485171 0.15836453219626547839 -0.61938325197413501844 -1.0376937737091709302 -0.45164547305117169751 0.01166731658274397683];
IW1_2 = [1.3424525190770320027 -0.77686010602275856751 1.1337297444387803846 -0.31359252245285079708 0.69774783868495071637 -1.1876233759991545735;-1.6859929710529351077 1.0803271797429443435 -0.0076789429060723632045 1.2957056890351064116 -0.54482014588376193043 0.10279618197841568217;-1.5999467695884950214 -0.079684012154522587679 0.54889413512698326247 1.2147069308909761443 0.25509028206766393154 -0.57762243610556107676;-0.17992977311580188315 -0.42187116950827935336 -0.45580025817043062775 -0.19695129908185354806 0.64484790781611933674 -0.0062765019776917724617;-0.21861475150117937183 0.69628886584336546761 -0.11300613588965328915 0.60449983264795803528 -0.57957077419721514389 -0.20027384102919254527;0.0035496218699172664597 -0.56231745261992083229 1.6174900808893222237 0.60379706570664914977 0.40125392831372963531 -1.6860410425863632256;2.0674453383875812662 0.72486312816585063423 -0.60474433029281471352 -0.89987628022330390376 0.022159451364439933241 0.47237745463561392478];

% Layer 2
b2 = [0.56216113532090949967;-0.60697741187764997495;-0.25616273548592094489;-0.031231493435299111788;-0.41382806259899129753;-1.2914095686225370851;-0.27714980198446009796;-0.17200405530338627735;0.87925797476669542707;-0.53945829171328341101];
LW2_1 = [-0.69764537003009918781 0.39097405532948231732 -0.29029203463102509764 -0.42470372220007057695 1.1282653594526663721 -0.28158407450194095079 0.47682421960337956213;-0.84221858644035219044 0.36500369791051540114 -0.40838430782760043458 -0.12684653803191126009 0.81004342272345253306 0.1391588183907964682 1.5272271117657312267;-0.95134222150138425533 0.031645354260150720949 0.7330613627112914088 0.16045601228818553996 -0.74059706493774613012 0.9617852517852333305 -1.5295178368043131911;-0.72902413688330136576 -0.58674294788356473607 -0.16987318653175823013 0.66678246162522791796 -0.75284851241451467008 0.21493963298423324204 0.70897838353884845564;0.12226935952204856517 0.19040592417009716275 0.73226092115095198221 -0.72326424221829999084 -0.54834353947584768552 0.33216674255577627317 -0.094339255387633047523;-0.76700386300290324115 1.2291574822823285729 -0.72218606867147916439 -0.048601634835774773502 -0.82537754113970918102 1.3715263983154857286 1.8481066018090999137;-0.19878866178272208698 -1.0867007258295564576 0.72358258325360491625 -0.47025692989422201995 0.025747553450487493942 -0.90526614036313779454 0.35339056753284647794;-0.90155697689337699341 0.039711629777095747151 0.83496604102705107575 -0.14077729645331304997 -1.1698791771452277111 1.2763439233887312607 -0.26444086438970310082;-0.0068226538246389124148 0.83128797693417522119 -0.44461061639607096785 0.22148718702204256426 -0.77843546452471645836 0.40141453473439736577 -1.5295521129136815386;-1.3533196966579381648 0.67002624857823345206 -0.35598296514725835671 0.14504976983590867068 0.026602254479719037589 0.45404230141929036169 0.54754956177061642197];

% Layer 3
b3 = [0.76523280420351713627;0.095014148042968940566;0.47855647712512761061];
LW3_2 = [-0.05015838267229064118 0.099548841565111109708 1.4755321708203177344 -1.4179968871776944539 -1.5754817472994768757 0.72289108550146974341 1.5434984989059794547 1.504488693198085647 -1.9773478907803268001 -0.87474094242488831252;-0.83662212697742699419 1.9527488653809061958 0.22225656236604507399 0.93495885022499924943 0.055749395453063607664 0.59872263293924365968 -0.21089774684772377711 -0.37768658463042559248 1.4575235587593635689 -0.58264628659446404679;-0.77534929908123417786 0.37649936143772860797 0.53517629968188640266 -0.86804228226099722221 0.14071008006794180623 1.2949387408685331113 1.8179957954086976013 0.26338179314155057975 0.58404395519436569373 -0.65501059063253952441];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.0354831019441904;0.0377222788091497;0.0621721513247483];
y1_step1.xoffset = [-4.60253906;8.007185151;25.69303831];

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
    a2 = tansig_apply(b2 + LW2_1*a1);
    
    % Layer 3
    a3 = b3 + LW3_2*a2;
    
    % Output 1
    y1(:,ts) = mapminmax_reverse(a3,y1_step1);
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