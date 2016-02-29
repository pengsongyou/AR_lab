

function [value_map, trajectory]=wavefront(map, start, goal)
   if size(start,1) == 2
       start = start';
   end
   if size(goal,1) == 2
       goal = goal';
   end
   value_map = map;
   [height, width] = size(value_map);
   nd = [-1 -1; -1 0; -1 1; 0 1; 1 1; 1 0; 1 -1; 0 -1];% Neighborhood directions. In this case is 8 neighbors
   %% Generate value_map
   value_map(goal(1),goal(2)) = 2;
   q = zeros(height*width,2); % Waiting queue
   q(1,:) = goal;
   lp = 1; % Left moving pointer for queue
   rp = 2; % Right moving pointer for queue
   
   while lp < rp
       p_c = q(lp,:);%center point
       for k = 1 : 8
            p_n = p_c + nd(k,:); % neighborhood of the center point
            if p_n(1) < 1 || p_n(1) > height || p_n(2) < 1 || p_n(2) > width || value_map(p_n(1), p_n(2)) ~= 0
                continue;
            end
            value_map(p_n(1),p_n(2)) = value_map(p_c(1),p_c(2)) + 1;
            q(rp,:) = p_n;      
            rp = rp + 1;        
       end
       lp = lp + 1;
   end
   %% Generate trajectory
   trajectory = [start];
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
end