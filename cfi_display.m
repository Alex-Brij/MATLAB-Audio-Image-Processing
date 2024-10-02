function [] = cfi_display(s, domain)
    % CFI_DISPLAY: Displays an image in the spatial or frequency domain
    %  takes arguments of the image (stored in an array) and the domain
    %  if domain is 's' displays image in spatial domain
    %  if domain is 'f' displays image in frequency domain 

    gcf;
    
    if domain == 's'
        imshow(s)

    elseif domain == 'f'
        % converts image to grayscale (from 3D to 2D array)
        gray_image = rgb2gray(s);
        % scales pixel values to sit between 0 and 1 and converts nums to doubles
        double_image = double(mat2gray(gray_image));
        % peforms 2D fast fourier transfrom to convert to frequency domain
        % and shifts frequency values for improved visualisation
        transformed_image = fftshift(fft2(double_image));
        % gets magnitude of each frequency component and takes log value to
        % reduce the range and imprvoe visualisation (+1 enures no zero values)
        logged_image = log(1 + abs(transformed_image));
        imshow(logged_image, []);
    end

end

