function [] = cfa_play(s, v)
    % CFA_PLAY: Plays the audio signal at v percent volume
    % If two arguments entred plays the audio clip at v percent volume
    % If no volume specified plays audo clip at defualt of 100% volume

    if nargin == 2
        volume = v / 100;
    else 
        volume = 1;
    end

    sound((s.vector * volume), s.sampling_frequency)

end

