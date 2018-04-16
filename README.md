# IHC pixel analyzer - Analyzing "confinement" of cells

These scripts will allow you to quantify how tightly confined a cell type is, based on an dual-color immunohistochemistry image. It assesses the level of intermixing of the two colors in the image. I use **matlab** to split an image into blocks and export a statistic for each block. Then, I use **R** to process the exported data, and provide an overall statistic for the original image.

## General Workflow:
1. Use ImageJ to convert a Blue/Brown IHC stain to binary, single-stain pictures, using the IHC toolbox.

2. Run the matlab script, indicating the name of the folder that contains the pictures. The raw table output is generated in the same folder.

5. Run the R script to analyze the matlab output.

6. These output files contain a .csv file that has the fraction of blocks
 within the 1-99 range, as well as single .png files showing graphs of each
 individual picture. Put these values into Prism for the final quantitative graph.
