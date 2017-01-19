%
%
%
%
%
%

%Constraints
% costA = 0.33;
% costB = 0.4;
% costC = 0.48;
% availA <= 5000;
% availB <= 10000;
% availC <= 15000;

% 1 = B1amountA + B1amountB + B1amountC
% B1amountA >= 0.3
% B1amountB <= 0.45
% B1amountC >= 0.25

% 1 = B2amountA + B2amountB + B2amountC
% B2amountA <= 0.35
% B2amountB >= 0.3
% B2amountC <= 0.4

% B1price = 1;
% B2price = 1.2;
% 
% B1amount >= 10000;
% B2amount >= 10000;

%maximize profit
% f = B1price * B1amount + B2price * B2amount - 

variables = {'costA','costB','costC',...
             'availA','availB','availC',...
             'B1amountA','B1amountB','B1amountC',...
             'B2amountA','B2amountB','B2amountC',...
             'B1price','B2price',...
             'B1amount','B2amount',...
             };
N = length(variables);
for v = 1:N 
   eval([variables{v},' = ', num2str(v),';']); 
end

%variables with lower bounds
lb = Inf(size(variables));
lb([B1amount, B2amount, B1amountA, B1amountC, B2amountB]) = ...
   [10000,    10000,    0.3,       0.25,      0.3      ];

%variables with upper bounds
ub = Inf(size(variables));
ub([availA, availB, availC, B1amountB, B2amountA, B2amountC]) = ...
   [5000,   10000,  15000,  0.45,      0.35,      0.4      ];

A = zeros(3, N);
%A(1, I1) = 1;

options = optimoptions('linprog','Algorithm','dual-simplex');
[x fval] = linprog(f,A,b,Aeq,beq,lb,ub,options);
for d = 1:N
  fprintf('%12.2f \t%s\n',x(d),variables{d}) 
end
fval

