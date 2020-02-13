function evaluate_and_plot(gc,nums,dens,G0,param)
% evaluate_and_plot.m
%
% Evaluate and plot cascade graphic equalizers from "Third- Octave and Bark
% Graphic-Equalizer Design with Symmetric Band Filters" by  J. Ramo, J. 
% Liski, and V. Valimaki in Applied Sciences (11 February 2020).
% 
% Input parameters:
% gc = command gains
% num = numerator coefficients for each filter
% den = denominator coefficients for each filter
% G0 = direct gain
% param = struct containing fixed design parameters for GEQ
%
% Created by Juho Liski, Otaniemi, Espoo, Finland, 12 February 2020
%
% Acoustics Laboratory
% Dept. of Signal Processing and Acoustics
% Aalto University

M = size(nums,2); % Number of band filters

% Evaluate the frequency response
Nfreq = 2^12; % Number of frequency points for frequency response evaluation
w = logspace(log10(9),log10(22050),Nfreq); % Log frequency points
Hopt = ones(Nfreq,M); % Frequency response of individual filters
Hopttot = ones(Nfreq,1); % Frequency response of the cascade EQ
for k = 1:M
    Hopt(:,k) = freqz(nums(:,k),dens(:,k),w,param.fs);
    Hopttot = Hopt(:,k) .* Hopttot;
end
Hopttot = G0*Hopttot;

% Plot responses for the proposed optimized design
figure; clf;
%semilogx(w,db(Hopt),'linewidth',2); hold on % Band responses
%semilogx(w,db(G0)*ones(length(w),1),'linewidth',2); % Direct gain
semilogx(w,db(Hopttot),'k','linewidth',3); hold on % Total response
plot(param.fc1,gc,'ro','linewidth',2) % Command gains
set(gca,'fontname','Times','fontsize',16);
xlabel('Frequency (Hz)');ylabel('Magnitude (dB)')
set(gca,'XTick',[10 30 100 300 1000 3000 10000])
grid on
axis([10 22050 -15 15])
