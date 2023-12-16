% Reset the random number generator
rng('default');

% Parameters
pulse_duration = 0.02; % Duration of the rectangular pulse (20 ms)
total_duration = 2; % Total signal duration (2 s)
fs = 10e3; % Sampling frequency (10 kHz)
variance = 0.02; % Noise variance

% Create a time vector for the entire signal
t = 0:1/fs:total_duration-1/fs;

% Generate the rectangular pulse signal
signal = rectpuls(t, pulse_duration);

% Add white Gaussian noise with variance 0.002
noise = sqrt(variance) * randn(size(t));
noisy_signal = signal + noise;

% Compute the SNR
SNR = snr(signal, noise);

% Display the SNR
disp(['SNR = ' num2str(SNR) ' dB']);