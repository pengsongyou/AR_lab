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
% Plot path
for i = 1 : length(path)-1
    plot([vertices(path(i),2),vertices(path(i + 1),2)],[vertices(path(i),1), vertices(path(i + 1), 1)],'r-','LineWidth',1.5);
end