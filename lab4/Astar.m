function [path,minCost]=Astar(vertices, edges)

% Calculate heuristic distance for all the vertices
goal = vertices(end,1:2);

d = bsxfun(@minus,vertices(:,1:2),goal);
heu = sqrt(d(:,1).^2 + d(:,2).^2);

% Calculate the distance from every vertex to the visible vertices
dis_betw_node = zeros(size(edges,1),1);
for i = 1 : size(edges,1)
    v1 = vertices(edges(i,1),:);
    v2 = vertices(edges(i,2),:);
    dis_betw_node(i) = sqrt((v2(1) - v1(1)).^2 + (v2(2) - v1(2)).^2);
end

% A star algorithm
% 1. Put all the visible vertices of the current points and the total
% distance (current vertex to the visible vertices + the heuristic distance of that vertex) into the O list
% 2. Check the smallest distance among all the visible vertices, put that
% corresponding vertex number and back  pointer number into C list like [edges number of smallest distance vertex, edge number of current vertex]
% 3. Until Goal point is on the top of the O list 

% O = [size(vertices,1)-1,2]; % O list, [node number, cost]
O = [];
C = [1,0]; % C list, [current point idx, back point idx], 0 means nothing in the back point
idx_O = 1;
while 1
    node_idx = C(idx_O,1); % Current node index
    node = vertices(node_idx,:);
    % visible vertices
    edge_idx = find(edges(:,1) == node_idx);
%     no = 0;

    if size(O,1) == 0 % no element in O, the element can be directly insert
        O = [O;[edges(edge_idx,2),dis_betw_node(edge_idx)+heu(edges(edge_idx,2))]];
    else
        for i = 1 : size(edge_idx,1)
            if sum(find(O(:,1) == edges(edge_idx(i),2))) == 0 % Not in O list yet
                O = [O;[edges(edge_idx(i),2),dis_betw_node(edge_idx(i))+heu(edges(edge_idx(i),2))]];
            end
        end
    end
    % Put visible vertices to into O list
%     O = [O;[edges(edge_idx,2),dis_betw_node(edge_idx)]];
    % Sort the O list based on the distance
    [~,I] = sort(O(:,2));
    O = O(I,:);
    
    % Update C list
    C = [C; O(1,1),node_idx];
    if O(1,1) ~= size(vertices,1) % the first element in O list is not the goal point
        % Delete the first row in the O list
        O = O(2:end,:);
        idx_O = idx_O + 1;
    else
        break;
    end
end

% Get the path
path = [size(vertices,1)];
i = size(C,1) - 1;
while 1 
    if C(i,2) ~= 1 
        path = [path,C(i,1)];
    else
        path = [path,C(i,1),1];
        break;
    end
    i = i - 1;
end
path = fliplr(path);

% Calculate minCost
minCost = 0;
path_total = size(path,2);
for i = 1 : path_total - 1
    idx = find(edges(:,1) == path(i) & edges(:,2) == path(i + 1));
    
    minCost = minCost + dis_betw_node(idx);
end
end