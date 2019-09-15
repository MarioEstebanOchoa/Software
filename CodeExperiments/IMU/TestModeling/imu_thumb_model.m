function [y1,xf1,xf2] = imu_thumb_model(x1,x2,xi1,xi2)
%IMU_THUMB_MODEL neural network simulation function.
%
% Auto-generated by MATLAB, 13-Aug-2019 14:23:05.
% 
% [y1,xf1,xf2] = imu_thumb_model(x1,x2,xi1,xi2) takes these arguments:
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
x1_step1.xoffset = [-30.7567157484679;-35.4266175003306;27.9010400689877;-28.0882337405785;-14.5412758190209;-26.6940489010155];
x1_step1.gain = [0.102959720023148;0.108759321537454;0.157286383535318;0.0610774975514393;0.218976220462129;0.0953362700977042];
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = [0;0;0];
x2_step1.gain = [0.078398395366927;0.162343260450646;0.122613055640241];
x2_step1.ymin = -1;

% Layer 1
b1 = [0.063210467068407522051;0.22498969080925998454;0.136974768961019705;0.13752988703748350585;0.025052510184784795161;0.21152203521679019405;0.36994038218503094706;-0.060493817570778242454;-0.16442794172698996236;0.067930422085557190526];
IW1_1 = [-0.83138731203424953708 -1.3334551389935678234 1.4850528306651944455 -0.018962358523724468645 -0.95939361470153661227 0.70226092783230398275 -0.13482975559793786147 1.4563164864402062815 -1.4590232600494232873 0.87280931545363771296 0.30591421833392073992 -0.96368145614098776885;-0.20882079211598963964 0.74097963510046516156 0.13490702311310007189 0.5330488524596351807 0.31386497086311632154 0.59050602927256190533 0.10126713242877211085 -0.32198611215706063327 -0.2253366199150534932 -0.70599833043943571731 -0.65294246396834942914 -0.54053112069221176395;0.49649066315137996286 0.42291167025959103265 -0.44418234667936384863 -0.42096877061697574041 0.28451880237012905361 0.4816914908041615706 -0.31015363356030989372 -0.38657123334920018287 0.32970586561251136182 0.46550951264446460698 -0.2822017430818622441 -0.43366172326646784674;0.074356646093997266767 -1.4879595363303004252 -0.71847373899909139361 -0.07637577610716660137 -0.2456864888401412983 0.36240005356700144556 0.15741070927846903538 0.61399617352193480713 0.49628225748024468178 0.50901982588502359128 0.16994094972321607817 -0.49362337888181090362;0.43709272214981603755 0.31017886152250850884 -0.16588792346640265918 0.077915437219842495487 0.02863366315263914455 0.46447825488402044725 -0.33734441964095268629 -0.18426044622384535332 0.33629668284074998308 0.36299410211080196387 -0.28551184544985341862 0.01162935554913231348;0.11689188947378020833 -0.22115916109665467726 -0.016462245086088293095 -0.69745992092968001064 0.10721672582347292757 -0.38524134260948289521 -0.23200254714753504315 0.064191880547580321137 -0.19196080079981284183 0.42996003303222735115 0.19318529830012215465 -0.066750888081320181033;-0.25645014672360233465 0.59552281237864335139 0.018665727046798859939 1.2142475510040111608 -0.76890429366978774173 0.83388053052855604097 0.79340075721393299446 -0.49582509874831875996 0.70288901627912725445 -0.69905155794505491329 0.6193971020779992509 0.0020964039628202490312;0.54456215593317958135 0.55042689969911617887 -0.87991558072356101938 -0.066458584776206724998 0.35567997252940508623 -0.099826314136121627185 0.068585023155056851207 -0.50542013138895791613 0.90214572002884818591 -0.48270750893206187948 0.10254430101397117581 0.38555934075220643642;-0.51245721843232616699 0.86929207552312082186 0.73654277147529523262 0.12338283566876651065 -0.29050317652377283251 0.26041214817578928198 0.51131439737722306216 -1.010254791396744567 -0.51159560842229490074 0.38449971951645783852 0.19467750299771516276 -0.66901758696235469337;0.022273183650280577867 0.37701830124583118886 -0.12314137108614291172 0.15775373471524770097 0.01174517706978459898 0.37412988509774142143 0.068828795233243048046 -0.29238676401178609332 0.21707820302381067301 0.03375580306334183267 -0.15871709705468420304 -0.14210989770115939335];
IW1_2 = [1.7701214868030088478 0.56561602087653695126 0.24885327522032865688 0.1354645315941400141 1.1525677064482737766 -0.4525188735997959788;-0.18406210091662600359 -1.1225539036814169425 -0.12424649156498135394 -0.28970507391980349077 0.43982442153652290262 -0.88379731462728350344;-0.58232366482473185698 1.4830898428820076251 0.69114807945336897976 0.40490316536599574304 -1.4942673997137072561 -0.61480032978058329896;0.0047833977837996180874 0.15862182991124137987 1.1660958815630126928 0.11086355980033728297 -0.53187112372677425309 1.2845608611471985849;-0.26677408501409843877 1.3045287262708922249 1.1275328358267753259 1.0852737071625000453 -0.79355083153064420731 -1.3383645539053734552;0.20416934485599474991 -1.5369751354837422053 1.0087293468207794156 -0.34045353963562569044 0.46274448721990829592 0.10404089528469272208;-0.96552867417754595358 -0.72639704651990244511 1.0037043333935244949 1.2816731070853244479 -0.30206741005289616808 -0.061541612640671629342;-0.97061549966927929134 0.9584490878860006946 -0.81980904094258999493 -0.21628863630888942038 -1.8987790472042966883 0.75869394004833512479;0.02015503677896427967 -0.18801319190402390746 -0.57176894733661332015 0.53101884417356270962 1.0725963103535445242 -0.086185781331000008154;-0.015879324275587660548 1.0509800692821411605 0.59859733077415921976 0.37196411021048636503 -0.58751618887486423137 -0.55058561909834946579];

% Layer 2
b2 = [0.26903371771135192736;0.023659657364913429939;-0.31235723805345355641];
LW2_1 = [1.0473953099584583093 1.1369061786937888492 -3.1994677568174587634 0.84472330116538307809 2.1669106182276536288 1.5136773577748612318 -0.99994397160486370169 2.864406184791218557 0.79448190877546953637 1.4942611998194288425;-0.32634940104398862948 -0.66818321014898574006 0.72191134466184081475 -0.33387221264307931357 -1.0722194349333435959 -0.54404710923710331016 0.052178097567810034774 -0.84741932229821204103 -0.25333176407137980579 1.1662203531208490404;-0.48127011895320848112 -0.48058432360737279865 0.85004410391356810539 -0.33157412158775545485 -1.2344636249469917999 0.041219107976183673447 0.3612212783120671844 -1.264756630694309214 -0.46887870087375782546 1.4190511968976748935];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.078398395366927;0.162343260450646;0.122613055640241];
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