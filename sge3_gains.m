function g = sge3_gains(gc,param)
% sge3_gains.m
%
% Optimize the command gains for third-octave symmetric graphic equalizer
% as presented in "Third-Octave and Bark Graphic-Equalizer Design with
% Symmetric Band Filters" by J. Ramo, J. Liski, and V. Valimaki in Applied
% Sciences (11 February 2020).
% 
% Input parameters:
% gc = command gains in dB, size 31x1
% pram = struct containing fixed design parameters for GEQ
% 
% Output:
% g  = optimized band filter gains in dB, size 31x1
%
% Uses interactionMatrix_SGE3.m
%
% Created by Juho Liski, Otaniemi, Espoo, Finland, 12 February 2020
%
% Acoustics Laboratory
% Dept. of Signal Processing and Acoustics
% Aalto University

t1 = zeros(61,1); t1(1:2:61) = gc;
t1(2:2:61) = 0.5 * (gc(1:end-1) + gc(2:end)); % Linearly interpolated gain between command points

g1 = param.B'\t1; % Solve first estimate of dB gains based on leakage
G1 = 10.^(g1/20); % Convert to linear gain factors

B2 = interactionMatrix_SGE3(G1,param.c,param.wg,param.wc,param.bw); % New interaction matrix for the iterative step
g = B2'\t1; % Solve the optimal dB gains based on leakage
