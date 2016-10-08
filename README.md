# Coursera-Course3-Project---Getting-and-Cleaning-Data
October 2016
------------------------------------------------------
The objective of this project is to use R programming skills to transform messy source data and generate a custom dataset that is tidy and in conformity to specifications provided by the course coordinator. 

Three files are uploaded to GitHub as part of the project.
---------------------------
1. run_analysis.R - file containing R program that generates required tidy data
2. Codebook for Tidying up of UCI HAR data subset.pdf - provides more information on the data
3. tidy_mean_std_averages.txt (tidy data having averages of mean and standard deviation measures per subject per activity)

The R program "run_analysis.R" is written to achieve the following:
----------------------------
1. Download the source file UCI HAR dataset.zip to current working directory and extract datafiles.
2. Combine source data from multiple files into one dataset.
3. Subset the data to retain only mean and standard deviation measures,provide labels to columns and convert activity codes to factors.
4. Generate averages of variables for each activity and each subject and store as a tidy data in txt file (tidy_mean_std_averages.txt)

Reading the txt files:
------------------
Note that "tidy_mean_std_averages.txt" was generated using write.table() with row.names = FALSE. It has a header row.

Required libraries
------------------
dplyr, tidyr, stringr
