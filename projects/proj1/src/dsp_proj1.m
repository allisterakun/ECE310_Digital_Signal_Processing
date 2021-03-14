%Allister Liu, Amy Leong
%DSP Project #1

clear all;
clc; 

[x,fs] = audioread('Wagner.wav');
y=srconvert([1 zeros(1,3000)]);
verify(y);
z = srconvert(x.');
sound(x,fs);                 %to compare the sound of the audio signal
waitforbuttonpress
sound(z,24000);

function [out] = srconvert(in)
% This function uses a combination of upsampling and downsampling. 
% The numbers(factors) were arbitrarily chosen based on 320(upsample) 
% and 147(downsample).

% Multiplications and additions keep track of the number of
% times each operation was used
additions = 0; multiplications = 0;
tic
    [out, additions,multiplications] = filterupsample(in,2,additions,multiplications);
    [out, additions,multiplications] = filterupsample(out,2,additions,multiplications);
    [out, additions,multiplications] = filterupsample(out,2,additions,multiplications);
    [out, additions,multiplications] = filterupsample(out,2,additions,multiplications);
    [out, additions,multiplications] = filterupsample(out,2,additions,multiplications);
    [out, additions,multiplications] = filterupsample(out,2,additions,multiplications);
    [out, additions,multiplications] = filterupsample(out,5,additions,multiplications);
    out = 7*downsample(out,7);
    out = 7*downsample(out,7);
    out = 3*downsample(out,3);
toc
display(additions); display(multiplications);

end

function [out, addition, multiplication] = filterupsample(input, L, addition, multiplication)
    %Filters are broken up into stages so the coefficients could be used
    %for polyphase decomposition
    in = repmat(input,L,1);
    filt = designfilt('lowpassfir', 'PassbandFrequency', 1/L, 'StopbandFrequency', 1.2/L, 'PassbandRipple', 0.03, 'StopbandAttenuation', 85, 'DesignMethod', 'equiripple');
    E = poly1(filt.Coefficients,L);
    out1 = zeros(L,length(E(1,:))+length(in(1,:))-1);
    for n = 1:L
        out1(n,:) = conv(E(n,:),in(n,:));
    end
    out2 = zeros(L,L*(length(out1(1,:))));
    for n = 1:L
        out2(n,:) = (upsample(out1(n,:).',L)).';
        out2(n,:) = circshift(out2(n,:),n-1);
    end
    out = sum(out2);
    addition = addition+(length(filt.Coefficients) -1);
    multiplication = multiplication+length(filt.Coefficients);
end