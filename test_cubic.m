clear all;
%X = randn(100, 2); % random 2D-data
%K = 3;
X = load("../datasets/s2.txt");
K=15;
max_iter = 100;
[mu, labels] = cluster_cubic_cost(X, K, max_iter);

% Visualisointi
scatter(X(:,1), X(:,2), 30, labels, 'filled');
hold on;
plot(mu(:,1), mu(:,2), 'rx', 'MarkerSize', 15, 'LineWidth', 2);
title('Clustering with |x - mu|^3 cost');