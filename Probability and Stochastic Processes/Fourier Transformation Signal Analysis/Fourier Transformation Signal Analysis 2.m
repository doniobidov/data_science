% Parameters
duration = 1; % Signal duration (second)
fs = 256e3; % Sampling frequency (256 kHz)
f_signal = 95.5e6; % Frequency of the sinusoid (95.5 MHz)
t = 0:1/fs:duration-1/fs; % Time vector
signal = sin(2*pi*f_signal*t); % Generate the sinusoidal signal

% Add white Gaussian noise with variance 0.001
variance = 0.02;
noise = sqrt(variance) * randn(size(t));
noisy_signal = signal + noise;

% Compute the SNR
SNR = snr(noisy_signal);

% Compute the spectrum
N = length(noisy_signal);
fft_result = fftshift(fft(noisy_signal));
frequencies = (-N/2:N/2-1) * fs / N;
power_spectrum = abs(fft_result).^2 / N;

% Convert to dB
power_spectrum_db = 10 * log10(power_spectrum);

% Plot the spectrum
figure;
plot(frequencies/1000, power_spectrum_db);
xlabel('Frequency (kHz)');
ylabel('Power (dB)');
title(['Power Spectrum with SNR = ' num2str(SNR) ' dB']);
xlim([-5, 5]); % Set x-axis limits
grid on;

% Plot the spectrum
figure;
plot(frequencies/1000, power_spectrum_db);
xlabel('Frequency (kHz)');
ylabel('Power (dB)');
title(['Power Spectrum with SNR = ' num2str(SNR) ' dB']);
xlim([-10, 10]); % Set x-axis limits
grid on;

% Plot the noisy signal over time
figure;
plot(t, noisy_signal);
title(['Noisy Sinusoidal Signal with SNR = ' num2str(SNR) ' dB']);
xlabel('Time (s)');
ylabel('Amplitude');
grid on;