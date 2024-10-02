function [] = cfa_save(filename, s)
    % CFA_SAVE: Saves an audio signal to a file
   
    audiowrite(filename, s.vector, s.sampling_frequency);

end

