function [path,minCost]=Astar(vertices, edges)

% Calculate heuristic distance for all the vertices
goal = vertices(end,1:2);

d = bsxfun(@minus,vertices(:,1:2),goal);
heu = sqrt(d(:,1).^2 + d(:,2).^2);


num_node = size(vertices,1);
% Create a matrix storing the distance between two vertices
dis_betw_node = zeros(num_node);
for i = 1 : size(edges,1)
    v1 = vertices(edges(i,1),:);
    v2 = vertices(edges(i,2),:);
    dis_betw_node(edges(i,1),edges(i,2)) = sqrt((v2(1) - v1(1)).^2 + (v2(2) - v1(2)).^2);
    dis_betw_node(edges(i,2),edges(i,1)) = dis_betw_node(edges(i,1),edges(i,2));
end


% Calculate the distance from every vertex to the visible vertices
% dis_betw_node = zeros(size(edges,1),1);
% for i = 1 : size(edges,1)
%     v1 = vertices(edges(i,1),:);
%     v2 = vertices(edges(i,2),:);
%     dis_betw_node(i) = sqrt((v2(1) - v1(1)).^2 + (v2(2) - v1(2)).^2);
% end

% A star algorithm
% 1. Put all the visible vertices of the current points and the total
% distance (current vertex to the visible vertices + the heuristic distance of that vertex) into the O list
% 2. Check the smallest distance among all the visible vertices, put that
% corresponding vertex number and back  pointer number into C list like [edges number of smallest distance vertex, edge number of current vertex]
% 3. Until Goal point is on the top of the O list 

O = [];
C = [1,0]; % C list, [current point idx, back point idx], 0 means nothing in the back point
% idx_O = 1;

dis_node = 1000000*ones(num_node,1);
dis_node(1) = 0; 
while 1
    parent_num = C(size(C,1),1);% Current node
    % Find the neighbor nodes by checking if they have distance between
    % each other
    child_num = find(dis_betw_node(parent_num,:) ~= 0);

    if size(O,1) == 0 % no element in O, the element can be directly inserted
        for i = 1 : length(child_num)
            dis_node(child_num(i)) = dis_node(parent_num) + dis_betw_node(parent_num,child_num(i));
            cost = dis_node(child_num(i)) + heu(child_num(i));
            O = [O;child_num(i),cost,parent_num];
        end
    else
        for i = 1 : length(child_num)
            dis_node_tmp = dis_node(parent_num) + dis_betw_node(parent_num,child_num(i));
            
            if sum(find(C(:,1) == child_num(i))) ~= 0 || dis_node_tmp > dis_node(child_num(i)) % Already in the close list
                continue;
            end
            dis_node(child_num(i)) = dis_node_tmp;
            cost = dis_node(child_num(i)) + heu(child_num(i));
            O = [O;child_num(i),cost,parent_num];
        end
    end
    % Sort the O list based on the distance
    [~,I] = sort(O(:,2));
    O = O(I,:);
    
    % Update C list
%     C = [C; O(1,1),node_idx];
    C = [C; O(1,1),O(1,3)];
    if O(1,1) ~= size(vertices,1) % the first element in O list is not the goal point
        % Delete the first row in the O list
        O = O(2:end,:);
%         idx_O = idx_O + 1;
    else
        minCost = O(1,2);
        break;
    end
end

% Get the path
path = [size(vertices,1)];
cur = path(1);
while cur ~= 1
    cur_idx = find(C(:,1) == cur);
    path = [C(cur_idx,2),path];
    cur = path(1);
end

end