function [nums,dens,G0] = design_band_filters(g,param)
% design_band_filters.m
%
% Design the band filters for the symmetric graphic equalizer
% presented in "Third-Octave and Bark Graphic-Equalizer Design with
% Symmetric Band Filters" by J. Ramo, J. Liski, and V. Valimaki in Applied
% Sciences (11 February 2020).
% 
% Input parameters:
% g = optimized filter gains in dB
% param = struct containing fixed design parameters for GEQ
% 
% Output:
% num = numerator coefficients for each filter
% den = denominator coefficients for each filter
% G0 = direct gain
%
% Uses peq_SGE.m
%
% Created by Juho Liski, Otaniemi, Espoo, Finland, 12 February 2020
%
% Acoustics Laboratory
% Dept. of Signal Processing and Acoustics
% Aalto University

M = length(g); % Number of EQ filters
gw = param.c.*g; % Gain at bandwidth wg
G = 10.^(g/20); % Convert to linear gain factors
Gw = 10.^(gw/20); % Convert to linear gain factor

% Design filters with optimized gains
nums = zeros(3,M);  dens = zeros(3,M); % num & den coefficients for each filters
G0 = 1; % Direct gain
for k = 1:M
    gNq = param.q1(k)*g(k) + param.q3(k)*g(k)^3;
    [num,den] = peq_SGE(1, 10^(gNq/20), G(k), Gw(k), param.wg(k), param.bw(k));
    G0 = G0*num(1);
    nums(:,k) = num/num(1);
    dens(:,k) = den;
end
