function Q = q_learning(map,q_goal,alpha,gamma,epsilon,n_episodes,n_iterations)
    [h,w]= size(map);
    Q = zeros(h,w,4);
    action = [-1,0;0,1;1,0;0,-1];% Four actions 
    
    n_test = 200;
    rewards_test = zeros(ceil(n_episodes/n_test), 1);
    t = 1;
    for n = 1 : n_episodes
        
        % Testing the learnt policy
        if mod(n, n_test) == 0 && n ~= n_episodes 
            t = t + 1;
        end
        
        % Initialize s randomly in any free cell
        s1 = randi(h);
        s2 = randi(w);
        while map(s1,s2) == 1 || (s1 == q_goal(2) && s2 == q_goal(1))
            s1 = randi(h);
            s2 = randi(w);
        end
        
        for m = 1 : n_iterations
            
            % Epsilon greedy policy
            p = rand;
            if p > epsilon
                a_idx = find(Q(s1,s2,:) == max(Q(s1,s2,:)));
                if size(a_idx,1) > 1
                    a_idx = a_idx(1);
                end
            else % In 30 percent case we randomly choose action
                a_idx = randi(4);
            end
            
            % Next state
            s1_ = s1 + action(a_idx,1);
            s2_ = s2 + action(a_idx,2);
            
            if s1_ == q_goal(2) && s2_ == q_goal(1) % Goal point
                Q(s1, s2, a_idx) = Q(s1,s2, a_idx) + alpha * (1 + gamma * max(Q(s1_, s2_,:)) - Q(s1, s2, a_idx));
                break;
            end
            
            if map(s1_, s2_) == 0 % The next step doesn't meet obstacle
                Q(s1, s2, a_idx) = Q(s1,s2, a_idx) + alpha * (-1 + gamma * max(Q(s1_, s2_,:)) - Q(s1, s2, a_idx));
                s1 = s1_;
                s2 = s2_;
            else
                Q(s1, s2, a_idx) = Q(s1,s2, a_idx) + alpha * (-1 + gamma * max(Q(s1, s2,:)) - Q(s1, s2, a_idx));
            end
        end
        rewards_test(t) = rewards_test(t) - m;
    end
    
    % Plot the effectiveness
    figure; hold on;
    
    xa = 0:n_test: n_episodes;
    plot(xa, [-50, rewards_test'./n_test],'-');
    title('Evolution of effectiveness');
    hold off;
    
    % Graphical representation of the State Value Function V
    V = zeros(size(Q,1),size(Q,2));
    for i = 1 : size(Q,1)
        for j = 1 : size(Q,2)
            V(i,j) = max(Q(i,j,:));
        end
    end
    
    
    figure;imagesc(V);
    colormap jet
    title('State Value Function');
    
    % Plot optimal policy
    h = size(Q,1);
    figure;hold on
    for i = 1 : size(Q,1)
        for j = 1 : size(Q,2)
            if Q(i,j,1) == 0 && Q(i,j,2) == 0 && Q(i,j,3) == 0 && Q(i,j,4) == 0
                plot(j,h+1 -i,'ro');
                continue;
            end
            action = find(Q(i,j,:) == max(Q(i,j,:)));
            action = action(1);
            switch action
                case 1
                    text(j,h + 1 - i,'\uparrow','HorizontalAlignment','center','FontSize',10);
                case 2
                    text(j,h + 1 - i,'\rightarrow','HorizontalAlignment','center','FontSize',10);
                case 3
                    text(j,h + 1 - i,'\downarrow','HorizontalAlignment','center','FontSize',10);
                case 4  
                    text(j,h + 1 - i,'\leftarrow','HorizontalAlignment','center','FontSize',10);
            end
        end
    end
    plot(q_goal(1),h + 1 - q_goal(2),'g*');
    axis off
    title('Optimal Policy');
    hold off;
end