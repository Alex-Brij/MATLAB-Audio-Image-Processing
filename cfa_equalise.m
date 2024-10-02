function [ss] = cfa_equalise(s, b)
    % CFA_EQUALISE: Multi-Band Equaliser to attenuate/boost differnt frequencies
    % 
    % For the first and last frequency bands the equaliser will use a shelving filter 
    % (shelving.m, referenced in function) to attenuate/boost the frequencies above/below the cutoff frequency
    % 
    % For the middle frequency bands the signal will be passed through a peaking filter 
    % (my_bandpass.m, referenced in function) where the frequencies will be boosted/attenuated around the center frequency
    % Each time the signal is passed thorugh a filter the singal is updated
    % and the new singal is passed to the next filter untill the whole signal is filtered
    % 
    % Input:
    %   -s is the audio signal the user can filter
    %   -b is the values to controll the gain in decibels (how much to boost/attenuate the frequencies) 

    if length(b) ~= 11
        error('b does not contain the correct number of equaliser values, it must contain 11.')
    end


    % Frequencies for the centres of the bands and b which stores the equaliser levels 
    center_frequencies = [16 31.5 63 125 250 500 1000 2000 4000 8000 16000]; 

    % Gets base shelving filter
    [z, a]  = shelving( b(1), center_frequencies(1), s.sampling_frequency, 1, 'Base_Shelf' );

    % Apply the shelving filter to the audio signal and then add it to a structure
    filtered_signal = filter(z, a, s.vector);
    output = struct('vector', filtered_signal, 'sampling_frequency', s.sampling_frequency);


    % loops through and applies peak filter to all middle frequency bands
    length(center_frequencies)
    for i = 2:(length(center_frequencies) - 1)
        output = my_bandpass(center_frequencies(i), b(i), 2, output.sampling_frequency, output);
    end
    
    
    % Gets treble shelving filter
    [z, a]  = shelving( b(11), center_frequencies(11), s.sampling_frequency, 1, 'Treble_Shelf' );
    
    % Apply the shelving filter to the audio signal and then add it to a structure
    filtered_signal = filter(z, a, output.vector);
    filtered_struct = struct('vector', filtered_signal, 'sampling_frequency', s.sampling_frequency);

    ss = filtered_struct;


end



