% Sets
set of int: P;
set of int: S;

% Parameters
array[P, S] of int: T;  % time required to complete step s for product p
array[P, S] of int: C;  % cost of resources required to complete step s for product p
array[S] of int: available_capacity; % production capacity of each step

% Variables
array[P, S] of var 0..1: X; % binary variable indicating whether step s is performed for product p
array[P] of var int: Y;     % completion time of product p

% Objective
var int: total_cost_time = sum(p in P, s in S) (X[p,s] * T[p,s] * C[p,s]);

% Constraints
constraint forall(p in P) (sum(s in S) (X[p,s]) == 1); % each product must complete all required steps

constraint forall(p in P, s1 in S, s2 in S where s1 < s2) (X[p,s1] + X[p,s2] <= 1); % production steps cannot be performed simultaneously for a single product

constraint forall(s in S) (sum(p in P) (X[p,s] * C[p,s]) <= available_capacity[s]); % production capacity constraints

constraint forall(p in P, s in S) (
  Y[p] >= sum(s1 in 1..s) (T[p,s1] * X[p,s1])
); % completion time constraints

% Symmetry Breaking
constraint forall(p1 in P, p2 in P where p1 < p2) (
  Y[p1] <= Y[p2]
);

solve minimize total_cost_time;

output ["\(total_cost_time)"]
