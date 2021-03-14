%Allister Liu, Amy Leong
%DSP Project 4

clc;
clear all;
close all;

load ('s1.mat');
load ('s5.mat');
load ('vowels.mat');

%% Question 1
u=4.0e9;
chirp_time=200e-6;
sampling_freq=5e6;
t=linspace(0, chirp_time, 1000);
x = cos( 2*pi*u*t.^2 );

figure;
spectrogram( x, triang(256), 255, 256, sampling_freq, 'yaxis' );
title('Linear FM Chirp' );

%% Question 2

f1 = u*t;
phi = 2 * pi * u * t.^2;
step_size = t(2)-t(1);
f2 = 1/(2*pi) * diff(phi)/step_size;
figure;
plot(t, f1, t(2:end), f2);
xlabel('t (s)');
ylabel('f (Hz)');
title('Instantaneous Frequency');
legend('f1', 'f2');
xlim([0 2e-4]);

% the slope of f2 corresponds to the slope of the ridge in the spectrogram. When
% comparing the graph from Question 1, f2 corresponds to the slope more.

%% Question 3
u = 1e10;
x2 = cos(2 * pi * u * t.^2);
figure;
spectrogram(x2, triang(256), 255, 256, sampling_freq, 'yaxis');
title('Linear FM Chirp');

%when changing the chirp rate to 1e10, the slope increases by approximately
%2. Additionally the slope switches from a positive slope to a negative
%slope after a certain point.

%% Question 4

sampling_freq = 8e3;
figure;
subplot(2, 1, 1);
spectrogram(s1, triang(1024), 1023, 1024, sampling_freq, 'yaxis');
title('S1(\omega)');
subplot(2, 1, 2);
spectrogram(s5, triang(1024), 1023, 1024, sampling_freq, 'yaxis');
title('S5(\omega)');

%% Question 5

figure;
subplot(2, 1, 1);
spectrogram(s1, triang(128), 127, 128, sampling_freq, 'yaxis');
title('S1(\omega)');
subplot(2, 1, 2);
spectrogram(s5, triang(128), 127, 128, sampling_freq, 'yaxis');
title('S5(\omega)');

%% Question 6

s = spectrogram(vowels, rectwin(256), 128, 1024, sampling_freq, 'yaxis');
s = [s; flipud(s)];
output = inverseSTFT(s, 1024);

figure;
plot(vowels(1:size(output,1) ) - output);
title('Difference Between Original & Inverse STFT Vowels.mat');
xlabel('n');
ylabel('Amplitude');

%SOUND-> pretty similar
%soundsc( vowels, sampling_freq );
%soundsc( output, sampling_freq );
%% Question 7

s = spectrogram(vowels, rectwin(256), 128, 1024, sampling_freq, 'yaxis');
s = s(:, (1:2:end));
% s = downsample(transpose(s),2);
s = [s; flipud(s)];

output2 = inverseSTFT(s, 1024);

%SOUND-> sounds faster
%soundsc( output2, sampling_freq );

%% __FUNCTION inverseSTFT__

function output = inverseSTFT(sig, n)
    temp = real(ifft(sig));
    len = size(temp, 2);
    output = zeros(n, len);
    
    temp = temp( 1:256, : );
    cur_ind=1;
  
    for i = 1:len
        output( cur_ind:cur_ind+255, i ) = temp( :,i);
        cur_ind = cur_ind + 128; 
    end
    output = sum(output, 2);
    output(129:length(output) - 128) = output(129:length(output) - 128) / 2;
  
end
