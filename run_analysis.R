# R scriptnames run_analysis.R will generate files after tidying the data in accordance
# with the requirements under Data Science Course#3 project specifications

# Required libraries
library(dplyr)          # needed for group_by funtion
library(tidyr)          # needed for gather and spread functions
library(stringr)        # needed for str_replace_all function


sourcefile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


## Download source file to current working directory and unzip the file if it does not exist locally 

        if (!file.exists("UCI HAR Dataset")) {
                message("Downloading source files...")
                download.file(sourcefile,"dataset.zip", method="libcurl")
                
                message("Unzipping the files...")
                unzip("dataset.zip")
        }

## Begin data processing

        setwd("./UCI HAR Dataset")      ## setting the current working directory to UCI HAR Dataset.
        message("Preparing to process data...")
        
        allFeatures <- as.character(read.table("features.txt")[,2]) # Extracting & storing 2nd column as character from file

        actLabels <- read.table("activity_labels.txt")     # Extracting activity labels from file
        actLabels[,2] <- as.character(actLabels[,2])       # Converting 2nd column into characters


## 1. Merges the training and the test sets to create one data set.
        
        # Extract variable data from source files and append test observations 
        # to training observations to make one set of data.

        message("Step 1 : Extracting and merging training and test data...")
        
        allVar <- rbind(read.table("train/X_train.txt"), read.table("test/X_test.txt"))         

        # Extract subject and activity details of training and test observations, join respective columns  
        # and the append test data to training data to make one set of data.

        allSubjects <- rbind(
                cbind(read.table("train/subject_train.txt"), read.table("train/Y_train.txt")),
                cbind(read.table("test/subject_test.txt"), read.table("test/Y_test.txt"))
                )

## 2. Extract the measurements on the mean and standard deviation for each measurement.
        
        message("Step 2 : Extracting measurements on the mean and standard deviation...")
        
        # Note that the sequence of columns in X_train.txt & x_test.txt correspond 
        #   to sequence of names in rows in features.txt. (eg. value of 10th row in features.txt 
        #   is the name of 10th column in x_train.txt and x_test.txt) 
        
        selectedColNumbers <- grep("(mean|std)\\(\\)",allFeatures)
        selectedVar <- allVar[,selectedColNumbers]

        selectedVarLabels <- allFeatures[selectedColNumbers]
        selectedVarLabels <- str_replace_all(selectedVarLabels,"[(),-]","")     # Removing special characters from contents

        # Join the columns holding subject and activity data with their observation values.
        # Note that every row in subject_train.txt, x_train.txt and y_train.txt represents data
        # pertaining to the same obervation.
        
        selectData <- cbind(allSubjects,selectedVar)

        rm(allVar, selectedVar, allSubjects)   # clearing objects that are no longer wanted
        
## 3. Uses descriptive activity names to name the activities in the data set

        message("Step 3 : Labelling activity names...")
        
        selectData[,2] <- factor(selectData[,2], levels = actLabels[,1], labels = actLabels[,2])

## 4. Appropriately labels the data set with descriptive variable names.

        message("Step 4 : Labelling columns with descriptive names...")
        
        colnames(selectData) <- c("Subject","Activity", selectedVarLabels)
        
        rm(allFeatures,selectedColNumbers,selectedVarLabels)        

## 5. From the data set in step 4, creates a second, independent tidy data set 
#       with the average of each variable for each activity and each subject.

        message("Step 5 : Generating averages for each activity and each subject")
        
        averageValues<- selectData %>% 
                        gather(Features,value,-Subject,-Activity) %>%   # gather() works similiar to melt()
                        group_by(Subject,Activity,Features) %>%         # group_by(), summarize()  
                        summarize(MeanValue = mean(value)) %>%          #   & spread() work similar to dcast()
                        spread(Features,MeanValue)

        averageValues <- averageValues[colnames(selectData)] ## ensuring uniform column order
        totalcols <- length(colnames(averageValues))
        colnames(averageValues)[3:totalcols] <- paste0("Avg",colnames(averageValues)[3:totalcols])      

        setwd("../")        
        
        message("Finally writing tidy data to files...")
        
        write.table(averageValues,file= "tidy_mean_std_averages.txt", quote = FALSE, row.names = FALSE )        


        rm(actLabels,averageValues,selectData, sourcefile,totalcols)      
        message("It is done.")
        