run_analysis <- function() {

## Function to combine and tidy UCI HAR dataset data
## No arguments required, but the dataset must be unzipped into 
## this folder: GetDataProject/UCI HAR Dataset/
## Dataset can be obtained from this URL:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
## outputs data to this file: GetDataProject/ProjectDataSet.txt
    
    
## First load the data (both test and training) and combine into one dataset
X_test <- read.table("GetDataProject/UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("GetDataProject/UCI HAR Dataset/train/X_train.txt")
X_tot <- rbind(X_test,X_train)

## Next load column headers and apply them to the data set
hd <- read.table("GetDataProject/UCI HAR Dataset/features.txt")
names(X_tot) <- hd[,2]

## Load the row labels and combine in the same order as the data
y_train <- read.table("GetDataProject/UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("GetDataProject/UCI HAR Dataset/test/y_test.txt")
y_tot <- rbind(y_test,y_train)
names(y_tot) <- c("labels")

## get the subject data for each row and combine test and training
sub_train <- read.table("GetDataProject/UCI HAR Dataset/train/subject_train.txt")
sub_test <- read.table("GetDataProject/UCI HAR Dataset/test/subject_test.txt")
sub_tot <- rbind(sub_test,sub_train)
names(sub_tot) <- c("subject")

## combine the subjects, row labels and data into one data table
X_tot <- cbind(sub_tot,y_tot,X_tot)

## filter data set so it only includes subject, label, Mean and STD columns
X_tot <- X_tot[,grepl("^subject$|^labels$|mean()|std()",names(X_tot))]

## Replace the coded row labels with readable text
X_tot$labels[X_tot$labels==1] <- "WALKING"
X_tot$labels[X_tot$labels==2] <- "WALKING_UPSTAIRS"
X_tot$labels[X_tot$labels==3] <- "WALKING_DOWNSTAIRS"
X_tot$labels[X_tot$labels==4] <- "SITTING"
X_tot$labels[X_tot$labels==5] <- "STANDING"
X_tot$labels[X_tot$labels==6] <- "LAYING"

## Aggregate the rows by subject and label
X_summary <- aggregate(X_tot[,3:81],X_tot[,1:2],FUN=mean)

## write data to a file
write.table(X_summary, file="GetDataProject/ProjectDataSet.txt", row.names=FALSE)

}
