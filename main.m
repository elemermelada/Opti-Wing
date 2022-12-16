%% INIT
clear
close all
clc

%% GET INITIAL STATE VECTOR
[y_0, Cd_aw_0, W_aw, Wtomax_0, S, b1, sweep1]=init_cond  %W_aw [kg], Cd_aw_0/(S1+S1)

global parameters;
parameters.W_aw     = W_aw;
parameters.Cd_aw    = Cd_aw;
parameters.Wtomax_0 = Wtomax_0;
parameters.S_0      = S_0;
parameters.b1       = b1;
parameters.sweep1   = sweep1;

%% OPTIMIZER
%Order vector y: croot,taper1,taper2,b2,sweep2,twist1,twist2,CSTroot(1,12),CSTkink(1,12),CSTtip(1,12),Wwing,E,Wfuel
%TODO: hay que adimensionalizar, vector inial y_0 y constraints

LB = [0.8, 0, 0, 0.8, 0.8, -0.5, -0.5, ...
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, ...
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, ...
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, ...
    0.8, 0.8, 0.8];

UB = [1.2, 1, 1, 1.2, 1.2, 2, 2, ...
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
    1.2, 1.2, 1.2];

[x,fval,exitflag] = fmincon(@(x)optim(x),y_0,[],[],[],[],LB,UB,@(x)Constraints(x),options)