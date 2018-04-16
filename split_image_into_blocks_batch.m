
% Erick Lu
% split_image_into_blocks_batch.m
% This code was written to quantify GC B cell dispersion in
% processed IHC images. The IgD and GL7 single stain images from ImageJ
% were split into 25x25 pixel boxes using the "mat2cell" function. Each
% individual box was analyzed for IgD and GL7 content using the "numel"
% function to count pixels. For each picture, the proportion of GL7 
% positive stain, along with the raw IgD and GL7 counts, are exported into 
% an excel file for further analysis. Parts of this code were adapted from 
% from Image Analyst (matlab authorid: 31862).

%==========================================================================
% Reading in the Images
%==========================================================================
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
workspace;  % Make sure the workspace panel is showing.
fontSize = 20;
    
% Set the working directory to the folder containing the image files.
% MODIFY HERE TO SELECT NEW BATCH FROM FOLDER
folder = cd('/Users/ericklu/Desktop/Bioinformatics/ihc_quant/pictures')
folder = cd('/Users/ericklu/Desktop/Bioinformatics/ihc_quant/pictures')

% Generate a list of all the files in the folder.
files = dir('*.jpg');
folder_size = length(files)

% MODIFY HERE TO MATCH DESTINATION FOLDER
pairing_log = fopen('pairing_log.txt', 'w')

% The following code will begin looping through all the files in the 
% folder, extract the correct pairs of images, then store output data 
% in a text file

n = 1
while n < folder_size
    baseFileName_a = files(n).name
    baseFileName_b = files(n+1).name
    
    fprintf(pairing_log, 'Files paired are %s and %s\n', baseFileName_a, baseFileName_b);
    
    % Get the full filename, with path prepended.
    fullFileName_a = fullfile(folder, baseFileName_a)
    fullFileName_b = fullfile(folder, baseFileName_b)

    rgbImage_a = imread(fullFileName_a);
    rgbImage_b = imread(fullFileName_b);

    %Convert the images to true binary, since they contain some bleeding 
    %grey pixels from ImageJ Jpg conversion.
    bwImage_a = im2bw(rgbImage_a);
    bwImage_b = im2bw(rgbImage_b);

    % Display image full screen, side by side.
    %subplot (1,2,1), imshow (bwImage_a);
    %subplot (1,2,2), imshow (bwImage_b);

    % for RGB images and 1 for black/white images.
    [rows columns numberOfColorBands] = size(bwImage_a)
    [rows_b columns_b numberOfColorBands_b] = size(bwImage_b)
    %Verify that rows == rows_b and columns == columns_b
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Select Block Size and Create Matrix containing separate blocks using
    % mat2cell
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %MODIFY HERE TO CHANGE BLOCK SIZE
    blockSizeR = 25; % Pixel height for each block (row height).
    blockSizeC = 25; % Column height for each block (column height).

    % Figure out the size of each block in rows. 
    % Most will be blockSizeR but there may be a remainder amount of less than that.
    wholeBlockRows = floor(rows / blockSizeR);
    blockVectorR = [blockSizeR * ones(1, wholeBlockRows), rem(rows, blockSizeR)];

    % Figure out the size of each block in columns. 
    wholeBlockCols = floor(columns / blockSizeC);
    blockVectorC = [blockSizeC * ones(1, wholeBlockCols), rem(columns, blockSizeC)];

    % Generate a matrix containing the split image.
    ca_a = mat2cell(bwImage_a, blockVectorR, blockVectorC);
    ca_b = mat2cell(bwImage_b, blockVectorR, blockVectorC);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Run the loop to calculate pixel # of IgD and GL7 Stain, write to file.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Specify output text file to store data in:
    %MODIFY HERE TO MATCH BLOCK DIMENSIONS
    output_name = strrep(baseFileName_a, '_a.jpg', '_25x25.txt')
    
    fileID = fopen(output_name,'w');
    
    % Now display all the blocks.
    plotIndex = 1;
    numPlotsR = size(ca_a, 1);
    numPlotsC = size(ca_a, 2);

    %run the loop to analyze each block and spit out color quantification
    %values
    for r = 1 : numPlotsR
        for c = 1 : numPlotsC
            fprintf('plotindex = %d,   c=%d, r=%d\n', plotIndex, c, r);
            % Specify the location for display of the image.
            
            %UNCOMMENT THE NEXT LINE TO SHOW IMAGE
            %subplot(numPlotsR, numPlotsC, plotIndex);

            % Extract the numerical array out of the cell
            bwBlock_a = ca_a{r,c};
            bwBlock_b = ca_b{r,c};

            %UNCOMMENT THE NEXT LINE TO SHOW IMAGE
            %imshow(bwBlock_b); % Could call imshow(ca{r,c}) if you wanted to.
            [rowsB columnsB numberOfColorBandsB] = size(bwBlock_a)

            %Count the number of black pixels in the IgD Stain
            count_white_IgD = sum(bwBlock_a(:))
            numexact_IgD = numel(bwBlock_a) - count_white_IgD

            %Count the number of black pixels, in the SAME block, on the GL7
            %Stain.
            count_white_GL7 = sum(bwBlock_b(:))
            numexact_GL7 = numel(bwBlock_b) - count_white_GL7

            %Verify that you are counting the same total pixels between the IgD
            %and GL7 Stains, so that they can be compared.
            numpixels_IgD = numel(bwBlock_a);
            numpixels_GL7 = numel(bwBlock_b);

            %Calculate the proportion of IgD: IgD+GL7 stain.
            proportion_GL7 = numexact_GL7/(numexact_GL7 + numexact_IgD)

            %Print the data to your output file.
            fprintf(fileID,'%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n', plotIndex, rowsB, columnsB, numexact_IgD, numexact_GL7, proportion_GL7, numpixels_IgD, numpixels_GL7);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %UNCAPTION THE FOLLOWING LINES TO GENERATE THE IMAGE
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Mark the index # for each block as it is printed to the screen.
            %caption = sprintf('#%d',plotIndex);
            %title(caption);
            %drawnow;

            % Increment the subplot to the next location.
            plotIndex = plotIndex + 1;
        end
    end

    %Close the text file that your data is now stored in.
    fclose(fileID)
    
    %Increment n so that the next iteration of the while loop will analyze
    %the next pair of images.
    n = n + 2
end

%Close the pairing log file.
fclose(pairing_log)



   