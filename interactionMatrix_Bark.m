function [leak] = interactionMatrix_Bark(G,gw,wg,wc,bw)
% interactionMatrix_Bark.m
% 
% Compute the interaction matrix of a cascade graphic equalizer containing
% the leak factors to account for the band interaction when assigning
% filter gains. All filters are Orfanidis peak/notch filters with
% adjustable bandwidth gain and Nyquist gain.
% 
% Input parameters:
% G  = Linear gain at which the leakage is determined
% gw = Gain factor at bandwidth (0.5 refers to db(G)/2)
% wg = Command frequencies i.e. filter center frequencies (in rad/sample)
% wc = Design frequencies (rad/sample) at which leakage is computed
% bw = Bandwidth of filters in radians
% 
% Output:
% leak = N by M matrix showing how the magnitude responses of the
% band filters leak to the design frequencies. N is determined from the
% length of the array wc (number of design frequencies) whereas M is 
% determined from the length of wg (number of filters)
%
% Written by Vesa Valimaki, Espoo, Finland, 12 April 2016
% Modified by Juho Liski, Espoo, Finland, 12 February 2020
%
% Acoustics Laboratory
% Dept. of Signal Processing and Acoustics
% Aalto University

M = length(wg);  % The number of center frequencies (filters)
N = length(wc);  % The number of design frequencies
leak = zeros(M,N);  % Initialize interaction matrix
Gdb = db(G);  % Convert linear gain factor to dB

Z = exp(-1i*wc); % Creating z^-1
Z2 = Z.^2; % Creating z^-2

q1 = zeros(1,24); q3 = zeros(1,24); % Polynomial coefficients for Nyquist gain
q1(19:24) = [0.00377 0.00606 0.0111 0.0244 0.0714 0.134];
q3(19:24) = [1.61e-5 2.30e-5 3.43e-5 5.35e-5 7.98e-5 8.37e-5];

% Estimate leak factors of peak/notch filters
for m = 1:M
    if any(Gdb)
        
        Gdbw = gw(m)*Gdb(m);  % dB gain at bandwidth
        Gw = 10.^(Gdbw/20);  % Convert to linear gain factors
        
        gNq = q1(m)*Gdb(m) + q3(m)*Gdb(m)^3; % Nyquist gain
        G1 = 10^(gNq/20);

        F = abs(G(m)^2 - Gw^2);
        G00 = abs(G(m)^2 - 1);
        F00 = abs(Gw^2 - 1);

        G01 = abs(G(m)^2 - G1);
        G11 = abs(G(m)^2 - G1^2);
        F01 = abs(Gw^2 - G1);
        F11 = abs(Gw^2 - G1^2);

        W2 = sqrt(G11/G00)* tan(wg(m)/2)^2;
        DW = (1 + sqrt(F00 / F11) * W2) * tan(bw(m)/2);

        C = F11 * DW^2 - 2 * W2 * (F01 - sqrt(F00 * F11));
        D = 2 * W2 * (G01 - sqrt(G00 * G11));

        A = sqrt((C + D) / F);
        B = sqrt((G(m)^2 * C + Gw^2 * D) / F);

        num = [(G1 + W2 + B), -2*(G1 -W2), (G1 - B + W2)]/(1 + W2 + A);
        den = [1, [-2*(1 - W2), (1 + W2 - A)]/(1 + W2 + A)];
        
        H = (num(1) + num(2)*Z + num(3)*Z2)./(den(1) + den(2)*Z + den(3)*Z2);
        Gain = db(H)/Gdb(m); % Normalized interference (Re 1 dB)
        leak(m,:) = abs(Gain); % Store gain in a matrix
        
    else % If all gains are 0 dB 
        temp(1:2*M+1:2*M^2-M) = 1;
        leak = reshape(temp,M,2*M-1);
    end  
    
end
end
