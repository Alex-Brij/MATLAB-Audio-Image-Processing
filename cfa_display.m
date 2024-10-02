function [] = cfa_display(s, domain)
    % CFA_DISPLAY: Plots audio signal in time or frequency domain
    % Takes audio signal and domain as arguments- domain is specified by user
    %      - 'f': signal is plotted in frequency domain
    %      - 't': signal is plotted in time domain

    gcf;
    % plot in time domain
    if domain == 't'
        
        % length of the audio signal gives the number of samples in the signal
        % the sampling frequency gives the number of samples taken per second
        % dividing the two gives the duration of the audio signal
        % create a linear time vector from zero to the length/duration of the signal
        % with number of points being the number of samples in the singal
        t = linspace(0, length(s.vector)/s.sampling_frequency, length(s.vector));

        % plots the time against samples (amplitude of each sample)
        plot(t, s.vector)
        title('Audio signal plotted in Time Domain');
        xlabel('Time (S)');
        ylabel('Amplitude');    
    


    % plot in frequency domain
    elseif domain == 'f'

        % Fourier transform converts the equally spaced samples from time into frequency domain
        % It breaks the sinnal down into its constituent frequency and represents it using complex numbers
        % The fft function uses an algorithm to do this efficiently and fftshift centres frequencies around zero
        % Magniture will be plotted against frequency  
        transformed_signal = fftshift(fft(s.vector));
        number_samples = length(transformed_signal);
    
        % Creates the frequency axis which scales each audio sample to represent the frequency in HZ
        frequency = [0:(floor(number_samples/2) - 1)] * (s.sampling_frequency / number_samples);
        index = [(ceil(number_samples/2) + 1):number_samples];
        
        % plots the frequency axis (from the fourier transform) agains the magnitude of each sample
        plot(frequency, abs(transformed_signal(index)))
        title('Audio signal plotted in Frequency Domain');
        xlabel('Frequency (HZ)');
        ylabel('Magnitude');    

    end

    
end


