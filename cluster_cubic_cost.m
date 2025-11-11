function [mu, labels] = cluster_cubic_cost(X, K, max_iter)
% X: n x d data matrix (n datapoints, d dimensions)
% K: number of clusters
% max_iter: maksimum number of iterations
% Uses non-convex cost function
% Source: Microsoft Copilot
% Modified by Mikko Malinen, 2025

[n, d] = size(X);
mu = X(randperm(n, K), :); % Random initialization
labels = zeros(n, 1);

for iter = 1:max_iter
    % Phase 1: Assign datapoints to nearest cluster center
    for i = 1:n
        costs = zeros(K, 1);
        for k = 1:K
            costs(k) = sum(abs(X(i,:) - mu(k,:)).^3);
        end
        [~, labels(i)] = min(costs);
    end

    % Phase 2: Update centroids
    for k = 1:K
        cluster_points = X(labels == k, :);
        if isempty(cluster_points)
            mu(k,:) = X(randi(n), :); % Re-initialisoi tyhjä klusteri
        else
            % Find a point, which minimizes sum_i |x_i - mu|^3
            % brute-force: try every point in cluster
            best_mu = cluster_points(1,:);
            best_cost = inf;
            for j = 1:size(cluster_points,1)
                candidate = cluster_points(j,:);
                cost = sum(sum(abs(cluster_points - candidate).^3));
                if cost < best_cost
                    best_cost = cost;
                    best_mu = candidate;
                end
            end
            mu(k,:) = best_mu;
        end
    end
end
end
