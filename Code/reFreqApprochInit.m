function f = reFreqApprochInit()
syms x1 x2 x3 x4 x5 x6 a b c d g A B J311 u1 u2 u3 w1 w2 w3 w4 w5 w6 v1 v2 v3 v4 v5 v6;
sym f(x1,x2,x3,x4,x5,x6,a,b,c,d,g,A,B,J311,u1,u2,u3,w1,w2,w3,w4,w5,w6);
sym h(x1,x2,x3,x4,x5,x6,v1,v2,v3,v4,v5,v6);
dt = 0.01; %step Size
%Defining State Space
%---------------------------
% x1 = theta1
% x2 = theta1_dot = x1_dot
% x3 = theta2
% x4 = theta2_dot = x3_dot
% x5 = theta3
% x6 = theta3_dot = x5_dot
%---------------------------
% u1 = tau1
% u1 = tau2
% u1 = tau3
%---------------------------

H_gama = [ a+b*sin(x3).^2, c*cos(x3), J311*cos(x3);
           c*cos(x3),      d,          0;
           J311*cos(x3),   0,          J311;];
     
G_gama = [ A*g*sin(x1)+B*g*cos(x1)*sin(x3);
           B*g*sin(x1)*cos(x3);
           0;];

D_gama = [ 2*b*x2*x4*cos(x3)*sin(x3) + J311*x4*x6*sin(x3) - c*x4^2*sin(x3);
          -b*x2^2*cos(x3)*sin(x3) + J311*x2*x6*sin(x3);
          -J311*x2*x6*sin(x3);];

u = [u1; 
     u2;
     u3;];

th_double_dot = inv(H_gama)*(u-D_gama-G_gama);

randNum = (-1 + 2*rand(8,1))*dt;

x1_dot = x2 + w1;               %theta1_dot
x2_dot = subs(th_double_dot(1)+w2,[a,b,c,d,g,J311,A,B],[2694.6+randNum(1),6.7728+randNum(2),75.5573+randNum(3),7.3916+randNum(4),9.81+randNum(5),6.8707+randNum(6),879.6338+randNum(7),22.9022+randNum(8)]);
x3_dot = x4 + w3;               %theta2_dot
x4_dot = subs(th_double_dot(2)+w4,[a,b,c,d,g,J311,A,B],[2694.6+randNum(1),6.7728+randNum(2),75.5573+randNum(3),7.3916+randNum(4),9.81+randNum(5),6.8707+randNum(6),879.6338+randNum(7),22.9022+randNum(8)]);
x5_dot = x6 + w5;               %theta3_dot
x6_dot = subs(th_double_dot(3)+w6,[a,b,c,d,g,J311,A,B],[2694.6+randNum(1),6.7728+randNum(2),75.5573+randNum(3),7.3916+randNum(4),9.81+randNum(5),6.8707+randNum(6),879.6338+randNum(7),22.9022+randNum(8)]);
%------------------------
% x_dot = f(x,u,w) Matrix
%------------------------
x_dot = [x1_dot;
         x2_dot;
         x3_dot;
         x4_dot;
         x5_dot;
         x6_dot;
         ];
x_dot = vpa(x_dot);     
x = [x1;x2;x3;x4;x5;x6];
w = [w1;w2;w3;w4;w5;w6];
f = x_dot;
%------------------------
% y = h(x,v) Matrix
%------------------------
v = v1;
y = x1 + v1;
h = y;
end