% Sets
set of int: P;
set of int: S;

% Parameters
array[P, S] of int: T;  % time required to complete step s for product p
array[P, S] of int: C;  % cost of resources required to complete step s for product p
array[S] of int: available_capacity; % production capacity of each step

% Variables
array[P] of var S: step; % step[p] represents the step performed for product p
array[P] of var int: Y;  % completion time of product p

% Objective
var int: total_cost_time = sum(p in P) (T[p, step[p]] * C[p, step[p]]);

% Constraints
constraint forall(p in P) (step[p] in S); % each product must have a valid step

constraint forall(p in P) (sum(s in S where step[p] = s) (1) == 1); % each product must complete only one step

constraint forall(p in P, s1 in S, s2 in S where s1 < s2) (step[p] != s1 \/ step[p] != s2); % production steps cannot be performed simultaneously for a single product

constraint forall(s in S) (sum(p in P where step[p] = s) (C[p, s]) <= available_capacity[s]); % production capacity constraints

constraint forall(p in P, s in S) (Y[p] >= sum(s_ in 1..s) (T[p, s_] * (step[p] = s_))); % completion time constraints

solve minimize total_cost_time;

output ["\(total_cost_time)"]
