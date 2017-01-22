close all; clear all; clc

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

minB1propA = 0.30; 
maxB1propB = 0.45; 
minB1propC = 0.25; 
maxB2propA = 0.35; 
minB2propB = 0.30; 
maxB2propC = 0.40; 

% B1amountA + B2amountA <= availA;
% B1amountB + B2amountB <= availB;
% B1amountC + B2amountC <= availC;

% B1amountA + B1amountB + B1amountC >= minAmountB1; --->
% - B1amountA - B1amountB - B1amountC <= -minAmountB1;

% B2amountA + B2amountB + B2amountC >= minAmountB2; --->
% - B2amountA - B2amountB - B2amountC <= -minAmountB2;

% B1propA + B1propB + B1propC = 1
% B2propA + B2propB + B2propC = 1

% volB1 = B1amountA + B1amountB + B1amountC;
% volB2 = B2amountA + B2amountB + B2amountC;

% B1amountA >= minB1propA * volB1 -->
% B1amountA >= minB1propA * (B1amountA + B1amountB + B1amountC) -->
% 0 >= minB1propA * B1amountA - B1amountA + minB1propA * B1amountB + minB1propA * B1amountC -->
% 0 >= (minB1propA  - 1) * B1amountA + minB1propA * B1amountB + minB1propA * B1amountC -->
% (minB1propA  - 1) * B1amountA + minB1propA * B1amountB + minB1propA * B1amountC <= 0

% B1amountB <= maxB1propB * volB1 -->
% B1amountB <= maxB1propB * (B1amountA + B1amountB + B1amountC) -->
% 0 <= maxB1propB * B1amountA + maxB1propB * B1amountB - B1amountB + maxB1propB * B1amountC -->
% 0 <= maxB1propB * B1amountA +(maxB1propB  - 1) * B1amountB + maxB1propB * B1amountC -->
% -maxB1propB * B1amountA -(maxB1propB  - 1) * B1amountB - maxB1propB * B1amountC <= 0

% B1amountC >= minB1propC * volB1 -->
% B1amountC >= minB1propC * (B1amountA + B1amountB + B1amountC) -->
% 0 >= minB1propC * B1amountA + minB1propC * B1amountB + minB1propC * B1amountC - B1amountC -->
% 0 >= minB1propC * B1amountA + minB1propC * B1amountB + B1amountC  * (minB1propC - 1) -->
% minB1propC * B1amountA + minB1propC * B1amountB + B1amountC * (minB1propC - 1) <= 0


% B2amountA <= maxB2propA * volB2 -->
% B2amountA <= maxB2propA * (B2amountA + B2amountB + B2amountC) -->
% 0 <= maxB2propA * B2amountA - B2amountA + maxB2propA * B2amountB + maxB2propA * B2amountC -->
% 0 <= (maxB2propA  - 1) * B2amountA + maxB2propA * B2amountB + maxB2propA * B2amountC -->
% -(maxB2propA  - 1) * B2amountA - maxB2propA * B2amountB - maxB2propA * B2amountC <= 0

% B2amountB >= minB2propB * volB2 -->
% B2amountB >= minB2propB * (B2amountA + B2amountB + B2amountC) -->
% 0 >= minB2propB * B2amountA + minB2propB * B2amountB - B2amountB + minB2propB * B2amountC -->
% 0 >= minB2propB * B2amountA +(minB2propB  - 1) * B2amountB + minB2propB * B2amountC -->
% minB2propB * B2amountA +(minB2propB  - 1) * B2amountB + minB2propB * B2amountC <= 0

% B2amountC <= maxB2propC * volB2 -->
% B2amountC <= maxB2propC * (B2amountA + B2amountB + B2amountC) -->
% 0 <= maxB2propC * B2amountA + maxB2propC * B2amountB + maxB2propC * B2amountC - B2amountC -->
% 0 <= maxB2propC * B2amountA + maxB2propC * B2amountB + (maxB2propC - 1) * B2amountC  -->
% -maxB2propC * B2amountA - maxB2propC * B2amountB - (maxB2propC -1) * B2amountC  <= 0

%combine variables into one vector
variables = {'B1amountA','B1amountB','B1amountC',...
             'B2amountA','B2amountB','B2amountC',...
             };
N = length(variables);
S = size(variables);
for v = 1:N 
   eval([variables{v},' = ', num2str(v),';']); 
end

%maximize profit
B1profA = B1price - costA;
B1profB = B1price - costB;
B1profC = B1price - costC;

B2profA = B2price - costA;
B2profB = B2price - costB;
B2profC = B2price - costC;
% profit = B1price * B1amount    % (B1amount = B1amountA + B1amountB + B1amountC)
%        - costA   * B1amountA 
%        - costB   * B1amountB
%        - costB   * B1amountC 
%        + B2price * B2amount    % (B2amount = B2amountA + B2amountB + B2amountC)
%        - costA   * B2amountA 
%        - costB   * B2amountB 
%        - costC   * B1amountC
%
%       == B1profA * B1amountA
%        + B1profB = B1amountB
%        + B1profC = B1amountC
%        + B2profA = B2amountA
%        + B2profB = B2amountB
%        + B2profC = B2amountC

f = zeros(S);
f([B1amountA B1amountB B1amountC B2amountA B2amountB B1amountC]) = ...
  [B1profA   B1profB   B1profC   B2profA   B2profB   B2profC  ];

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
%lb = zeros(S); %initialize with zeros for undefined lower bonds 
% lb([B1amount, B2amount, B1amountA, B1amountC, B2amountB]) = ...
%    [10000,    10000,    0.3,       0.25,      0.3      ];
%lb([B1amount, B2amount, B1amountA, B1amountC, B2amountB, B1amountB, B2amountA, B2amountC]) = ...
%   [10000,    10000,    0.3,       0.25,      0.3,       0,         0,         0        ];

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
%ub = Inf(size(variables));
% ub([availA, availB, availC, B1amountB, B2amountA, B2amountC]) = ...
%    [5000,   10000,  15000,  0.45,      0.35,      0.4      ];
%ub([availA, availB, availC, B1amountB, B2amountA, B2amountC, B1amountA], B1amountC, B2amountB) = ...
%   [5000,   10000,  15000,  0.45,      0.35,      0.4,       1,          1,         1        ];

% linear inequality constraints

eqNum = 11; % number of inequity constraints
cnt = 1;
A = zeros(eqNum, N); b = zeros(eqNum,1);
% B1amountA + B2amountA <= availA;
A(cnt, B1amountA) = 1; A(cnt, B2amountA) = 1; b(cnt) = availA; cnt = cnt + 1;
% B1amountB + B2amountB <= availB;
A(cnt, B1amountB) = 1; A(cnt, B2amountB) = 1; b(cnt) = availB; cnt = cnt + 1;
% B1amountC + B2amountC <= availC;
A(cnt, B1amountC) = 1; A(cnt, B2amountC) = 1; b(cnt) = availB; cnt = cnt + 1;
%- B1amountA - B1amountB - B1amountC <= -minAmountB1;
A(cnt, B1amountA) = -1; A(cnt, B1amountB) = -1; A(cnt, B1amountC) = -1; b(cnt) = -minAmountB1; cnt = cnt + 1;
%- B1amountA - B1amountB - B1amountC <= -minAmountB1;
A(cnt, B2amountA) = -1; A(cnt, B2amountB) = -1; A(cnt, B2amountC) = -1; b(cnt) = -minAmountB1; cnt = cnt + 1; 
% (minB1propA  - 1) * B1amountA + minB1propA * B1amountB + minB1propA * B1amountC <= 0
A(cnt, B1amountA) = minB1propA  - 1; A(cnt, B1amountB) = minB1propA; A(cnt, B1amountC) = minB1propA; cnt = cnt + 1; 
% -maxB1propB * B1amountA -(maxB1propB  - 1) * B1amountB - maxB1propB * B1amountC <= 0
A(cnt, B1amountA) = -maxB1propB ; A(cnt, B1amountB) = -(maxB1propB - 1); A(cnt, B1amountC) = -maxB1propB; cnt = cnt + 1; 
% minB1propC * B1amountA + minB1propC * B1amountB + B1amountC * (minB1propC - 1) <= 0
A(cnt, B1amountA) = minB1propC ; A(cnt, B1amountB) = minB1propC; A(cnt, B1amountC) = minB1propC - 1; cnt = cnt + 1; 
% -(maxB2propA  - 1) * B2amountA - maxB2propA * B2amountB - maxB2propA * B2amountC <= 0
A(cnt, B2amountA) = -(maxB2propA  - 1); A(cnt, B2amountB) = -maxB2propA; A(cnt, B2amountC) = -maxB2propA; cnt = cnt + 1; 
% minB2propB * B2amountA +(minB2propB  - 1) * B2amountB + minB2propB * B2amountC <= 0
A(cnt, B2amountA) = minB2propB ; A(cnt, B2amountB) = minB2propB - 1; A(cnt, B2amountC) = minB2propB; cnt = cnt + 1; 
% -maxB2propC * B2amountA - maxB2propC * B2amountB - (maxB2propC -1) * B2amountC  <= 0
A(cnt, B2amountA) = -maxB2propC ; A(cnt, B2amountB) = -maxB2propC; A(cnt, B2amountC) = -(maxB2propC - 1); cnt = cnt + 1; 

% set lower bonds for all values to 0
lb = zeros(S);

% set upper bonds for all values to Infinity
ub = Inf(S);

%options = optimoptions('linprog','Algorithm','dual-simplex');
%[x fval] = linprog(-f,A,b,Aeq,beq,lb,ub);
%[x fval] = linprog(-f,A,b,Aeq,beq,lb,ub,options);
[x fval] = linprog(-f,A,b,[],[],lb,ub);
for d = 1:N
  fprintf('%12.2f \t%s\n',x(d),variables{d}) 
end
