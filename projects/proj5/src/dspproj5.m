%Allister Liu, Amy Leong 
%DSP Project 5
clear; close all; clc;

%% Setup
load pj2data;

%% Part A

% A.1 %

y1 = y(1:32);
cy1y1_biased = xcorr(y1, y1, 'biased');
cy1y1_unbiased = xcorr(y1, y1, 'unbiased');
y1_conv = conv(y1, fliplr(y1));

figure();
hold on;
plot( 0.95*max(y1_conv)/max(cy1y1_biased)*cy1y1_biased, 'DisplayName', 'xcorr_b_i_a_s_e_d' );
plot( y1_conv, 'DisplayName', 'conv' );
hold off;
title( "Autocorrelation of y1" )
legend();

% When replacing biased with unbiased, it is calculating the unbiased
% estimate of the cross correlation (1/(N-|m|) * Rxy(m)). When looking at
% the graph of both biased and unbiased, the biased plot seemed to be
% exactly on top of the conv plot. For unbiased, it seems like the
% amplitudes are slowly increasing and matches the peak in the middle and
% then decreasing again. 

% A.2 %

  % a)
    %   The Fourier transform of this autocorrelation function is the psd,
    %   that's why it is a real positive function.
    
  % b) + c)
    phi_d_y1y1 = zeros(1,32);
    ya2 = y(1:32);
    for i = 1:32
        phi_d_y1y1(i) = sum(ya2(1:32-i+1) .* ya2(i:32))/32;
    end
    % deterministic autocorrelation of y1
    phi_d_y1y1 = [flip(phi_d_y1y1) phi_d_y1y1(2:end)];
    Phi_d_y1y1 = fft(phi_d_y1y1, 64);
    Cy1y1 = fft(cy1y1_biased, 64);
    
    figure();
    subplot(2,2,1)
    plot(0:63, abs(Cy1y1))
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    title('64 point DFT of C_y_1_y_1[m]');
    subplot(2,2,3)
    plot(0:63, abs(Phi_d_y1y1))
    xlabel('Frequency (Hz)')
    ylabel('Magnitude')
    title('64 point DFT of \phi^d_y_1_y_1[m]');
    
    subplot(2,2,2)
    plot(0:63, angle(Cy1y1))
    xlabel('Frequency (Hz)')
    ylabel('Phase')
    title('Phase of 64 point DFT of C_y_1_y_1[m]');
    subplot(2,2,4)
    plot(0:63, angle(Phi_d_y1y1))
    xlabel('Frequency (Hz)')
    ylabel('Phase')
    title('Phase of 64 point DFT of \phi^d_y_1_y_1[m]');
         
    %the 64 point DFT of c_y1y1[m] looks about the same as the 64 point
    %phi^d_y1y1
    
% A.3 %

  % a)
    figure();
    subplot(3,1,1);
    plot(0:63, abs(Phi_d_y1y1));
    title('|\phi^d_y_1_y_1|');
    
  % b)
    Y1_ejw2 = abs(fft(y1,64)).^2;
    subplot(3,1,2);
    plot(0:63, Y1_ejw2/64);
    title('|Y_1(e^j^w)|^2');
    
  % c)
    y64 = y(1:64);
    Y64_ejw2 = abs(fft(y64,64)).^2;
    subplot(3,1,3);
    plot(0:63, Y64_ejw2/64);
    title('|Y_6_4(e^j^w)|^2');

figure();
hold on

plot(0:63, abs(Phi_d_y1y1),'DisplayName','|\phi^d_y_1_y_1|');
plot(0:63, Y1_ejw2/64,'DisplayName','|Y_1(e^j^w)|^2');
plot(0:63, Y64_ejw2/64,'DisplayName','|Y_6_4(e^j^w)|^2');
hold off;
title('Comparasion for A.3.a, A.3.b, A.3.c');
legend();
xlim([0 63]);

%the three graphs(a.3.a, a.3.b, a.3.c) look like theres the same shape. However, the amplutide
%of each graph vary slightly. 

%% Part B

for i = 1:4
    Bn(i) = i;
end

%B.1%

figure();
hejw2 = downsample(Hejw2, 8);
hold on;
plot( 0:63, hejw2);
plot( 0:63, Y1_ejw2/64 );
hold off;
title( "PDS of y[n]" );
legend();
xlabel( "n points" );
ylabel( "Magnitude" );
legend('|H(e^{jw})|^2','|Y1(e^{jw})|^2' );
xlim ([0 64]);

error  = sum((hejw2 - Y1_ejw2/64).^2 );
error=error/64;
Error(1) = error;
disp( "Estimation error with 32 points: " + error );

%B.2%

yejw2 = abs(fft(y,1024)).^2;
Yejw2 = downsample(yejw2, 2);
Yejw2_1024=Yejw2/1024;

figure();
hold on;
plot( Hejw2);
plot( Yejw2_1024 );
hold off;
title( "PDS of y[n]" );
xlabel( "n points" );
ylabel( "Magnitude" );
legend('|H(e^{jw})|^2','|Y2(e^{jw})|^2' );
xlim ([0 512]);

figure();
x=y(1:64);
wind= rectwin(64);
periodogram( x, wind, 512 );
error2  = sum((Hejw2 - Yejw2_1024).^2 ) / 512;
Error(2) = error2;
disp( "Estimation error with 512 points: " + error2 );

%B.3%
y_b3=zeros(1,64);
for i = 1:16
    y1=(i-1)*32+1;
    y_b = y(y1: y1+31);
    y_b3=y_b3+abs(fft(y_b, 64)).^2;
end

y_b3=y_b3/16;
y_b3=y_b3/64;

Hejw2_b3 = downsample(Hejw2,8);
figure();
hold on
plot (Hejw2_b3);
plot (y_b3);
title( "PDS of y[n]" );
xlabel( "n points" );
ylabel( "Magnitude" );
legend('|H(e^{jw})|^2','|Y3(e^{jw})|^2' );
xlim([0 64]);

error3  = sum((Hejw2_b3 - y_b3).^2 ) /64;
Error(3) = error3;
disp( "Estimation error with periodgram: " + error3 );

% the estimation error for the 64 point estimation using periodgram averaging
% is less than the estimation error for b.1 and b.2. The estimation error
% for this is approximately 3.14, whereas the estimation error for b.1 and
% b.2 are both approximately around 7.5. In comparison, b.3 performs better than b.1 and b.2

%B.4%
figure();
y_b4 = xcorr(y,y,'unbiased');
y_b4 = y_b4(497: 527);
hold on
plot (hejw2);
plot(abs(fft(y_b4,64)));
title( "PDS of y[n]" );
xlabel( "n" );
ylabel( "Magnitude" );
legend('|H(e^{jw})|^2','|Y4(e^{jw})|^2' );
error4 = sum((hejw2-abs(fft(y_b4,64))).^2)/64;
Error(4) = error4;
disp( "Estimation error with indirect Blackman-Tukey: " + error4 );

%B.5%
Bn = Bn';
Error = Error';
T = table(Bn, Error);
T(1:4,:)

Y_b5 = abs(fft(triang(31)'.* y_b4,64));
figure();
hold on;
plot (hejw2);
plot (Y_b5);
title( "PDS of y[n]" );
xlabel( "n" );
ylabel( "Magnitude" );
legend('|H(e^{jw})|^2','|Y5(e^{jw})|^2' );
error5 = sum((hejw2-Y_b5).^2)/64;
disp( "Estimation error with new estimation: " + error5 );

%Indirect Blackman-Tukey performed the best. It had the smallest number for 
%estimation error. For Blackman-Tukey, you calculate the autocorrelation, apply a window
%function, and compute the fft. This Blackman-Tukey method uses the autocorrelation
%function which smooths the wave rather than taking the average of different waveforms.
%The estimation error in b.5 is less than the estimation error in b.4. The
%performance is different because you are truncating the autocorrelation in
%b.4. This causes the largest variances to be cut off and compromises the
%resolution. 
