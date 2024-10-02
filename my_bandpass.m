function [output] = my_bandpass(fc,g,Q, fs, s)
    % MY_BANDPASS: A peaking filter to boost/attenuate certain freqencies
    % 
    % This is an adapted/edited version of the function peakingEQ from:
    % https://viewer.mathworks.com/?viewer=plain_code&url=https%3A%2F%2Fww2.mathworks.cn%2Fmatlabcentral%2Fmlc-downloads%2Fdownloads%2Fsubmissions%2F19292%2Fversions%2F1%2Fcontents%2FParametric%20EQ%2FpeakingEQ.m&embed=web
    % Attenuates/boosts the centre frequencies of the set bands based on
    % the value of gain given for each band.

    % gain converted from decibels to linear scale
    g=10^(g/20);

    % normalised angular center frequency 
    t0=2*pi*fc/fs;

    % beta (used to calculate coeffiencets calculated based on if gain is
    % greater than or equal to one
    if g >= 1
        beta=t0/(2*Q);
    else
        beta=t0/(2*g*Q);
    end    

    % coefficients for filter defined
    a2=-0.5*(1-beta)/(1+beta);
    a1=(0.5-a2)*cos(t0);
    b0=(g-1)*(0.25+0.5*a2)+0.5;
    b1=-a1;
    b2=-(g-1)*(0.25+0.5*a2)-a2;

    % coefficients rearanged to SOS Form
    b=2*[b0 b1 b2];
    a=[1 -2*a1 -2*a2];


    % The filter is then applied to the audio signal 
    % signal and sampling_frequency and returned as a struct
    filtered_signal = filter(b, a, s.vector);
    filtered_struct = struct('vector', filtered_signal, 'sampling_frequency', s.sampling_frequency);
    
    output = filtered_struct;
end