% third_octave_and_bark_symmetric_GEQs.m
%
% Design and plot GEQs as presented in "Third-Octave and Bark Graphic-
% Equalizer Design with Symmetric Band Filters" by J. Ramo, J. Liski, and 
% V. Valimaki in Applied Sciences (11 February 2020).
%
% Uses initGEQ.m, sge3_gains.m, peq_SGE.m, and bark_gains.m
%
% Created by Juho Liski, Otaniemi, Espoo, Finland, 12 February 2020
%
% Acoustics Laboratory
% Dept. of Signal Processing and Acoustics
% Aalto University

%% Third-octave GEQ

gc = 12*(2*rand(31,1)-1); % Choose your third-octave EQ gains

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GEQ DESIGN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
param = initGEQ('sge3'); % Initialize GEQ parameters
g = sge3_gains(gc,param); % Optimize the gains
[nums,dens,G0] = design_band_filters(g,param); % Design the band filters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

evaluate_and_plot(gc,nums,dens,G0,param); % Evaluate and plot the GEQ frequency response
title('Third-octave GEQ, WLS-design (SGE3)')

%% Neurally-controlled Third-octave GEQ

% Command gains are the same as above

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GEQ DESIGN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
param = initGEQ('sge3'); % Initialize GEQ parameters
g = runNeuralNet(gc, param); % Optimize the gains with the neural net
[nums,dens,G0] = design_band_filters(g,param); % Design the band filters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

evaluate_and_plot(gc,nums,dens,G0,param); % Evaluate and plot the GEQ frequency response
title('Third-octave GEQ, NN-design (NSGE3)')

%% Bark-band GEQ

gc = 12*(2*rand(24,1)-1); % Choose your Bark-band EQ gains

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GEQ DESIGN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
param = initGEQ('sgeb'); % Initialize GEQ parameters
g = bark_gains(gc,param); % Optimize the gains
[nums,dens,G0] = design_band_filters(g,param); % Design the band filters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

evaluate_and_plot(gc,nums,dens,G0,param); % Evaluate and plot the GEQ frequency response
title('Bark-band GEQ, WLS-design (SGEB)')

%% Neurally-controlled Bark-band GEQ

% Command gains are the same as above

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GEQ DESIGN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
param = initGEQ('sgeb'); % Initialize GEQ parameters
g = runNeuralNet(gc, param); % Optimize the gains with the neural net
[nums,dens,G0] = design_band_filters(g,param); % Design the band filters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

evaluate_and_plot(gc,nums,dens,G0,param); % Evaluate and plot the GEQ frequency response
title('Bark-band GEQ, NN-design (NSGEB)')

