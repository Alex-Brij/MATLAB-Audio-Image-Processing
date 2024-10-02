function [] = cfi_save(filename, s)
    % CFI_SAVE: Saves an image (stored in an array s) to a file
    %   takes the image array and the filename and saves image to a file
    imwrite(s, filename);
end

