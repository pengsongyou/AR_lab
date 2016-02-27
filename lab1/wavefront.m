function [value_map, trajectory]=wavefront(map, start, goal)
   value_map = map;
   [height, width] = size(value_map);
   nd = [-1 -1; -1 0; -1 1; 0 1; 1 1; 1 0; 1 -1; 0 -1];% Neighborhood directions. In this case is 8 neighbors
   %% Generate value_map
   value_map(goal(1),goal(2)) = 2;
   q_cur = [goal];% searching queue for current region generation
   q_next = [];% searching queue for next region generation
   label = 3;
   while nnz(value_map) ~= height*width 
       for i = 1 : size(q_cur,1) % loop for current generation
           p_c = q_cur(i,:);%center point
           for k = 1 : 8
                p_n = p_c + nd(k,:); % neighborhood of the center point
                if p_n(1) < 1 || p_n(1) > height || p_n(2) < 1 || p_n(2) > width || value_map(p_n(1), p_n(2)) ~= 0
                    continue;
                end
                value_map(p_n(1),p_n(2)) = label;
                q_next = [q_next;p_n];
           end
       end
       q_cur = q_next;
       q_next = [];
       label = label + 1;
   end
   %% Generate trajectory
   trajectory = [start];
   dis = sqrt(sum((start - goal).^2));
   p_c = start;
   nd = [-1 -1; -1 1; 1 1; 1 -1; -1 0; 0 1; 1 0; 0 -1];% Neighborhood directions. First consider skew directions, then horiontal and vertical
                                                       % So we give
                                                       % vertical and
                                                       % horiontal higher
                                                       % priorioty
   while sum(abs(p_c-goal)) ~=0
       for k = 1 : 8
           p_n = p_c + nd(k,:); % neighborhood of the center point
           if value_map(p_n(1), p_n(2)) >= value_map(p_c(1), p_c(2)) || value_map(p_n(1), p_n(2)) == 1
               continue;
           end
           p_next = p_n;
       end
       p_c = p_next;
       trajectory = [trajectory;p_c];
   end
   
   %% plot
   map_plot = map;
   for i = 1 : size(trajectory,1)
       map_plot(trajectory(i,1),trajectory(i,2)) = 2;
   end
   map_plot(trajectory(1,1),trajectory(1,2)) = 3;
   map_plot(trajectory(end,1),trajectory(end,2)) = 3;
   imshow(map_plot,[]);
   colormap jet;
%    imagesc(map_plot);
end