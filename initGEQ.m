function param = initGEQ(mode)
% initGEQ.m
%
% Initialize the parameters for the graphic equalizers presented in "Third-
% Octave and Bark Graphic-Equalizer Design with Symmetric Band Filters" by 
% J. Ramo, J. Liski, and V. Valimaki in Applied Sciences (11 February 2020).
% 
% Input parameters:
% mode = select the mode: 'sge3' for third-octave
%                         'sgeb' for bark band
%
% Output:
% param  = struct containing the initialized parameters
%
% Uses initInterMatSGE3.mat, initInterMatBark.mat,
% nsge3_neuralNetParams.mat, and nsgeb_neuralNetParams
%
% Created by Juho Liski, Otaniemi, Espoo, Finland, 12 February 2020
%
% Acoustics Laboratory
% Dept. of Signal Processing and Acoustics
% Aalto University

switch lower(mode)
    case {'sge3','third-octave','nsge3'} % Third-octave
        param.fs = 44.1e3; % Sample rate
        param.fc1 = 1000.*(2.^((1/3)*(-17:13))); % Exact log center frequencies for filters
        param.fc2(1:2:61) = param.fc1;
        param.fc2(2:2:61) =  sqrt(param.fc1(1:end-1).*param.fc1(2:end)); % Extra design points between filters (Hz)
        param.wg = 2*pi*param.fc1/param.fs; % Command gain frequencies in radians
        param.wc = 2*pi*param.fc2/param.fs; % Center frequencies in radians for iterative design with extra points
        param.c = 0.38; % Gain factor at bandwidth (parameter c)
        param.bw = (nthroot(2,3)-1/nthroot(2,3))*param.wg; % Bandwidths in radians
        param.bw(17:end) = 2*pi*[369.7 465.8 586.8 739.3 930.6 1172 1476 1857 2338 ...
            2943 3704 4638 5684 6803 4117]/param.fs; % Bandwidth adjustments
        load('initInterMatSGE3.mat','B'); % First interaction matrix has been precomputed
        param.B = B;
        param.q1 = zeros(1,31); param.q3 = zeros(1,31); % Polynomial coefficients for Nyquist gain
        param.q1(23:31) = [0.00166 0.00295 0.00544 0.0105 0.0214 0.0456 0.103 0.257 0.754];
        param.q3(23:31) = [8.09e-6 1.25e-5 1.91e-5 2.84e-5 4.08e-5 5.46e-5 6.27e-5 3.68e-5 -1.18e-4];
        load('nsge3_neuralNetParams.mat')
        param.theta1 = theta1;
        param.theta2 = theta2;
        param.theta3 = theta3;
        param.tmax = tmax;
        param.tmin = tmin;
        param.W1 = W1;
        param.W2 = W2;
        param.W3 = W3;
        param.xmax = xmax;
        param.xmin = xmin;

        
    case {'sgeb','bark','nsgeb'} % Bark band
        param.fs = 44.1e3; % Sample rate
        param.fc1 = [50 150 250 350 450 570 700 840 1000 1170 1370 1600 1850 2150 ...
            2500 2900 3400 4000 4800 5800 7000 8500 10500 13500];
        param.fc2(1:2:47) = param.fc1;
        param.fc2(2:2:47) =  sqrt(param.fc1(1:end-1).*param.fc1(2:end)); % Extra design points between filters (Hz)
        param.wg = 2*pi*param.fc1/param.fs; % Command gain frequencies in radians
        param.wc = 2*pi*param.fc2/param.fs; % Center frequencies in radians for iterative design with extra points
        param.c = 0.42*ones(24,1); % Gain factor at bandwidth (parameter c)
        param.c(1) = 0.36;
        param.bw(1:23) = param.fc1(2:24) - (param.fc1(1:23)).^2./(param.fc1(2:24)); % Bandwidths in Hertz
        param.bw(24) = 6000; % Must be set by hand
        param.bw = 2*pi*param.bw/param.fs;
        param.W = 0.5*eye(2*24-1); % Weight matrix for the LS solution
        param.W(1,1) = 1;
        load('initInterMatBark.mat','B'); % First interaction matrix has been precomputed
        param.B = B;
        param.q1 = zeros(1,24); param.q3 = zeros(1,24); % Polynomial coefficients for Nyquist gain
        param.q1(19:24) = [0.00377 0.00606 0.0111 0.0244 0.0714 0.134];
        param.q3(19:24) = [1.61e-5 2.30e-5 3.43e-5 5.35e-5 7.98e-5 8.37e-5];
        load('nsgeb_neuralNetParams.mat')
        param.theta1 = theta1;
        param.theta2 = theta2;
        param.theta3 = theta3;
        param.tmax = tmax;
        param.tmin = tmin;
        param.W1 = W1;
        param.W2 = W2;
        param.W3 = W3;
        param.xmax = xmax;
        param.xmin = xmin;
    otherwise
        error('No such EQ mode; choose ''SGE3'' or ''SGEB''.')      
end
