clear;
clc;
close all;

vertices = [0.7807 9.0497 0;
            3.0322 8.9912 1;
            1.3655 6.7105 1;
            4.1140 4.0497 1;
            6.2778 8.2310 1;
            8.2953 5.8333 2;
            5.6345 2.6170 2;
            9.1433 1.9152 2;
            11.4825 6.9444 2;
            10.2544 0.5702 3];

        
edge = RPS(vertices);        
%line1
x1  = [7.8 8.5];
y1  = [0.96 0.94];
%line2
x2 = [8.25 8.25];
y2 = [0 0.94];






% [x,y] = polyxpoly(x1,y1,x2,y2);

%fit linear polynomial
% p1 = polyfit(x1,y1,1);
% p2 = polyfit(x2,y2,1);
% 
% %calculate intersection
% x_intersect = fzero(@(x) polyval(p1-p2,x),3);
% y_intersect = polyval(p1,x_intersect);
% line(x1,y1);
% hold on;
% line(x2,y2);
% plot(x_intersect,y_intersect,'r*')