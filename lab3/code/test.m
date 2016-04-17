clear;
clc;
close all;
%%
% load maze.mat
load map.mat
colormap=[1 1 1; 0 0 0; 1 0 0; 0 1 0; 0 0 1]; imshow(uint8(map),colormap)
hold on

q_start = [70,70];
q_goal = [626,734];
delta_q = 50;
p = 0.3;
k = 10000;
[vertices,edges,path]=rrt(map,q_start,q_goal,k,delta_q,p);

% Plot all the vertices
for i = 1 : size(vertices,1)
    plot(vertices(i,2),vertices(i,1),'g+');
end

% Plot all the edges
for i = 1 : size(edges,1)
    plot([vertices(edges(i,1),2), vertices(edges(i,2),2)],[vertices(edges(i,1),1), vertices(edges(i,2),1)],'b');
end
% Plot path
for i = 1 : length(path)-1
    plot([vertices(path(i),2),vertices(path(i + 1),2)],[vertices(path(i),1), vertices(path(i + 1), 1)],'r-','LineWidth',1.5);
end

% Smooth the path 
[path_smooth]=smooth(map,path,vertices,5);
for i = 1 : length(path_smooth)-1
    plot([vertices(path_smooth(i),2),vertices(path_smooth(i + 1),2)],[vertices(path_smooth(i),1), vertices(path_smooth(i + 1), 1)],'k-','LineWidth',1.5);
end

hold off
