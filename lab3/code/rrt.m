function [vertices,edges,path]=rrt(map,q_start,q_goal,k,delta_q,p)
% Check if q_start and q_goal is a row vector
if size(q_start,1) == 2 
   q_start = q_start'; 
end
if size(q_goal,1) == 2 
   q_goal = q_goal'; 
end

% Consider if k, delta_q, p exist



%% RRT algorithm

[height,width] = size(map);
% Initialize the vertices with q_start
vertices = q_start;

% Initialize the edges as empty
edges = [];

i = 1;
while i < k
    % Create a number between 0 and 1
    rand_val = rand;
    if rand_val < p % 30 percent chance 
        q_rand = q_goal;
    else
        q_rand = [randi(height),randi(width)];
    end
    
    % Find q_near from q_rand in 'vertices'
    dif = bsxfun(@minus, vertices, q_rand);
    vertices_dis = sqrt(dif(:,1).^2 + dif(:,2).^2); % Euclidean distance between all the vertices and q_rand
    q_near_idx = find(vertices_dis == min(vertices_dis)); % Get the index of q_near
    q_near = vertices(q_near_idx,:);
    ang = atan2(q_rand(2) - q_near(2),q_rand(1)-q_near(1));
    
    % Get q_new
    q_new = q_near + [delta_q*sin(ang),delta_q*cos(ang)];
    q_new = floor(q_new);
    if vertices(q_new(1),q_new(2)) == 1 % q_new is in the obstacle
        continue;
    else
        vertices = [vertices;q_new];
         
    end
end
end