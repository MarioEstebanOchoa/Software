function [y1,xf1,xf2] = index_bm_nnm_exp4(x1,x2,xi1,xi2)
%INDEX_BM_NNM_EXP4 neural network simulation function.
%
% Auto-generated by MATLAB, 12-Sep-2019 20:47:58.
% 
% [y1,xf1,xf2] = index_bm_nnm_exp4(x1,x2,xi1,xi2) takes these arguments:
%   x1 = 16xTS matrix, input #1
%   x2 = 3xTS matrix, input #2
%   xi1 = 16x2 matrix, initial 2 delay states for input #1.
%   xi2 = 3x2 matrix, initial 2 delay states for input #2.
% and returns:
%   y1 = 3xTS matrix, output #1
%   xf1 = 16x2 matrix, final 2 delay states for input #1.
%   xf2 = 3x2 matrix, final 2 delay states for input #2.
% where TS is the number of timesteps.

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [-0.2493;-0.1472;0.7933;0.3099;-0.1999;0.1149;0.7926;0.0706;-0.3634;-0.0568;0.8731;-0.3286;-0.1469;-0.0325;0.8804;0.1802];
x1_step1.gain = [5.88408355398647;10.482180293501;13.5135135135135;7.36377025036819;6.47878198898607;7.68935024990388;11.2549240292628;4.41793682350342;3.94788787998421;4.35445242760723;15.785319652723;2.87976961843053;8.22706705059646;11.4285714285714;21.2089077412513;7.6219512195122];
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = [-37.58893822;-56.51672659;-19.90957524];
x2_step1.gain = [0.0203652161747678;0.0399559081207787;0.0383263708961283];
x2_step1.ymin = -1;

% Layer 1
b1 = [0.96142429027237963357;-0.78851028869537853616;0.54059764654985076326;-3.3822854407991216341;-0.041717056266449101254;0.057032236087275228753;0.48674868855812197799;0.79746163544898307496;0.11283035786803574663;0.60736799352787851358];
IW1_1 = [0.14375471143444010225 0.046253132993598504441 -0.2853501102613164031 -0.068625168293475535819 0.036048088644334383424 -0.31709673771376911677 -0.38883868697017737182 -0.30529273185439559368 0.23115910663072666842 -0.14182117907703561954 -0.39655032128155842663 0.11516575265217131319 0.15093939100746148196 0.1237919452346858129 -0.35215864274934849387 0.057657778673144206849 -0.17063474805688402802 0.0036582547492450181309 0.12847327047891066165 -0.17708498817895371169 -0.25823149132375444736 0.067163478027829348616 -0.47303569582018872852 -0.51362040879516690506 -0.070011926105163185818 0.065729930266995029164 0.24372285005973112759 -0.15950838250233187465 0.32779436468972700247 -0.21737220442426163913 0.41669652681622204593 0.098313808180345158005;-1.1891535467546028304 -0.29249867160037568148 -0.013681673572755764789 -0.15961541691090491701 0.062651687770870462257 0.064946825376896499815 0.68206158338813605013 0.29928787680234830715 -1.164328119900277736 -0.57563410223640398833 -0.13339763602579590707 1.825829705164740302 -0.30413011516220844754 -0.075314261468161475266 0.98299173303071807339 0.4061811940470833604 0.99668078697652107145 0.34913727112893733207 -0.15766865376035152368 0.74049002661329121899 0.48423568647790643515 0.48016738750014259507 -0.13964102357216076622 0.21728951661194884082 0.48134998066816914175 0.18072496609234819931 0.072676797888300864736 -0.62836113795559278561 0.16112516475748206446 -0.22957978749409985175 0.18063235659664494959 0.11521769654986810383;0.2642612511586178714 0.084268331542413490998 -0.47139131827439512135 -0.33323032288752274521 -0.3198143731929282696 -0.10003231909609078265 -0.046728669800485789221 0.064098758175150635785 0.40370870230316141525 -0.062416894980531642534 0.16130535185080596694 -0.04245272988826760685 0.88174017983485009076 0.11636785726243872863 0.22670621117602032801 0.20877650170454384315 -0.2565256496627701388 -0.07637002091892060307 0.003574955564173542405 -0.020626566134171374356 0.1166383481795246202 0.12504058647372356949 -0.29649004984758470238 -0.42044495278828186713 0.029365152643365199925 0.26044896578201121029 -0.081493247214584951799 -0.085740808967008072528 -0.52803490658787455292 -0.098373395886618100747 -0.27665935089584425821 -0.4561604487831332766;-0.31725933045790388753 -0.092683107553955548785 0.32216631168765608173 -1.1342266475118227831 -0.66216295736439134689 -0.61362873564941278204 -1.9105649956588621752 1.1295821368319016731 -0.80430958465648505484 -0.63025368504190626417 -0.05916605154061704841 0.80141189809621271589 3.0456469531469196887 -0.43244628230143833392 -2.0751122396194703335 -0.0058817461072728054183 -0.98646956821579323549 -1.0568414035572133436 0.60014294927372657806 -1.1891802148784758053 -0.61176498562847869689 0.56219720738976208807 -0.2722828233337820647 -0.8893760739461200604 -1.2216508285354386043 -0.39484930358148934149 0.032842298003420124231 0.87879779277044922647 -0.17487059385129230527 -0.73319313957492227019 -1.1901296765576865333 -0.41236716122667693707;0.29977601258416392005 0.082769181322757470753 -0.0027827854587558773294 -0.053448600799037765396 0.10161434895797909206 0.096093391068836894742 0.10505855490598148272 0.18818404108887282211 0.45633613114390542131 -0.15338298055307234002 -0.27829792828324667608 0.037067224921852048869 0.14571588307536603724 -0.014347701969366289526 -0.39910821075052393958 -0.16437670312052723998 -0.40742543795704377896 -0.098647981705383386286 0.19561141135322801521 0.33962537453930213838 -0.28481198553731795764 0.090358172460737462561 -0.19010296465288872847 -0.145361181849955029 -0.33721818918923551767 0.30761324624309904774 0.2622581534817733373 -0.0071171716559806285848 0.089673764536634725797 0.057066924270230218186 0.00047269513226979871078 -0.43648449208948580935;-0.61805993094200373239 -0.22395190748789089996 -0.42182983349376473869 -0.2621709203375313102 -0.25850401203298511987 -0.15999210936715549392 -0.042291369920166008156 -0.12213978994846541593 0.010365433604473185333 -0.48644520643311023322 -0.30337387884250033299 0.6433892705036620141 0.64575881187472516931 0.24816236383159681611 0.70456282282650595228 0.39023387700615064233 0.37805590913352432603 0.29713743651952118086 0.012369548879126406396 0.13860157310695581101 0.13157748865086971168 0.30314201335610591048 -0.45435971896821447658 -0.37284093504989956891 0.10011362979605128998 0.3468370290680735657 0.19948162226243965067 -0.42853632409925579427 -0.17180838880580079353 -0.41636553308206508683 -0.33821150802414501335 -0.38209624919431561807;0.42905894810641564963 0.1861310238028186792 -0.13227495783320736278 -0.055737660060363208858 0.1449999483932534472 0.021832536370497007683 0.019361473115724850413 0.027781014718938203817 -0.14561376653090907229 0.063177599857182825671 0.0039288643021487788809 -0.03086435903274604986 -0.29330549437528219414 -0.081955920945733298777 -0.10385292861348356663 0.11893412719448662185 -0.27565261853192407626 -0.14722751460427618841 -0.076804997466503321935 -0.1309667549697068889 -0.081395111750332968525 -0.035130325647789999166 0.035278822477618536346 -0.03235116989354226702 0.074723624298314417214 -0.11209900098690601944 -0.026501766946136522812 0.099598159099735572575 0.17196816617722965326 0.13947262404203458752 0.3153429662656170307 0.13886783039124495076;-0.4341761717153067579 -0.32524701612738171619 0.14049815586692318559 -0.13446618225092502041 0.068088248883070995321 -0.063499529192420633983 -0.8157784264726486434 -0.56000576719865802211 0.98104667330160155725 0.24744020329322752305 -0.24353647003859596465 -1.3422758832951466879 0.45740000200230951366 0.464597421415556322 -0.38078185748108106523 -0.2884299098116704374 -0.028173541313056597868 0.15732109447856229556 0.68500518744276428507 0.29851475215999612178 -0.52223168617698256799 -0.27334384243776244094 0.18858744447462649774 0.12571877763223265889 -0.57800062516662131795 -0.04961114706366091115 0.14898891660827651151 0.25486421850287194202 -0.010568013370133674811 -0.29887054615584102146 -0.89480139933760682869 -0.65406271349790778835;-0.80453374483960293784 -0.54688158711761847286 0.79786534878927750647 -0.5519174141756135743 0.11590937869570187846 0.20635796819496948773 -0.1959107307336096504 -0.21078944763806814477 -0.25404711582471056763 -0.017150209944000086026 0.70150060572737837905 -0.067431005972387741965 -1.1935859307079292879 -0.44664448129385486697 -0.13128763883023336634 0.53990997007328811463 0.84217635876251184524 -0.021805073579525737631 0.095124563432881545366 0.81172518451598296707 0.55270331616972967481 -1.0755109877912167882 -0.059070135586349117873 -0.012096924952524661795 0.13560422180659542635 0.36869023347414875413 -0.63844020608282803231 -0.26003671491593904896 0.90087598644796185177 0.69848010485364253608 0.28987899968942842932 0.27568084131753389787;0.64067213381090493129 0.22786559898811067915 -0.50575341102923154768 0.11340365958712315952 -0.20842007920280158917 -0.34791734762283860194 -0.37103337278248688103 -0.31870462601790516821 0.15181373370234516051 -0.11147270772191483768 -0.19763917317539608787 -0.034543628755240987638 0.16115143395330303044 0.05144051062458909751 -0.16596595310547782032 0.12886262042512799941 -0.35182190384417333373 -0.065523530696171436438 -0.23064384963277573259 -0.96328884235388467783 -0.03996486504832540837 -0.037423214350350585133 -0.5313694147810493762 -0.71335222137306986134 0.12973645569444072767 -0.0047602081864836203601 0.10815702260285312009 -0.076854958223635888581 0.13814469872832446651 -0.15179179852999633016 0.58392631581453491307 0.55307810342578356266];
IW1_2 = [-0.27646720048503087286 0.11345706194696071611 -0.44825652623323475332 0.61932443337731601929 0.092955105345961380747 0.55423186270417890142;-0.8822313234105454427 -0.12092756596273754321 -0.30704753090236275304 -0.68554596050369864813 -0.078324211524684161922 -0.35189143922101528972;-0.97130763040672818409 0.2085035109992262603 0.16466179358202084893 0.97156927908732393373 0.20336201553359728456 0.24827323714928212217;-1.9304563077043936925 -1.1989267775075815869 0.36923616736592579368 -0.077828386719549558226 -0.12474453044761468767 -2.7241176658625629869;-1.4431203526554376992 0.89086397508699022296 0.36343287705146942734 1.1945080221529167375 -0.60581059213668331243 0.039960651292044860328;-0.25577990010045409397 0.3885103285356867886 0.014404310131756128607 0.46083706385519984661 0.016146531037910197975 0.11955429653870321138;-0.63131132654016686168 -0.68775839815849060255 -1.1038386361765741839 0.14531078195502050709 0.24085072545368158003 0.39950512095694529213;1.5972855137643595658 0.77211286602716433514 0.79224301617060144398 0.23801261580956725727 -0.6271695011363994654 -0.11445814961385417097;1.2215359827447738184 2.045267906526581303 -2.8491703452303172028 -1.3377753250819526265 -1.2225063849606860877 2.3862425643409759246;0.10765423093923340292 -0.36756037058969037723 -0.84706445563461651993 0.42422734528126698761 0.71845961055327178801 0.76905300655336827909];

% Layer 2
b2 = [-0.3103729997253811268;0.71189758386685575431;0.78806875987741353828];
LW2_1 = [1.4845797414200183617 0.38641031962826793977 0.86942924474787075528 0.50794013705531948499 -0.75397974621549956886 -0.82217497022781427241 -0.34515024159892798705 0.20173697086982178561 -0.20936465462114789426 -0.65655746817769133905;-1.0408163926818738698 2.1904546085912639519 1.6882380899753912651 1.6831484758575145921 0.68573491279903486806 -2.479885766886953391 0.19191338041049618712 1.6736627910823933529 -0.11757822950069191092 1.7814038961584528487;0.35961210692539158362 -0.6646295604225260778 -0.76770815411586801336 -0.65869282767974823845 -0.14685282197212387589 0.48991784707090418882 -1.7640384002779705419 -0.62999856062999037842 -0.041200488668404720849 -0.31501486659150879088];

% Layer 3
b3 = [-0.94579067644102488011;0.30191127912842791181;0.029600722356314033284];
LW3_2 = [0.62544654034481661498 -2.7992771560090488059 -0.4810791151548211575;-2.2235277783966420628 1.2412010530735344549 0.66398678513298214909;0.81387469147854940577 1.5140519403792713771 1.312434885681029062];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = [0.0203652161747678;0.0399559081207787;0.0383263708961283];
y1_step1.xoffset = [-37.58893822;-56.51672659;-19.90957524];

% ===== SIMULATION ========

% Dimensions
TS = size(x1,2); % timesteps

% Input 1 Delay States
xd1 = mapminmax_apply(xi1,x1_step1);
xd1 = [xd1 zeros(16,1)];

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
    tapdelay1 = reshape(xd1(:,mod(xdts-[1 2]-1,3)+1),32,1);
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