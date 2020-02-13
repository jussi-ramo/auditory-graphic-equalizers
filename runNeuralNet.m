function filterGains = runNeuralNet(targetGains, param)
% runNeuralNet.m
%
% Optimize the command gains for symmetric GEQ using neural net
% as presented in "Third-Octave and Bark Graphic-Equalizer Design with
% Symmetric Band Filters" by J. Ramo, J. Liski, and V. Valimaki in Applied
% Sciences (11 February 2020).
% 
% Input parameters:
% targetGains = command gains in dB
% param  = struct containing the initialized parameters
%
% Output:
% filterGains  = optimized band filter gains in dB
%
% Created by Jussi Ramo, Otaniemi, Espoo, Finland, 12 February 2020
%
% Acoustics Laboratory
% Dept. of Signal Processing and Acoustics
% Aalto University

% Initialize variables
M = length(targetGains);    % Number of EQ filters
g = zeros(M,1);             % Scaled input gains [-1 1]
o1 = zeros(2*M,1);          % Output of the 1st hidden layer
o2 = zeros(M,1);			% Output of the 1st hidden layer
go = zeros(M,1);			% Scaled output gains [-1 1]
filterGains = zeros(M,1);	% Output gains in dB

% Filter gain calculation using the neural net
g = 2.*(targetGains - param.xmin)./(param.xmax - param.xmin) - 1;	% Eq. (4)
o1 = tanh(param.W1*g + param.theta1);                               % Eq. (5)
o2 = tanh(param.W2*o1 + param.theta2);                              % Eq. (6)
go = param.W3*o2 + param.theta3;                                    % Eq. (7)
filterGains = (param.tmax - param.tmin).*(go + 1)/2 + param.tmin;	% Eq. (8)