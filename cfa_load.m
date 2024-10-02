function [s] = cfa_load(filename)
    % CFA_LOAD: Loads in and stores audio file
    % Will load an audio file: wav, flac or ogg; and store it in a sturcture arrray
    % Stores the audio signal and the sampling frequency.
    % This loaded audio signal can then be used in other functions
    
    
    % Audio signal is stored in vector y with sample rate Fs
    [y, Fs] = audioread(filename);
    
    % Created a strucure with two fields that stores the values for the audios
    % signal vector and the sampling frequency of the signal
    s = struct('vector', y, 'sampling_frequency', Fs);

end

