function [edges]=RPS(vertices)
% This is the function which implements Rotational Plane Sweep path planning algorithm
% Main step is as follows:
% 1. Get all the edges in the polygons
% 2. Get angles of all the lines between current vertices and other vertices
% 3. start checking the intersection in anti-clockwise direction
% 4. If the intersetion is in the edge, invalid
% 5. If the intersection is in the vertices, check if the line is in the
% polygon or not (Deal with non-convex polygon problem)



edges = [];

% Initialize the list which is used to keep all the edges of polygons
edge_x = zeros(size(vertices,1) - 2,2);
edge_y = zeros(size(vertices,1) - 2,2);

p = 1;
for i = 2 : (size(vertices,1) - 1) % Eliminate the starting point and goal point
    if vertices(i,3) == vertices(i + 1, 3) % The same polygon
        edge_x(p,1) = vertices(i,1); 
        edge_x(p,2) = vertices(i+1,1);
        edge_y(p,1) = vertices(i,2);
        edge_y(p,2) = vertices(i+1,2);
        p = p + 1;
        if vertices(i,3) ~= vertices(i - 1, 3) % first point of the polygon
            num_P = sum(vertices(:,3) == vertices(i,3));% the number of vertices of the current polygon
            edge_x(p,1) = vertices(i,1);
            edge_x(p,2) = vertices(i + num_P - 1,1);
            edge_y(p,1) = vertices(i,2);
            edge_y(p,2) = vertices(i + num_P - 1,2);
            p = p + 1;
        end
    end
end

for cur = 1 : size(vertices,1)% Current vertex index
    angle = [];
    % Get the angles from current vertex to other vertices
    for i = (cur + 1) : size(vertices,1) 
        angle = [angle;atan2(vertices(cur,2) - vertices(i,2), vertices(cur,1) - vertices(i,1))];
    end
    [~, idx] = sort(angle,'ascend');
    idx = idx + cur;
    
    % Check intersections in the anti-clockwise direction
    
    for i = 1 : size(idx,1) 
        % Line between current point and other vertices in order
        line_x = [vertices(cur,1),vertices(idx(i),1)]; 
        line_y = [vertices(cur,2),vertices(idx(i),2)];
        
        s = 0; % Label for intersection. If it is valid intersection, s = 1
        
        % Check the intersections between all the polygon edges and the
        % currrent line
        for j = 1 : (size(vertices,1) - 2)
            % Intersection point
             [inter_x,inter_y] = polyxpoly(line_x,line_y,edge_x(j,:),edge_y(j,:)); 
             
             % Different cases for having intersections
             if size(inter_x,1) ~= 0  
                 
                 % Having two intesection points means the current line is
                 % the polygon edge, valid
                 if size(inter_x,1) == 2 && size(inter_y,1) == 2 
                     edges = [edges;cur,idx(i)];
                     break;
                 else
                     
                     % Intersect in the middle of the polygon edge, invalid
                     if sum(vertices(:,1) == inter_x & vertices(:,2) == inter_y) == 0 
                         break;
                     end
                     
                     % Intersect in the goal point, valid
                     if idx(i) == size(vertices,1)
                         s = 1;
                     end
                     
                     % Intersect in the vertices, valid
                     if inter_x == vertices(idx(i),1) && inter_y == vertices(idx(i),2)
                          % 2 valid cases:
                          % a. The intersection belongs to the different
                          % polygon from the current point
                          % b. The intersection belongs to the same polygon
                          % but the polygon is non-convex                         

                         if vertices(idx(i),3) == vertices(cur,3) % b
                             
                             % Get the middle point of the line segment
                             mid_point_x = (inter_x + vertices(cur,1))/2;
                             mid_point_y = (inter_y + vertices(cur,2))/2;

                             p_n = vertices(cur,3); % Polygon number

                             % Get all the vertices of the current polygon
                             p_rn = find(vertices(:,3) == p_n);% row number of the current polygon
                             P_x = vertices(p_rn,1);
                             P_y = vertices(p_rn,2);
                             
                             % Check whether the middle point is in the polygon or not
                             in = inpolygon(mid_point_x,mid_point_y,P_x,P_y); 
                             if in == 0
                                 s = 1;
                             end
                         else % a
                             s = 1;
                         end
                     end
                 end
             end
             if s == 1 && j == (size(vertices,1) - 2)
                 s = 0;
                 edges = [edges; cur, idx(i)];
             end
         end
    end
end

