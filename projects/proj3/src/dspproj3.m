%Allister Liu, Amy Leong
%DSP Project 3 

clc;
clear all;
close all;

load ('projIB.mat');
%sound(noisy,fs);  

%specifications for the filter
passband_edge = 2500;
stopband_edge = 4000;

%create the filter using built in matlab function designfilt
butter = designfilt('lowpassiir','PassbandFrequency',passband_edge, 'StopbandFrequency',stopband_edge,'PassbandRipple',3,'StopbandAttenuation',55,'SampleRate',fs,'DesignMethod','butter'); 
chebyshevI = designfilt('lowpassiir','PassbandFrequency',passband_edge,'StopbandFrequency',stopband_edge,'PassbandRipple',3,'StopbandAttenuation',55,'SampleRate',fs,'DesignMethod','cheby1');     
chebyshevII = designfilt('lowpassiir','PassbandFrequency',passband_edge, 'StopbandFrequency',stopband_edge,'PassbandRipple',3, 'StopbandAttenuation',55,'SampleRate',fs,'DesignMethod','cheby2');
elliptic = designfilt('lowpassiir','PassbandFrequency',passband_edge,'StopbandFrequency',stopband_edge,'PassbandRipple',3, 'StopbandAttenuation',55,'SampleRate',fs,'DesignMethod','ellip');     
mcclellan = designfilt('lowpassfir','PassbandFrequency',passband_edge,'StopbandFrequency',stopband_edge,'PassbandRipple',3,'StopbandAttenuation',55,'SampleRate',fs,'DesignMethod','equiripple');        
kaiser = designfilt('lowpassfir','PassbandFrequency',passband_edge,'StopbandFrequency',stopband_edge,'PassbandRipple',3,'StopbandAttenuation',55,'SampleRate',fs,'DesignMethod','kaiserwin');

%find the order, number of multiplications and graph each of the 6 filters 
%play the sound using sound sc

[butter_mult] = graph(butter, fs);
butter_order = filtord(butter);           %get the order of butterworth filter
filter_butter = filter(butter, noisy);
disp ("Butterworth filter order: "+butter_order);
disp ("Multiplications for Butterworth filter: "+butter_mult);
%soundsc(filter_butter,fs);

[chebyshevI_mult] = graph(chebyshevI, fs);
chebyshevI_order = filtord(chebyshevI);       %get order of chebyshevI filter
filter_chebyshevI = filter(chebyshevI, noisy);
disp ("ChebyshevI filter order: "+chebyshevI_order);
disp ("Multiplications for ChebyshevI filter: "+chebyshevI_mult);
%soundsc(filter_chebyshevI,fs);

[chebyshevII_mult] = graph(chebyshevII, fs);
chebyshevII_order = filtord(chebyshevII);            %get order of chebyshevII filter
filter_chebyshevII = filter(chebyshevII, noisy);
disp ("ChebyshevII filter order: "+chebyshevII_order);
disp ("Multiplications for ChebyshevII filter: "+chebyshevII_mult);
%soundsc(filter_chebyshevII,fs);

[elliptic_mult] = graph(elliptic, fs);
elliptic_order = filtord(elliptic);                %get order of elliptic filter   
filter_elliptic = filter(elliptic, noisy);
disp ("Elliptic filter order: "+elliptic_order);
disp ("Multiplications for Elliptic filter: "+elliptic_mult);
%soundsc(filter_elliptic,fs);

[mcclellan_mult] = graph(mcclellan, fs);
mcclellan_order = filtord(mcclellan);            %get order of mcclellan filter
filter_mcclellan = filter(mcclellan, noisy);
disp ("McClellan filter order: "+mcclellan_order);
disp ("Multiplications for McClellan filter: "+mcclellan_mult);
%soundsc(filter_mcclellan,fs);

[kaiser_mult] = graph(kaiser, fs);
kaiser_order = filtord(kaiser);           %get order of kaiser filter
filter_kaiser = filter(kaiser, noisy);
disp ("Kaiser filter order: "+kaiser_order);
disp ("Multiplications for Kaiser filter: "+kaiser_mult);
%soundsc(filter_kaiser,fs);

% after filtering the noisy signal with each of the 6 de-noising filter,
% the audio was clearer. When playing the original audio, there was only a
% hissing sound. After applying the filters, we were able to hear "that
% noise problem grows more annoying each day"



function[mult] = graph(in, fs)
    [H,f] = freqz(in, fs);           %magnitude response
    [z,p,k] = zpk(in);
    mult = length(z) + length(p) + 2;
    
    figure;
    subplot(3,1,1);
    plot(f,20*log10(abs(H)))
    title ('Magnitude Response');
    xlabel('Frequency');

    subplot(3,1,2)
    plot(f,abs(H))
    xlim([0, 0.5])
    title ('Passband Ripple in Magnitude Response');
    xlabel('Frequency');  
    
    [group_delay,w_delay] = grpdelay(in, fs);                %plot group delay
    subplot(3,1,3);
    plot(w_delay,group_delay);
    title ('Group Delay');
    xlabel ('Frequency');
    
    [hz, hp, ht] = zplane(in);            %pole zero plot
    figure;
    subplot(2,1,1);
    zplane(hz,hp);
    title('Pole-Zero plot');
    
    [h_imp, w_imp] = impz(in, 100);               %impulse response for 100 samples 
    subplot(2,1,2);
    stem([1:100],h_imp);
    title('Impulse Response (100 samples)');
    xlabel('Samples');
end