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
    i = i + 1;
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
    q_near_idx = q_near_idx(1,:);
    q_near = vertices(q_near_idx,:);
    
    % Get q_new
    if vertices_dis(q_near_idx) <= delta_q
        q_new = q_rand;
        dis = vertices_dis(q_near_idx);
    else
        v = q_rand - q_near;
        v = v ./ norm(v);
        q_new = q_near + delta_q .* v;
        dis = delta_q;
%         k1 = delta_q;
%         k2 = vertices_dis(q_near_idx) - delta_q;
%         q_new = [(k1 * q_rand(1) + k2 * q_near(1))/ (k1 + k2), (k1 * q_rand(2) + k2 * q_near(2))/ (k1 + k2)];
    end
    if q_new == q_goal
        vertices = [vertices;q_new];
        edges = [edges;size(vertices,1), q_near_idx];
        break;
    end
    % Check if the q_new is valid
    if q_new(1) < 0 || q_new(2) < 0 || q_new(1) > size(map,1) || q_new(2) > size(map,2)
        continue;
    else
        q_new = floor(q_new);
    end
    
    % Check if there is an obstacle between q_near and q_new
    ob = 0; % Label for obstacle
    d = dis / 10;
    v = q_rand - q_near;
    v = v ./ norm(v);
    for j = 1 : 10
%         k1 = j * d;
%         k2 = vertices_dis(q_near_idx) - k1;
        q_middle = floor(q_near + j * d .* v);
        if map(q_middle(1), q_middle(2)) ~= 0
            ob = 1;
            break;
        end
    end
    if ob == 1
        continue;
    else
        vertices = [vertices;q_new];
        edges = [edges;size(vertices,1), q_near_idx]; 
        plot(q_near(2),q_near(1),'g+');
        plot(q_new(2),q_new(1),'g+');
        plot([q_near(2),q_new(2)],[q_near(1), q_new(1)],'b');
    end
end

% Get Path

path = [size(vertices,1)];
cur = path(1);
while cur ~= 1
    cur_idx = find(edges(:,1) == cur);
    path = [edges(cur_idx,2),path];
    cur = path(1);
end

end