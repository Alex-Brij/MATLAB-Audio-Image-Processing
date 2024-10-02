function [output] = cfa_ext(varargin)
    % CFA_EXT: Provides preset waveforms to use m-fold wah-wah filter on
    % 
    % Uses Signal Processing Toolbox for sawtooth function
    % Uses function wahwah.m, referenced in function
    % This function first genereates a waveform: sine, sawtooth, triangle,
    % square and applies wah wah filters to the waveform
    % 
    % 2 modes- Auto and Custom. In auto mode user sets max and min
    % frequencies and m. Frequency range (between max and min frequency
    % values) is split into m equal size bands which the wah-wah's are applied to. 
    % INPUTS MUST BE ENTERED IN ORDER SPECIFIED BELOW.
    % 
    % Auto- The user can control (inputs):
    %   - shape: the type of waveform generated
    %   - duration: the duration of the waveform selected
    %   - m: the number of wah-wah filters applied
    %   - min_frequency: the minimum frequency the filters are applied to
    %   - max_frequency: the maximum frequency the filters are applied to
    %   - speed: the speed the wah wah affect sweeps through each band it is applied to
    %   - damp: the damping of the wah wah affect
    % 
    %   - examle input: s = cfa_ext("triangle", 6, 4, 100, 15000, 5000, 0.1);
    % 
    % 
    % In custom mode the user specifies the lower and upper limits for one or multiple frequency bands
    % as well as the speed and damp of the wah-wah filter that is applied to that band to. 
    % INPUTS MUST BE ENTERED IN ORDER SPECIFIED BELOW.
    % 
    % Custom- The user can control (inputs):
    %   - shape: the type of waveform generated
    %   - duration: the duration of the waveform selected
    %   - custom_controls: array with recurring sets of four numbers, representing the lower frequency limit, upper frequncy limit, speed, and damping for each custom frequency band
    %     e.g. [lower_frequency_limit_1 upper_frequency_limit_1 speed_1 damp_1 lower_frequency_limit_2 upper_frequency_limit_2 speed_2 damp_2]
    % 
    %   - examle input: s = cfa_ext("triangle", 6, [100 5000 3000 0.01 10000 12000 10000 0.05]);
    % 
    % 
    % Output of both Auto and Custom:
    %   - the wah-wah filtered signal
    % 
    % The filtered audio signal is played and plotted next to the original



    shape = varargin{1}
    duration = varargin{2}

 
    Fs = 44100; % Sampling frequency
    T = 1/Fs; % Sampling period
    L = duration*Fs; % Length of signal
    t = (0:L-1)*T; % Time vector
    f = 440; % Frequency of wave (440 Hz is the A4 note)


    % CREATE THE WAVEFORM

    if shape == "sine"
        % Amplitude of sine wave
        A = 0.5; 
        % Generate sine waveform
        y = A*sin(2*pi*f*t);
        
    elseif shape == "sawtooth"
        % Generate sawtooth waveform
        y = sawtooth(2*pi*f*t);
            
    elseif shape == "triangle"      
        % Generate triangle waveform (uses sawtooth function but width is
        % changed to 0.5 to give a triangle wave)
        y = sawtooth(2*pi*f*t, 0.5);

    elseif shape == "square"      
        % Generate square waveform
        y = square(2*pi*f*t);

    end

    % fftshifts original singal ready to plot
    normal_signal = fftshift(fft(y));



    % AUTO MODE
    if nargin == 7

        m = varargin{3}
        min_frequency = varargin{4}
        max_frequency = varargin{5}
        speed = varargin{6}
        damp = varargin{7}

        low_limit = min_frequency;
        % sets width of each band by dividing total frequency range by number of bands
        band_size = ((max_frequency-min_frequency)/m);
    
        % applies m wah-wah filters to the singal, applying to a new band on
        % each iteration of the loop by adjusting the limits
        for i = 1:m
            y = wahwah(y, low_limit, low_limit + band_size, speed, damp, Fs);
            low_limit = low_limit + band_size;
        end
    

    % CUSTOM MODE
    elseif nargin == 3

        custom_controls = varargin{3}
       
        % applies wah-wah filter to each frequency band, loops
        % through array to get lower limits, upper limits, speed, damp respectively
        length(custom_controls)
        for i = 1:4:length(custom_controls) 
            lower_limit = custom_controls(i);
            upper_limit = custom_controls(i + 1);
            speed = custom_controls(i + 2);
            damp = custom_controls(i + 3);
            y = wahwah(y, lower_limit, upper_limit, speed, damp, Fs);
        end

        % sets m so that it displays the correct m-fold number in the tittle of the graph
        m = (length(custom_controls) / 4);

    % ERROR
    else
        error('Incorrect number of arguments provided')
    end



    % Creates struct for output, plays wah-wah'd signal
    output = struct('vector', y, 'sampling_frequency', Fs);
    cfa_play(output)


    wah_signal = fftshift(fft(y));
    number_samples = length(wah_signal);

    % Creates the frequency axis which scales each audio sample to represent the frequency in HZ
    frequency = [0:(floor(number_samples/2) - 1)] * (Fs / number_samples);
    index = [(ceil(number_samples/2) + 1):number_samples];


    % PLOTS BOTH SIGNALS SIDE BY SIDE 
    gcf;

    subplot(1, 2, 1);
    plot(frequency, abs(normal_signal(index)), 'g')
    title('Original signal (green)');
    xlabel('Frequency (HZ)');
    ylabel('Magnitude');

    subplot(1, 2, 2);
    plot(frequency, abs(wah_signal(index)), 'r')
    title([num2str(m), ' Fold Wah-Wah Filtered Signal (red)']);
    xlabel('Frequency (HZ)');
    ylabel('Magnitude');


end

