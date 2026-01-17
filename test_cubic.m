% This program calls cluster_cubic_cost().
% It is also possible to draw convex hulls.
% Original version by Microsoft Copilot.
% Modified by Mikko Malinen, 2026
% Version 0.03
clear all;

tic;

REPEATS = 1;
DRAW_CONVEX_HULL = 1;  % 0 = no,  1 = yes

Best_cost_cubic_L2 = Inf;

%X = randn(100, 2); % random 2D-data
%k = 3;
%X = load("s2.txt"); k = 15;
X = load("../datasets/s2.txt"); k = 15;
%X = load("../datasets/birch1.txt"); k = 100;
%X = load('../datasets/iris.txt'); k = 3;

n = size(X,1);
d = size(X,2);

for repeats = 1:REPEATS

max_iter = 100;
[mu, labels] = cluster_cubic_cost(X, k, max_iter);

% Cost

Cost_cubic_L2 = 0;
for i = 1:n
Dist(i,:) = X(i,:)-mu(labels(i),:);
Cost_cubic_L2 = Cost_cubic_L2 + (Dist(i,:)*Dist(i,:)')^(3/2);
end
if Cost_cubic_L2 < Best_cost_cubic_L2
    Best_cost_cubic_L2 = Cost_cubic_L2;
    idx_best = labels;
    centers_best = mu;
end

end % repeats


toc;

if DRAW_CONVEX_HULL==1
sz = zeros(k,1);  % sizes of clusters
for i = 1:n
    sz(idx_best(i)) = sz(idx_best(i))+1;
    CM(idx_best(i),sz(idx_best(i)),1:d) = X(i,1:d);  % CM has points of clusters
end
for j = 1:k   %1:k
    clear CM_2;
    CM_2(1:sz(j),1:2) = CM(j,1:sz(j),1:2);
    clear idx_clust;
    [idx_clust, vol] = convhulln(CM_2);
    idx_b_clust{j} = idx_clust(:,1);
    %if j==1
    %    idx_b_clust1 = idx_clust(:,1);
    %elseif j==2
    %    idx_b_clust2 = idx_clust(:,1);
    %elseif j==3
    %    idx_b_clust3 = idx_clust(:,1);
    %end

end
end % DRAW_CONVEX_HULL

% Visualisointi
scatter(X(:,1), X(:,2), 30, labels, 'filled');
hold on;
plot(mu(:,1), mu(:,2), 'rx', 'MarkerSize', 15, 'LineWidth', 2);
title('Clustering with |x - mu|^3 cost');

if DRAW_CONVEX_HULL == 1
for j=1:k   %1:k
    hold on;
    clear CH;
    clear CM_2;
    CM_2(1:sz(j),1:2) = CM(j,1:sz(j),1:2);
    CH(:,1:2) = CM_2(idx_b_clust{j},1:2);
    %if j==1
    %    CH(:,1:2) = CM_2(idx_b_clust1,1:2);
    %elseif j==2
    %    CH(:,1:2) = CM_2(idx_b_clust2,1:2);
    %elseif j==3
    %    CH(:,1:2) = CM_2(idx_b_clust3,1:2);
    %end
    %if j<4
    plot(CH(:,1),CH(:,2),'k');
    CH_last(1,:) = CH(end,1:2);
    CH_last(2,:) = CH(1,1:2);
    hold on;
    plot(CH_last(:,1),CH_last(:,2),'k');
    %end
end
end % DRAW_CONVEX_HULL

Best_cost_cubic_L2 = Best_cost_cubic_L2 