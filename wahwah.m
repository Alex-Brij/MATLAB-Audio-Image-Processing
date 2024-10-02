function [output] = wahwah(x, minf, maxf, Fw, damp, Fs)
    % WAHWAHs: WahWah filter
    % 
    % Original function written by Ronan O'Malley, October 2nd 2005
    % This funciton has been adapated from that funcion
    % It takes an audio signal and applies a wah-wah affect to it by boosting certain frequencies
    % like a bandpass and moving the centre freqeuncy backwards and forwards
    % The filter sweeping up and down is controlled by a triangle wave and gives the wah-wah affect 
    % 
    % Inputs:
    %   -x: audio signal in 
    %   -minf: the lower frequency limit of the band 
    %   -maxf: the higher frequency limit of the band
    %   -Fw: the rate at which the wah-wah affect sweeps through each band
    %   -damp: controls the damping of the wah-wah affect and how
    %    pronounced the effect is
    %   -Fs: The sampling frequency of the singal 

    
    % change in centre frequency per sample (Hz)
    delta = Fw/Fs;

    % create triangle wave of centre frequency values
    Fc=minf:delta:maxf;
    while(length(Fc) < length(x) )
        Fc = [ Fc (maxf:-delta:minf) ];
        Fc = [ Fc (minf:delta:maxf) ];
    end

    % trim tri wave to size of input
    Fc = Fc(1:length(x));

    % difference equation coefficients
    % must be recalculated each time Fc changes
    F1 = 2*sin((pi*Fc(1))/Fs);
    % this dictates size of the pass bands
    Q1 = 2*damp;
    % create empty out vectors
    yh=zeros(size(x));
    yb=zeros(size(x));
    yl=zeros(size(x));
    % first sample, to avoid referencing of negative signals
    yh(1) = x(1);
    yb(1) = F1*yh(1);
    yl(1) = F1*yb(1);


     % apply difference equation to the sample
     for n=2:length(x)
         yh(n) = x(n) - yl(n-1) - Q1*yb(n-1);
         yb(n) = F1*yh(n) + yb(n-1);
         yl(n) = F1*yb(n) + yl(n-1);
         F1 = 2*sin((pi*Fc(n))/Fs);
     end

     %normalise
     maxyb = max(abs(yb));
     output = yb./maxyb;
           


end

