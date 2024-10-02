function [s] = cfi_load(filename)
    % CFI_LOAD: Reads image file and saves it as an array 
    % Can handle multiple differnt filetypes including JPEG, PNG
    % Loads image from a specified file name in the same folder as the
    % function
    s = imread(filename);
end

