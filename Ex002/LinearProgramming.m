%Constraints
B1price = 1;
B2price = 1.2;

costA = 0.33;
costB = 0.4;
costC = 0.48;

availA =  5000;
availB = 10000;
availC = 15000;

minAmountB1 = 10000;
minAmountB2 = 10000;

% B1amountA + B2amountA <= availA;
% B1amountB + B2amountB <= availA;
% B1amountC + B2amountC <= availA;

% B1amountA + B1amountB + B1amountC >= minAmountB1; --->
% B2amountA + B2amountB + B2amountC >= minAmountB2; --->

% - B1amountA - B1amountB - B1amountC <= -minAmountB1;
% - B2amountA - B2amountB - B2amountC <= -minAmountB2;

% B1amountA = B1propA * AinB1;
% B1amountB = B1propB * BinB1;
% B1amountC = B1propC * CinB1;

% B2amountA = B2propA * AinB2
% B2amountB = B2propB * BinB2
% B2amountC = B2propC * CinB2

% B1propA + B1propB + B1propC = 1
% B2propA + B2propB + B2propC = 1

% 1 = B1amountA + B1amountB + B1amountC
minB1propA = 0.30;
maxB1propA = 1.00;
minB1propB = 0.00;
maxB1propB = 0.45;
minB1propC = 0.25;
maxB1propC = 1.00;
minB2propA = 0.00;
maxB2propA = 0.35;
minB2propB = 0.30;
maxB2propB = 1.00;
minB2propC = 0.00;
maxB2propC = 0.40;

%combine variables into one vector
variables = {'B1amountA','B1amountB','B1amountC',...
             'B2amountA','B2amountB','B2amountC',...
             'B1amount','B2amount',...
             'B1propA', 'B1propC', 'B1propC',...
             'B2propA', 'B2propC', 'B2propC',...
             'AinB1', 'BinB1', 'CinB1',...
             'AinB2', 'BinB2', 'CinB2',...
             };
N = length(variables);
S = size(variables);
for v = 1:N 
   eval([variables{v},' = ', num2str(v),';']); 
end

%maximize profit
% profit = B1price * B1amount
%        + B2price * B2amount 
%        - costA   * B1amountA 
%        - costB   * B1amountB
%        - costB   * B1amountC 
%        - costA   * B2amountA 
%        - costB   * B2amountB 
%        - costC   * B1amountC
f = zeros(size(variables));
f([B1amount B2amount B1amountA B1amountB B1amountC B2amountA B2amountB B1amountC]) = ...
  [B1price  B2price  costA     costB     costC     costA     costB     costC    ];

% linear constraints
% variables with lower bounds
% B1amount >= 10000;
% B2amount >= 10000;
% B1amountA >= 0.3
% B1amountC >= 0.25
% B2amountB >= 0.3
% B1amountB >= 0
% B2amountA >= 0
% B2amountC >= 0
lb = zeros(S); %initialize with zeros for undefined lower bonds 
% lb([B1amount, B2amount, B1amountA, B1amountC, B2amountB]) = ...
%    [10000,    10000,    0.3,       0.25,      0.3      ];
lb([B1amount, B2amount, B1amountA, B1amountC, B2amountB, B1amountB, B2amountA, B2amountC]) = ...
   [10000,    10000,    0.3,       0.25,      0.3,       0,         0,         0        ];

% variables with upper bounds
% availA <= 5000;
% availB <= 10000;
% availC <= 15000;
% B1amountB <= 0.45
% B2amountA <= 0.35
% B2amountC <= 0.4
% B1amountA <= 1
% B1amountC <= 1
% B2amountB <= 1
ub = Inf(size(variables));
% ub([availA, availB, availC, B1amountB, B2amountA, B2amountC]) = ...
%    [5000,   10000,  15000,  0.45,      0.35,      0.4      ];
ub([availA, availB, availC, B1amountB, B2amountA, B2amountC, B1amountA], B1amountC, B2amountB) = ...
   [5000,   10000,  15000,  0.45,      0.35,      0.4,       1,          1,         1        ];

% linear inequality constraints

inN = 8; % number of inequity constraints
A = zeros(inN, N); beq = zerosinN(N,1);
A(1,I1) = 1; A(1,HE1) = -1; b(1) = 132000;
A(2,EP) = -1; A(2,PP) = -1; b(2) = -12000;


% linear equality constraints
% B1amountA + B1amountB + B1amountC = 1
% B2amountA + B2amountB + B2amountC = 1

%  write the Aeq matrix and beq vector corresponding to these equations
eqN = 8; % number of equity constraints
Aeq = zeros(eqN, N); beq = zeros(eqN,1);
Aeq(1,[B1amountA, B1amountB, B1amountC]) = [1,1,1]; beq(1) = 1;
Aeq(2,[B2amountA, B2amountB, B2amountC]) = [1,1,1]; beq(2) = 1;

lb([B1amount, B2amount, B1amountA, B1amountC, B2amountB, B1amountB, B2amountA, B2amountC]) = ...
   [10000,    10000,    0.3,       0.25,      0.3,       0,         0,         0        ];

%options = optimoptions('linprog','Algorithm','dual-simplex');
[x fval] = linprog(-f,A,b,Aeq,beq,lb,ub;
%[x fval] = linprog(-f,A,b,Aeq,beq,lb,ub,options);
for d = 1:N
  fprintf('%12.2f \t%s\n',x(d),variables{d}) 
end
