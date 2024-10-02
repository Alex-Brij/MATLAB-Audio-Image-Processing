function [b, a]  = shelving(G, fc, fs, Q, type)
  % SHELVING: Applies Trebble or Base cut/boost above/below given frequency
  % 
  % This filter was written by Jeff Tackett on 08/22/05
  % Gets coefficients to be used as a shelving filter for an audio signal
  % Can either boost or cut the base or trebble based on the arguments entered
  %
  % Inputs:     
  %     -G is the logrithmic gain (in dB)
  %     -Fc is the center frequency
  %     -Fs is the sampling rate
  %     -Q adjusts the slope by replacing the sqrt(2) term
  %     -type is a character string defining filter type
  %     -Choices are: 'Base_Shelf' or 'Treble_Shelf'
 


  %Error Check
  if((strcmp(type,'Base_Shelf') ~= 1) && (strcmp(type,'Treble_Shelf') ~= 1))
    error(['Unsupported Filter Type: ' type]);
  end

  K = tan((pi * fc)/fs);
  V0 = 10^(G/20);
  root2 = 1/Q; %sqrt(2)

  %Invert gain if a cut
  if(V0 < 1)
    V0 = 1/V0;
  end
    
  %%%%%%%%%%%%%%%%%%%%
  %    BASE BOOST
  %%%%%%%%%%%%%%%%%%%%
  if(( G > 0 ) && (strcmp(type,'Base_Shelf')))
    b0 = (1 + sqrt(V0)*root2*K + V0*K^2) / (1 + root2*K + K^2);
    b1 =             (2 * (V0*K^2 - 1) ) / (1 + root2*K + K^2);
    b2 = (1 - sqrt(V0)*root2*K + V0*K^2) / (1 + root2*K + K^2);
    a1 =                (2 * (K^2 - 1) ) / (1 + root2*K + K^2);
    a2 =             (1 - root2*K + K^2) / (1 + root2*K + K^2);
  %%%%%%%%%%%%%%%%%%%%
  %    BASE CUT
  %%%%%%%%%%%%%%%%%%%%
  elseif (( G < 0 ) && (strcmp(type,'Base_Shelf')))
    b0 =             (1 + root2*K + K^2) / (1 + root2*sqrt(V0)*K + V0*K^2);
    b1 =                (2 * (K^2 - 1) ) / (1 + root2*sqrt(V0)*K + V0*K^2);
    b2 =             (1 - root2*K + K^2) / (1 + root2*sqrt(V0)*K + V0*K^2);
    a1 =             (2 * (V0*K^2 - 1) ) / (1 + root2*sqrt(V0)*K + V0*K^2);
    a2 = (1 - root2*sqrt(V0)*K + V0*K^2) / (1 + root2*sqrt(V0)*K + V0*K^2);
  %%%%%%%%%%%%%%%%%%%%
  %   TREBLE BOOST
  %%%%%%%%%%%%%%%%%%%%
  elseif (( G > 0 ) && (strcmp(type,'Treble_Shelf')))
    b0 = (V0 + root2*sqrt(V0)*K + K^2) / (1 + root2*K + K^2);
    b1 =             (2 * (K^2 - V0) ) / (1 + root2*K + K^2);
    b2 = (V0 - root2*sqrt(V0)*K + K^2) / (1 + root2*K + K^2);
    a1 =              (2 * (K^2 - 1) ) / (1 + root2*K + K^2);
    a2 =           (1 - root2*K + K^2) / (1 + root2*K + K^2);
  %%%%%%%%%%%%%%%%%%%%
  %   TREBLE CUT
  %%%%%%%%%%%%%%%%%%%%
  elseif (( G < 0 ) && (strcmp(type,'Treble_Shelf')))
    b0 =               (1 + root2*K + K^2) / (V0 + root2*sqrt(V0)*K + K^2);
    b1 =                  (2 * (K^2 - 1) ) / (V0 + root2*sqrt(V0)*K + K^2);
    b2 =               (1 - root2*K + K^2) / (V0 + root2*sqrt(V0)*K + K^2);
    a1 =             (2 * ((K^2)/V0 - 1) ) / (1 + root2/sqrt(V0)*K + (K^2)/V0);
    a2 = (1 - root2/sqrt(V0)*K + (K^2)/V0) / (1 + root2/sqrt(V0)*K + (K^2)/V0);
  %%%%%%%%%%%%%%%%%%%%
  %   All-Pass
  %%%%%%%%%%%%%%%%%%%%
  else
    b0 = V0;
    b1 = 0;
    b2 = 0;
    a1 = 0;
    a2 = 0;
  end
    
  %return values
  a = [  1, a1, a2];
  b = [ b0, b1, b2];
end
