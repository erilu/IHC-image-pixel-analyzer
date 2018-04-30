# IHC pixel analyzer - Quantifying intermixing of cells

For a [study](http://jem.rupress.org/content/212/13/2213) published in the Journal of Experimental Medicine, my lab needed to quantify the amount of intermixing of two different cell types from two-color immunohistochemistry images. We were interested in how "confined" a cell type was to a particular niche in lymphoid organs.

To do this, I wrote a [matlab script](https://github.com/erilu/IHC-image-pixel-analyzer/blob/master/split_image_into_blocks_batch.m) to split an image into blocks and export the amount of each stain within each block. If two cell types are intermixed, we would expect that most of the blocks would contain both stains. If cells are tightly confined from each other, then we would expect that most of the blocks contain only one the stains.

To analyze the matlab output, I wrote a [R script](https://github.com/erilu/IHC-image-pixel-analyzer/blob/master/IHC_block_analyzer.R) to provide an overall statistic for the original image. I used these scripts to quantify hundreds of images for the publication. Here, I will take you through the general workflow for two example images.

---

## General Workflow:
1. Use ImageJ to convert a Blue/Brown IHC stain to binary, single-stain pictures, using the IHC toolbox. Below is an example of converting an original IHC image into binary, single-stain images:
![general_workflow_IHC_quant](https://github.com/erilu/IHC-image-pixel-analyzer/blob/master/readme_pictures/imageJ_processing.jpg) If you have a batch of images you would like to quantify, place all the binary images in a single folder, with each single-stain indicated as "(nameofpicture)\_a" and "(nameofpicture)\_b".

2. Run the matlab script, indicating the name of the folder that contains the pictures. The raw table output is generated in the same folder. What this matlab script does is split each binary image up into separate blocks. Below is a depiction of how the black and white pictures are split into blocks. You can toggle the block size. I have chosen to use rather large blocks just for demonstration purposes:
![split_a](https://github.com/erilu/IHC-image-pixel-analyzer/blob/master/readme_pictures/split_blocks_a.jpg)
![split_b](https://github.com/erilu/IHC-image-pixel-analyzer/blob/master/readme_pictures/split_blocks_b.jpg) After splitting the image, the script will export the proportion of black vs white pixels in each block.

3. Run the R script to analyze the matlab output. These output files contain a .csv file that has the fraction of blocks that have pure stain_a vs pure stain_b, vs a mixture of stain_a and stain_b. It also generates graphs representing each individual picture. For demonstration purposes, I have also analyzed a more "confined" picture in which the two cell types (blue vs brown) are less intermixed: ![confined](https://github.com/erilu/IHC-image-pixel-analyzer/blob/master/readme_pictures/confined_binary.jpg)

Here is the output for the confined vs disperse (intermixed) pictures: ![confined_output](https://github.com/erilu/IHC-image-pixel-analyzer/blob/master/R_output/confined_25x25_Total.png)
![disperse_output](https://github.com/erilu/IHC-image-pixel-analyzer/blob/master/R_output/disperse_25x25_Total.png)

We can see that the output looks different for each picture and that the intermixing statistic is different as well.
