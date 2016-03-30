function [edges]=RPS(vertices)
%1. Give labels for every vertex
%2. Get the angles from all vertices to start point (compare to Horizontal
%line segment) 
%3. check intersections based on the order

edges = [];


% Create all the possible edge first
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
figure;hold on;
for i = 1 : size(vertices,1)
    plot(vertices(i,1),vertices(i,2),'bo','MarkerSize', 2);
    text(vertices(i,1),vertices(i,2),num2str(i),'HorizontalAlignment','left','FontSize',10);
end
% text(vertices(i,1),vertices(i,2),'\rightarrow Starting point');

for i = 1 : (size(vertices,1) - 2)
    plot(edge_x(i,:),edge_y(i,:),'b','LineWidth',1);
end

for cur = 1 : size(vertices,1)% Current vertex index
    angle = [];
    for i = (cur + 1) : size(vertices,1) % Get the angles from current vertex to other vertices
        angle = [angle;atan2(vertices(cur,2) - vertices(i,2), vertices(cur,1) - vertices(i,1))];
    end
    [~, idx] = sort(angle,'ascend');
    idx = idx + cur;
    for i = 1 : size(idx,1) 
        line_x = [vertices(cur,1),vertices(idx(i),1)]; % Line between current point and other vertices in order
        line_y = [vertices(cur,2),vertices(idx(i),2)];
        s = 0;
        for j = 1 : (size(vertices,1) - 2)% All the edges
             [inter_x,inter_y] = polyxpoly(line_x,line_y,edge_x(j,:),edge_y(j,:)); % Intersect point between the line and every edge
                          
             if size(inter_x,1) ~= 0 
                  if size(inter_x,1) == 2 && size(inter_y,1) == 2 % two lines are the same line and then has two intersections
                      edges = [edges;cur,idx(i)];
                      break;
                  else
                      if sum(vertices(:,1) == inter_x & vertices(:,2) == inter_y) == 0 % Intersect in the middle of the edge
                          break;
                      end
%                       
%                       if inter_x == vertices(idx(i),1) && inter_y == vertices(idx(i),2) && vertices(idx(i),3) ~= vertices(cur,3)|| idx(i) == size(vertices,1) % Intersect in the vertex and the vertex doesn't belong to the same polygon
%                           s = 1;
%                       end
%                       
                      if inter_x == vertices(idx(i),1) && inter_y == vertices(idx(i),2)
                          % 3 available cases:
                          % 1. The intersection belongs to the different
                          % polygon from the current point
                          % 2. The intersection belongs to the same polygon
                          % but the polygon is non-convex                         
                         
                          if vertices(idx(i),3) ~= vertices(cur,3) % 1
                              s = 1;
                          end
                          % Check if the line is in the polygon or not
                          
                          % Get the middle point of the line segment
                          mid_point_x = (inter_x + vertices(cur,1))/2;
                          mid_point_y = (inter_y + vertices(cur,2))/2;
                          
                          % Check the polygon that the intersection point
                          % belongs to
                          p_n = vertices(cur,3); % Polygon number
                          
                          % Get all the vertices of the current polygon
                          p_rn = find(vertices(:,3) == p_n);% row number of the current polygon
                          P_x = vertices(p_rn,1);
                          P_y = vertices(p_rn,2);
                          in = inpolygon(mid_point_x,mid_point_y,P_x,P_y);
                          if in == 0 % 2
                              s = 1;
                          end
%                          
                      end
                      
                      if idx(i) == size(vertices,1) % The end point of the line is goal point
                          s = 1;
                      end
                  end
             end

             if s == 1 && j == (size(vertices,1) - 2) % Make sure there is no intersect with edges
                 s = 0;
                 edges = [edges; cur, idx(i)];
                 plot([vertices(cur,1),vertices(idx(i),1)],[vertices(cur,2),vertices(idx(i),2)],'r');
             end
        end
    end
end

