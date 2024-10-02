function [m] = cfi_segment(s, threshold)
    % CFI_SEGMENT: Segments image into forground/background using binary mask
    % Segments image into foreground and background 
    % Produce binary mask m labelling foreground pixels 1 and background pixels 0
    % If no value for threshold provided uses matlabs automatic method for finiding a threshold- graythresh
    % Takes unit-8 images

    

    % converts image to grey (2D matrix)
    gray_image = rgb2gray(s);
    % imhist(gray_image, 256)
    
    if nargin == 2 
        if threshold < 256 && threshold > -1
            % creates binary mask, piexels with intensity > threshold set to 1, pixels with intensity < threshold set to 0
            m = gray_image > threshold;
            imshow(m);
        else
            error("Please enter a value for threshold between 0 and 255")
        end
    
    else
        % matlab creates threshold value using Otsu's method and then
        % its applied to the image to create the binary mask
        automatic_level = graythresh(gray_image);
        m = imbinarize(gray_image,automatic_level);
        imshow(m);
    end



end

