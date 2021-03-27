function relFreqApproch()
%initialize paramters
W = [0 0 0 0 0 0]';
X0 = [-pi/3 0 0 0 0 0]';
U = [0 0 0];

%solve for noiseless ideal states
%[a,b,c,d,g,J311,A,B],[2694.6,6.7728,75.5573,7.3916,9.81,6.8707,879.6338,22.9022]

[T,Resp] = ode45(@(t,X)mStateEqIdealSys(X,W,U),[0 20],X0);
plot(T,Resp);
legend('X_1','X_2','X_3','X_4','X_5','X_6');grid;
title('Actual State Response');

%solve for 5 purturbed systems
[T,Resp1] = ode45(@(t,X)mStateEq1(X,W,U),[0 20],X0);
[T,Resp2] = ode45(@(t,X)mStateEq2(X,W,U),[0 20],X0);
[T,Resp3] = ode45(@(t,X)mStateEq3(X,W,U),[0 20],X0);
[T,Resp4] = ode45(@(t,X)mStateEq4(X,W,U),[0 20],X0);
[T,Resp5] = ode45(@(t,X)mStateEq5(X,W,U),[0 20],X0);

%ensamble of w as plant noise component ->due to model paramter
%uncertainity
Wn(:,:,1) = Resp - Resp1;
Wn(:,:,2) = Resp - Resp2;
Wn(:,:,3) = Resp - Resp3;
Wn(:,:,4) = Resp - Resp4;
Wn(:,:,5) = Resp - Resp5;
end

function dxdt = mStateEqIdealSys(x,w,u)
dxdt = [
    w(1) + x(2);
    w(2) - (7.3916*(8629.2075779999995199887052876875*sin(x(1)) - 1.0*u(1) - 75.557299999999997908162185922265*x(4)^2*sin(x(3)) + 224.67058200000000546481260244036*cos(x(1))*sin(x(3)) + 6.8707*x(4)*x(6)*sin(x(3)) + 13.5456*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (7.3916*cos(x(3))*(u(3) + 6.8707*x(2)*x(6)*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) - (75.557299999999997908162185922265*cos(x(3))*(6.7728*cos(x(3))*sin(x(3))*x(2)^2 - 6.8707*x(6)*sin(x(3))*x(2) + u(2) - 224.67058200000000546481260244036*cos(x(3))*sin(x(1))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536);
    w(3) + x(4);
    w(4) + ((6.7728*sin(x(3))^2 - 6.8707*cos(x(3))^2 + 2694.6)*(6.7728*cos(x(3))*sin(x(3))*x(2)^2 - 6.8707*x(6)*sin(x(3))*x(2) + u(2) - 224.67058200000000546481260244036*cos(x(3))*sin(x(1))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) + (75.557299999999997908162185922265*cos(x(3))^2*(u(3) + 6.8707*x(2)*x(6)*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) + (75.557299999999997908162185922265*cos(x(3))*(8629.2075779999995199887052876875*sin(x(1)) - 1.0*u(1) - 75.557299999999997908162185922265*x(4)^2*sin(x(3)) + 224.67058200000000546481260244036*cos(x(1))*sin(x(3)) + 6.8707*x(4)*x(6)*sin(x(3)) + 13.5456*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536);
    w(5) + x(6);
    w(6) + ((u(3) + 6.8707*x(2)*x(6)*sin(x(3)))*(50.06182848*sin(x(3))^2 - 5708.9055832899996838927654607687*cos(x(3))^2 + 19917.40536))/(343.959804937536*sin(x(3))^2 - 39573.109293181284828122023651304*cos(x(3))^2 + 136846.517006952) + (7.3916*cos(x(3))*(8629.2075779999995199887052876875*sin(x(1)) - 1.0*u(1) - 75.557299999999997908162185922265*x(4)^2*sin(x(3)) + 224.67058200000000546481260244036*cos(x(1))*sin(x(3)) + 6.8707*x(4)*x(6)*sin(x(3)) + 13.5456*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536) + (75.557299999999997908162185922265*cos(x(3))^2*(6.7728*cos(x(3))*sin(x(3))*x(2)^2 - 6.8707*x(6)*sin(x(3))*x(2) + u(2) - 224.67058200000000546481260244036*cos(x(3))*sin(x(1))))/(50.06182848*sin(x(3))^2 - 5759.6910494099996838927654607687*cos(x(3))^2 + 19917.40536);
    ];
end

function dxdt = mStateEq1(x,w,u)
dxdt = [w(1) + x(2);
    w(2) - (7.3987191223193491396159515716136*(8637.7076675095394520196507370624*sin(x(1)) - 1.0*u(1) - 75.558503411227107449121831450611*x(4)^2*sin(x(3)) + 224.95581077750827980122758114802*cos(x(1))*sin(x(3)) + 6.873922882057340366657172125997*x(4)*x(6)*sin(x(3)) + 13.552983626226486890686828701291*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.137359559921471460635735598972*sin(x(3))^2 - 5759.9456624172446090887427234488*cos(x(3))^2 + 19936.610976694762470568905759758) - (7.3987191223193491396159515716136*cos(x(3))*(u(3) + 6.873922882057340366657172125997*x(2)*x(6)*sin(x(3))))/(50.137359559921471460635735598972*sin(x(3))^2 - 5759.9456624172446090887427234488*cos(x(3))^2 + 19936.610976694762470568905759758) - (75.558503411227107449121831450611*cos(x(3))*(6.7764918131132434453434143506456*cos(x(3))*sin(x(3))*x(2)^2 - 6.873922882057340366657172125997*x(6)*sin(x(3))*x(2) + u(2) - 224.95581077750827980122758114802*cos(x(3))*sin(x(1))))/(50.137359559921471460635735598972*sin(x(3))^2 - 5759.9456624172446090887427234488*cos(x(3))^2 + 19936.610976694762470568905759758);
    w(3) + x(4);
    w(4) + ((6.7800396254812822505186886701267*sin(x(3))^2 - 6.8744038402848515190157741017174*cos(x(3))^2 + 2694.6010961433999000291805714369)*(6.7800396254812822505186886701267*cos(x(3))*sin(x(3))*x(2)^2 - 6.8744038402848515190157741017174*x(6)*sin(x(3))*x(2) + u(2) - 224.79194030976232427284390722239*cos(x(3))*sin(x(1))))/(50.115374329824234556346871755774*sin(x(3))^2 - 5761.05227914509204675425920419*cos(x(3))^2 + 19917.426750023645123006578421234) + (75.566126020987681499718746636063*cos(x(3))^2*(u(3) + 6.8744038402848515190157741017174*x(2)*x(6)*sin(x(3))))/(50.115374329824234556346871755774*sin(x(3))^2 - 5761.05227914509204675425920419*cos(x(3))^2 + 19917.426750023645123006578421234) + (75.566126020987681499718746636063*cos(x(3))*(8630.1940485983912532387313187566*sin(x(1)) - 1.0*u(1) - 75.566126020987681499718746636063*x(4)^2*sin(x(3)) + 224.79194030976232427284390722239*cos(x(1))*sin(x(3)) + 6.8744038402848515190157741017174*x(4)*x(6)*sin(x(3)) + 13.560079250962564501037377340253*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.115374329824234556346871755774*sin(x(3))^2 - 5761.05227914509204675425920419*cos(x(3))^2 + 19917.426750023645123006578421234);
    w(5) + x(6);
    w(6) + ((u(3) + 6.8732578275787528099272094550543*x(2)*x(6)*sin(x(3)))*(50.115651297139139636092200854113*sin(x(3))^2 - 5709.0613387874845271392246586418*cos(x(3))^2 + 19933.751228438940485644541350833))/(344.45779256226886822136812767133*sin(x(3))^2 - 39589.328440624610480717441576581*cos(x(3))^2 + 137009.81166387552722039252508419) + (7.3976614769829520668054101406597*cos(x(3))*(8632.8504965908374905327314992912*sin(x(1)) - 1.0*u(1) - 75.558330704082422357714676763862*x(4)^2*sin(x(3)) + 224.78333395209919996265639221849*cos(x(1))*sin(x(3)) + 6.8732578275787528099272094550543*x(4)*x(6)*sin(x(3)) + 13.549052346628386089832929428667*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.115651297139139636092200854113*sin(x(3))^2 - 5759.9073734399354001446549247976*cos(x(3))^2 + 19933.751228438940485644541350833) + (75.558330704082422357714676763862*cos(x(3))^2*(6.7745261733141930449164647143334*cos(x(3))*sin(x(3))*x(2)^2 - 6.8732578275787528099272094550543*x(6)*sin(x(3))*x(2) + u(2) - 224.78333395209919996265639221849*cos(x(3))*sin(x(1))))/(50.115651297139139636092200854113*sin(x(3))^2 - 5759.9073734399354001446549247976*cos(x(3))^2 + 19933.751228438940485644541350833);
 ];
end

function dxdt = mStateEq2(x,w,u)
dxdt = [w(1) + x(2);
    w(2) - (7.4014244309327574811163685808424*(8633.5161835684053382261808650197*sin(x(1)) - 1.0*u(1) - 75.566318133420622871199157088995*x(4)^2*sin(x(3)) + 224.87896676602924035769090171156*cos(x(1))*sin(x(3)) + 6.8721474957294388374862137425225*x(4)*x(6)*sin(x(3)) + 13.550542424820077869185297458898*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.146657877727066257713034956106*sin(x(3))^2 - 5761.1321166091996853572177130378*cos(x(3))^2 + 19943.882290197062187261429047226) - (7.4014244309327574811163685808424*cos(x(3))*(u(3) + 6.8721474957294388374862137425225*x(2)*x(6)*sin(x(3))))/(50.146657877727066257713034956106*sin(x(3))^2 - 5761.1321166091996853572177130378*cos(x(3))^2 + 19943.882290197062187261429047226) - (75.566318133420622871199157088995*cos(x(3))*(6.7752712124100389345926487294491*cos(x(3))*sin(x(3))*x(2)^2 - 6.8721474957294388374862137425225*x(6)*sin(x(3))*x(2) + u(2) - 224.87896676602924035769090171156*cos(x(3))*sin(x(1))))/(50.146657877727066257713034956106*sin(x(3))^2 - 5761.1321166091996853572177130378*cos(x(3))^2 + 19943.882290197062187261429047226);
    w(3) + x(4);
    w(4) + (75.566598805500518665212439373136*cos(x(3))^2*(u(3) + 6.8747977432532829666911311505828*x(2)*x(6)*sin(x(3))))/(50.149272971591441235958654614552*sin(x(3))^2 - 5761.1428682784111905627482452499*cos(x(3))^2 + 19923.834218795249891088268101527) + ((6.7824602377253340179663609887939*sin(x(3))^2 - 6.8747977432532829666911311505828*cos(x(3))^2 + 2694.6076256890123659104574471712)*(6.7824602377253340179663609887939*cos(x(3))*sin(x(3))*x(2)^2 - 6.8747977432532829666911311505828*x(6)*sin(x(3))*x(2) + u(2) - 224.7669470744226642417060101875*cos(x(3))*sin(x(1))))/(50.149272971591441235958654614552*sin(x(3))^2 - 5761.1428682784111905627482452499*cos(x(3))^2 + 19923.834218795249891088268101527) + (75.566598805500518665212439373136*cos(x(3))*(8630.0782851761221522691044386674*sin(x(1)) - 1.0*u(1) - 75.566598805500518665212439373136*x(4)^2*sin(x(3)) + 224.7669470744226642417060101875*cos(x(1))*sin(x(3)) + 6.8747977432532829666911311505828*x(4)*x(6)*sin(x(3)) + 13.564920475450668035932721977588*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.149272971591441235958654614552*sin(x(3))^2 - 5761.1428682784111905627482452499*cos(x(3))^2 + 19923.834218795249891088268101527);
    w(5) + x(6);
    w(6) + ((u(3) + 6.878381603684549538968440174358*x(2)*x(6)*sin(x(3)))*(50.14499071219668333389220554438*sin(x(3))^2 - 5709.2068122791401212287294766321*cos(x(3))^2 + 19937.277330022684995672587474182))/(344.91638163170626463507180709141*sin(x(3))^2 - 39620.163937464456847933480122332*cos(x(3))^2 + 137136.20161438505005145142317084) + (7.3989651799868800807757907023188*cos(x(3))*(8631.0201414104904478162479702522*sin(x(1)) - 1.0*u(1) - 75.559293354815991961004328913987*x(4)^2*sin(x(3)) + 224.7773773590447749381188096567*cos(x(1))*sin(x(3)) + 6.878381603684549538968440174358*x(4)*x(6)*sin(x(3)) + 13.554595674495551804739079670981*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.14499071219668333389220554438*sin(x(3))^2 - 5760.099718259464419160508390101*cos(x(3))^2 + 19937.277330022684995672587474182) + (75.559293354815991961004328913987*cos(x(3))^2*(6.7772978372477759023695398354903*cos(x(3))*sin(x(3))*x(2)^2 - 6.878381603684549538968440174358*x(6)*sin(x(3))*x(2) + u(2) - 224.7773773590447749381188096567*cos(x(3))*sin(x(1))))/(50.14499071219668333389220554438*sin(x(3))^2 - 5760.099718259464419160508390101*cos(x(3))^2 + 19937.277330022684995672587474182);
    ];
end


function dxdt = mStateEq3(x,w,u)
dxdt = [w(1) + x(2);
    w(2) - (7.3934078838489201146444429468829*(8630.9525541933506608046881144975*sin(x(1)) - 1.0*u(1) - 75.558472231150901166074618231505*x(4)^2*sin(x(3)) + 224.73713463242219045121163286732*cos(x(1))*sin(x(3)) + 6.8743054844428117533539079886395*x(4)*x(6)*sin(x(3)) + 13.56005263602839860936910554301*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.127500032309346764368845756851*sin(x(3))^2 - 5759.9072702702671949738578426765*cos(x(3))^2 + 19922.302448139435591868251261488) - (7.3934078838489201146444429468829*cos(x(3))*(u(3) + 6.8743054844428117533539079886395*x(2)*x(6)*sin(x(3))))/(50.127500032309346764368845756851*sin(x(3))^2 - 5759.9072702702671949738578426765*cos(x(3))^2 + 19922.302448139435591868251261488) - (75.558472231150901166074618231505*cos(x(3))*(6.780026318014199304684552771505*cos(x(3))*sin(x(3))*x(2)^2 - 6.8743054844428117533539079886395*x(6)*sin(x(3))*x(2) + u(2) - 224.73713463242219045121163286732*cos(x(3))*sin(x(1))))/(50.127500032309346764368845756851*sin(x(3))^2 - 5759.9072702702671949738578426765*cos(x(3))^2 + 19922.302448139435591868251261488);
    w(3) + x(4);
    w(4) + ((6.7823721284619100657664603204466*sin(x(3))^2 - 6.8806524101327708464737042959314*cos(x(3))^2 + 2694.6066905707825753779616206884)*(6.7823721284619100657664603204466*cos(x(3))*sin(x(3))*x(2)^2 - 6.8806524101327708464737042959314*x(6)*sin(x(3))*x(2) + u(2) - 224.88568789717130696624981246151*cos(x(3))*sin(x(1))))/(50.187099495672233066551981471894*sin(x(3))^2 - 5760.4722489734901276006009608519*cos(x(3))^2 + 19939.114445501252435026154023279) + (75.561616651292936808204103726894*cos(x(3))^2*(u(3) + 6.8806524101327708464737042959314*x(2)*x(6)*sin(x(3))))/(50.187099495672233066551981471894*sin(x(3))^2 - 5760.4722489734901276006009608519*cos(x(3))^2 + 19939.114445501252435026154023279) + (75.561616651292936808204103726894*cos(x(3))*(8636.2495148757494736388435541978*sin(x(1)) - 1.0*u(1) - 75.561616651292936808204103726894*x(4)^2*sin(x(3)) + 224.88568789717130696624981246151*cos(x(1))*sin(x(3)) + 6.8806524101327708464737042959314*x(4)*x(6)*sin(x(3)) + 13.564744256923820131532920640893*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.187099495672233066551981471894*sin(x(3))^2 - 5760.4722489734901276006009608519*cos(x(3))^2 + 19939.114445501252435026154023279);
    w(5) + x(6);
    w(6) + ((u(3) + 6.8743509222012715298433249699883*x(2)*x(6)*sin(x(3)))*(50.156405909942449199901277386035*sin(x(3))^2 - 5710.3583049642327590654674977915*cos(x(3))^2 + 19932.818071459127475989588998817))/(344.79273522131418117321641106886*sin(x(3))^2 - 39604.57882030978477896808278859*cos(x(3))^2 + 137025.18629160522363721581704641) + (7.3972989233110304496676690177992*cos(x(3))*(8634.5939264064456000271022139428*sin(x(1)) - 1.0*u(1) - 75.566912765867527923546731472015*x(4)^2*sin(x(3)) + 224.86883861595822409050019455991*cos(x(1))*sin(x(3)) + 6.8743509222012715298433249699883*x(4)*x(6)*sin(x(3)) + 13.560735189944830736408221127931*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.156405909942449199901277386035*sin(x(3))^2 - 5761.2099336394944142009137046312*cos(x(3))^2 + 19932.818071459127475989588998817) + (75.566912765867527923546731472015*cos(x(3))^2*(6.7803675949724153682041105639655*cos(x(3))*sin(x(3))*x(2)^2 - 6.8743509222012715298433249699883*x(6)*sin(x(3))*x(2) + u(2) - 224.86883861595822409050019455991*cos(x(3))*sin(x(1))))/(50.156405909942449199901277386035*sin(x(3))^2 - 5761.2099336394944142009137046312*cos(x(3))^2 + 19932.818071459127475989588998817);
    ];
end

function dxdt = mStateEq4(x,w,u)
dxdt = [w(1) + x(2);
    w(2) - (7.3919825198947686217820773890708*(8630.9354042512073293421548267775*sin(x(1)) - 1.0*u(1) - 75.563856502993601793605193961412*x(4)^2*sin(x(3)) + 224.71559054661650186194446790372*cos(x(1))*sin(x(3)) + 6.8799874527800186641002255782951*x(4)*x(6)*sin(x(3)) + 13.555299330375342847787578648422*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.100267851037898269580460617581*sin(x(3))^2 - 5760.7531565930536755177372028873*cos(x(3))^2 + 19918.474952513809056085394841939) - (7.3919825198947686217820773890708*cos(x(3))*(u(3) + 6.8799874527800186641002255782951*x(2)*x(6)*sin(x(3))))/(50.100267851037898269580460617581*sin(x(3))^2 - 5760.7531565930536755177372028873*cos(x(3))^2 + 19918.474952513809056085394841939) - (75.563856502993601793605193961412*cos(x(3))*(6.777649665187671423893789324211*cos(x(3))*sin(x(3))*x(2)^2 - 6.8799874527800186641002255782951*x(6)*sin(x(3))*x(2) + u(2) - 224.71559054661650186194446790372*cos(x(3))*sin(x(1))))/(50.100267851037898269580460617581*sin(x(3))^2 - 5760.7531565930536755177372028873*cos(x(3))^2 + 19918.474952513809056085394841939);
    w(3) + x(4);
    w(4) + ((6.7732526018213699003922556585167*sin(x(3))^2 - 6.8765679465165332473475245933514*cos(x(3))^2 + 2694.6029367529336013831198215485)*(6.7732526018213699003922556585167*cos(x(3))*sin(x(3))*x(2)^2 - 6.8765679465165332473475245933514*x(6)*sin(x(3))*x(2) + u(2) - 224.83404779339299945407774616637*cos(x(3))*sin(x(1))))/(50.113356545685595424496667562855*sin(x(3))^2 - 5760.9843590197107787845116681504*cos(x(3))^2 + 19936.595555618188301998259572781) + (75.565247315296815600049740169197*cos(x(3))^2*(u(3) + 6.8765679465165332473475245933514*x(2)*x(6)*sin(x(3))))/(50.113356545685595424496667562855*sin(x(3))^2 - 5760.9843590197107787845116681504*cos(x(3))^2 + 19936.595555618188301998259572781) + (75.565247315296815600049740169197*cos(x(3))*(8633.9462982545943757837137210974*sin(x(1)) - 1.0*u(1) - 75.565247315296815600049740169197*x(4)^2*sin(x(3)) + 224.83404779339299945407774616637*cos(x(1))*sin(x(3)) + 6.8765679465165332473475245933514*x(4)*x(6)*sin(x(3)) + 13.546505203642739800784511317033*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.113356545685595424496667562855*sin(x(3))^2 - 5760.9843590197107787845116681504*cos(x(3))^2 + 19936.595555618188301998259572781);
    w(5) + x(6);
    w(6) + ((u(3) + 6.8755152812074884494109028310049*x(2)*x(6)*sin(x(3)))*(50.156424273115944951100590725821*sin(x(3))^2 - 5709.9028481601263763653300775062*cos(x(3))^2 + 19930.40928291738360348424215313))/(344.85126154053487569647110584549*sin(x(3))^2 - 39608.172717771096034871029208082*cos(x(3))^2 + 137031.83358541805294453194348301) + (7.3964117608168802320278700790368*cos(x(3))*(8636.7355200451459553615621688581*sin(x(1)) - 1.0*u(1) - 75.563899106386287485292996279895*x(4)^2*sin(x(3)) + 224.93767653158339698328896888629*cos(x(1))*sin(x(3)) + 6.8755152812074884494109028310049*x(4)*x(6)*sin(x(3)) + 13.562366697544845806078228633851*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.156424273115944951100590725821*sin(x(3))^2 - 5760.7569902477256234508409838366*cos(x(3))^2 + 19930.40928291738360348424215313) + (75.563899106386287485292996279895*cos(x(3))^2*(6.7811833487724229030391143169254*cos(x(3))*sin(x(3))*x(2)^2 - 6.8755152812074884494109028310049*x(6)*sin(x(3))*x(2) + u(2) - 224.93767653158339698328896888629*cos(x(3))*sin(x(1))))/(50.156424273115944951100590725821*sin(x(3))^2 - 5760.7569902477256234508409838366*cos(x(3))^2 + 19930.40928291738360348424215313);
    ];
end

function dxdt = mStateEq5(x,w,u)
dxdt = [w(1) + x(2);
    w(2) - (7.3940270474751494944598562142346*(8629.4529138503918765178807921178*sin(x(1)) - 1.0*u(1) - 75.55968600103405208301410311833*x(4)^2*sin(x(3)) + 224.73019851072817911079365037759*cos(x(1))*sin(x(3)) + 6.8805265317952803982848308805842*x(4)*x(6)*sin(x(3)) + 13.553112451850692465882275428157*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.106040023228129914133554052808*sin(x(3))^2 - 5760.1409478518259888365195213122*cos(x(3))^2 + 19924.016964946151795718497739728) - (7.3940270474751494944598562142346*cos(x(3))*(u(3) + 6.8805265317952803982848308805842*x(2)*x(6)*sin(x(3))))/(50.106040023228129914133554052808*sin(x(3))^2 - 5760.1409478518259888365195213122*cos(x(3))^2 + 19924.016964946151795718497739728) - (75.55968600103405208301410311833*cos(x(3))*(6.7765562259253462329411377140786*cos(x(3))*sin(x(3))*x(2)^2 - 6.8805265317952803982848308805842*x(6)*sin(x(3))*x(2) + u(2) - 224.73019851072817911079365037759*cos(x(3))*sin(x(1))))/(50.106040023228129914133554052808*sin(x(3))^2 - 5760.1409478518259888365195213122*cos(x(3))^2 + 19924.016964946151795718497739728);
    w(3) + x(4);
    w(4) + ((6.7793252841308593303892848780379*sin(x(3))^2 - 6.8751728886795158146583162306342*cos(x(3))^2 + 2694.6038882902348632342182099819)*(6.7793252841308593303892848780379*cos(x(3))*sin(x(3))*x(2)^2 - 6.8751728886795158146583162306342*x(6)*sin(x(3))*x(2) + u(2) - 224.7266926750141133430891441953*cos(x(3))*sin(x(1))))/(50.158449277361305526881171864682*sin(x(3))^2 - 5761.2749207038889670069357758605*cos(x(3))^2 + 19936.667262413867673529953006261) + (75.567237081590448610768362414092*cos(x(3))^2*(u(3) + 6.8751728886795158146583162306342*x(2)*x(6)*sin(x(3))))/(50.158449277361305526881171864682*sin(x(3))^2 - 5761.2749207038889670069357758605*cos(x(3))^2 + 19936.667262413867673529953006261) + (75.567237081590448610768362414092*cos(x(3))*(8630.1760028556550638279699007532*sin(x(1)) - 1.0*u(1) - 75.567237081590448610768362414092*x(4)^2*sin(x(3)) + 224.7266926750141133430891441953*cos(x(1))*sin(x(3)) + 6.8751728886795158146583162306342*x(4)*x(6)*sin(x(3)) + 13.558650568261718660778569756076*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.158449277361305526881171864682*sin(x(3))^2 - 5761.2749207038889670069357758605*cos(x(3))^2 + 19936.667262413867673529953006261);
    w(5) + x(6);
    w(6) + ((u(3) + 6.8795902870501501880085015727673*x(2)*x(6)*sin(x(3)))*(50.137453346228738806722486622644*sin(x(3))^2 - 5710.3143385054255295585722555438*cos(x(3))^2 + 19928.950376953715659867386336372))/(344.92513705814528228656883682378*sin(x(3))^2 - 39634.659922970700897652247448465*cos(x(3))^2 + 137103.01344439521151039979387722) + (7.3958592019990359034409266314469*cos(x(3))*(8631.8524912935076044518318585378*sin(x(1)) - 1.0*u(1) - 75.566621854529302027003723196685*x(4)^2*sin(x(3)) + 224.75392939384220559258557989591*cos(x(1))*sin(x(3)) + 6.8795902870501501880085015727673*x(4)*x(6)*sin(x(3)) + 13.558249819757797638430929509923*x(2)*x(4)*cos(x(3))*sin(x(3))))/(50.137453346228738806722486622644*sin(x(3))^2 - 5761.1948196358885716727133823373*cos(x(3))^2 + 19928.950376953715659867386336372) + (75.566621854529302027003723196685*cos(x(3))^2*(6.7791249098788988192154647549614*cos(x(3))*sin(x(3))*x(2)^2 - 6.8795902870501501880085015727673*x(6)*sin(x(3))*x(2) + u(2) - 224.75392939384220559258557989591*cos(x(3))*sin(x(1))))/(50.137453346228738806722486622644*sin(x(3))^2 - 5761.1948196358885716727133823373*cos(x(3))^2 + 19928.950376953715659867386336372);
    ];
end