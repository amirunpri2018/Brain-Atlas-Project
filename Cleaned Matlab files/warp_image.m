function Imgregistered = warp_image(image, skeleton, movingPoints, fixedPoints, sktoimg, plot)
    % NOTE: Load package.mat first if you need the existing Control Points
    %% Read images
    % Reads the image and resizes it
    I = imread(image);
%     I = imread('5 images and skeleton/20180614_D1CreSnap25_M96_G_RB_pDMS_Part1_R3C2_001.tif');
    I = rgb2gray(I);
    I = imresize(I, 0.1, 'bicubic');
    I = padarray(I,[50 50],0,'both');

    % Reads the skeleton and resizes it
    J = imread(skeleton);
%     J = imread('5 images and skeleton/27_AP_0.14.tif');
    J = J(:,:,1:3);
    J = rgb2gray(J);
    J = imresize(J, 0.1, 'bicubic');
    J = bitcmp(J);
    J = im2bw(J, 0.05);
    J = padarray(J,[50 50],0,'both');
    J = im2double(J);

    %% Control point selection
    % Lets you select the Control Points on both the images
    % Save the Control Points in the work-space
    % cpselect(J, I) % Uncomment to access the Control Point selection tool

    %% if fitting skeleton to image
    if sktoimg
        tform = fitgeotrans(movingPoints, fixedPoints, 'polynomial', 2);
        Imgregistered = imwarp(J,tform,'OutputView',imref2d(size(I)));
        
        if plot
            figure;
            imshowpair(Imgregistered,I)
        end

    %% if fitting image to skeleton
    else
        tform = fitgeotrans(fixedPoints, movingPoints, 'polynomial', 2);
        Imgregistered = imwarp(I,tform,'OutputView',imref2d(size(J)));
        
        if plot
            figure;
            imshowpair(Imgregistered,J)
        end
    end
end