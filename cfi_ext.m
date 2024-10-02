function [output] = cfi_ext(image1, image2)
    % CFI_EXT: Peforms image registration to allign, scale and rotate two images
    % 
    %   Arguments: user enters two structs containg two images that are simmilar but are at
    %   different rotations, allignments and scales and have been loaded into matlab using cfi_load
    %   The images are then procesed, registered and displayed in a series of subplots that show the registration process and the final images
    %   The ouput of the function is the registered image, it can then be saved or displayed etc.
    %   Included are some sets of test images, they need to first be loaded using cfi_load, 
    %   then the structs (outputs from cfi_load) should be used as argments in this function
    %   The order the images are entered in as arguments can make a difference to the results
    %   Some of the code was adapapted from: https://stackoverflow.com/questions/29127181/matching-images-with-different-orientations-and-scales-in-matlab

    % converts images to gray
    image1_gray = rgb2gray(image1);
    image2_gray = rgb2gray(image2);

    % detects distincitve features in each image, robust to scaling and rotation, stored in SURFPoints array
    feature_points1 = detectSURFFeatures(image1_gray);
    feature_points2 = detectSURFFeatures(image2_gray);

    % extracts vectors to represent the feautres and their corresponding locations
    [features1, points1] = extractFeatures(image1_gray, feature_points1);
    [features2, points2] = extractFeatures(image2_gray, feature_points2);

    % matches the sets of extracted features and contains indicies of the matched features
    matched_feature_indicies = matchFeatures(features1, features2);

    % stores the matched features for each image
    matchedPoints1 = points1(matched_feature_indicies(:, 1));
    matchedPoints2 = points2(matched_feature_indicies(:, 2));

    % estimates the geometric transformation needed to go from image 2 to image 1
    geometric_transformation = estgeotform2d(matchedPoints2, matchedPoints1, 'similarity');
    
    % creates the registered image by warping image2 using the transform
    registered_image2 = imwarp(image2, geometric_transformation);

    image1_gray = rgb2gray(image1);
    image2_gray = rgb2gray(image2);
    registered_image2_gray = rgb2gray(registered_image2);    


    % PLOTTING

    figure;

    subplot(2, 3, 1)
    imshow(image1)
    title('Image1')
    
    subplot(2, 3, 2)
    imshow(image2)
    title('Image2')

    subplot(2, 3, 3)
    imshow(registered_image2)
    title('Registered Image 2')

    subplot(2, 3, 4)
    showMatchedFeatures(image1, image2, matchedPoints1, matchedPoints2, 'montage');
    title('Image 1 and Image 2 matching points');
    
    subplot(2, 3, 5)   
    showMatchedFeatures(image1,registered_image2, matchedPoints1(1:1:1), matchedPoints2(1:1:1));
    title('Image 1 and Registered Image 2 Overlayed');

    figure;
    
    output = registered_image2;


end

