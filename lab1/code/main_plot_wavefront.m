close all;
clear;
clc;

%% Load the map

% load maze
% load mazeBig
load obstaclesBig

%% Perform wavefront planner algorithm

tic
% [value_map, trajectory]=wavefront(map, [45, 4] , [5, 150]);% For maze
[value_map, trajectory]=wavefront(map, [50 50] , [600 700]); % For
% mazeBig & obstacleBig
toc

%% plot
map_plot = map;
for i = 1 : size(trajectory,1)
    map_plot(trajectory(i,1),trajectory(i,2)) = 2;
end
figure;imshow(map_plot,[],'Border','tight'); hold on;
plot(trajectory(1,2),trajectory(1,1),'r+');
plot(trajectory(end,2),trajectory(end,1),'g+');
colormap colorcube;
hold off;
