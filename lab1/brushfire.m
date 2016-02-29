function [value_map]=brushfire(map)
    value_map = map;
    nd = [-1 -1; -1 0; -1 1; 0 1; 1 1; 1 0; 1 -1; 0 -1];% Neighborhood directions. In this case is 8 neighbors
    [height, width] = size(value_map);
    label = 0;
    while nnz(value_map) ~= height*width
        label = label + 1;
        [v, h] = find(value_map == label);
        for i = 1 : size(v,1)
            for k = 1 : 8
                p_n(1) = v(i) + nd(k,1);
                p_n(2) = h(i) + nd(k,2);
                if p_n(1) < 1 || p_n(1) > height || p_n(2) < 1 || p_n(2) > width || value_map(p_n(1), p_n(2)) ~= 0
                    continue;
                end
                value_map(p_n(1),p_n(2)) = label + 1;
            end
        end
    end   
end