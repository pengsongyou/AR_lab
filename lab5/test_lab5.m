% map=[
% 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
% 1 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 1;
% 1 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 1;
% 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1;
% 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1;
% 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1;
% 1 0 0 0 1 1 1 1 1 0 0 0 0 0 1 1 0 0 0 1;
% 1 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 1;
% 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 1;
% 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 1;
% 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1;
% 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 1;
% 1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 1;
% 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1;];

Q=q_learning(map,[18,18],0.1,0.9,0.3,20000,50);
