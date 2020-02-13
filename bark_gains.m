function g = bark_gains(gc,param)
% bark_gains.m
%
% Optimize the command gains for bark-band symmetric graphic equalizer
% as presented in "Third-Octave and Bark Graphic-Equalizer Design with
% Symmetric Band Filters" by J. Ramo, J. Liski, and V. Valimaki in Applied
% Sciences (11 February 2020).
% 
% Input parameters:
% gc = command gains in dB, size 24x1
% param = struct containing fixed design parameters for GEQ
% 
% Output:
% g  = optimized band filter gains in dB, size 24x1
%
% Uses interactionMatrix_Bark.m
%
% Created by Juho Liski, Otaniemi, Espoo, Finland, 12 February 2020
%
% Acoustics Laboratory
% Dept. of Signal Processing and Acoustics
% Aalto University

t1 = zeros(47,1); t1(1:2:47) = gc;
t1(2:2:47) = 0.5 * (gc(1:end-1) + gc(2:end)); % Linearly interpolated gain between command points

g1 = (param.B * param.W * param.B.') \ (param.B * param.W * t1); % Solve first estimate of dB gains based on leakage
G1 = 10.^(g1/20); % Convert to linear gain factors

B2 = interactionMatrix_Bark(G1,param.c,param.wg,param.wc,param.bw); % New interaction matrix for the first iterative step
g2 = (B2 * param.W * B2.') \ (B2 * param.W * t1); % Solve dB gains for the first iterative step based on leakage
G2 = 10.^(g2/20); % Convert to linear gain factors

B3 = interactionMatrix_Bark(G2,param.c,param.wg,param.wc,param.bw); % New interaction matrix for the second iterative step
g = (B3 * param.W * B3.') \ (B3 * param.W * t1); % Solve the optimal dB gains based on leakage
