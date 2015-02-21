# Course Project -- Cleaning Data at Coursera February 2015
#  (c) William W. Kennerly

# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit:
#1) a tidy data set as described below, 
#2) a link to a Github repository with your script for performing the analysis, and
#3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
#4) You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 
# 
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:  
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# Here are the data for the project:
#   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


setwd("~/Dropbox/coursera/DataScience/CleaningData/UCI HAR Dataset")
variablenames <- read.table("./features.txt")
traindf <- read.table("./train/X_train.txt", col.names=variablenames[,2])
trainsubject <- read.table("./train/subject_train.txt")
trainactivity <- read.table("./train/y_train.txt")
testdf <- read.table("./test/X_test.txt", col.names=variablenames[,2])
testsubject <- read.table("./test/subject_test.txt")
testactivity <- read.table("./test/y_test.txt")
activitylabels <- read.table("./activity_labels.txt")

# bind the subject code and the activity code to each dataframe
testdf<-cbind(testsubject, testactivity, testdf)
traindf<-cbind(trainsubject, trainactivity, traindf)

#bind together training set and test set into one frame, name and make the subject and activity variables as factors
testdf<-rbind(testdf, traindf)
colnames(testdf)[1:2] <- c("subject", "activity")
testdf$activity <- as.factor(testdf$activity)
testdf$subject <- as.factor(testdf$subject)
levels(testdf$activity) <- activitylabels[,2]
#now remove from memory some structures that won't be used anymore
rm(traindf, testactivity, trainactivity, testsubject, trainsubject, variablenames, activitylabels)

#keep only the "subject", "activity", and via the grep command, the various "mean" and "std" columns
subsetdf <- testdf[, c(1, 2, grep("mean|std", colnames(testdf)))]

#reshape the dataset for ease-of-summary, dcast it to get the mean of each column in the requested fashion, and write out the table to file
library(reshape2)
msubdf <- melt(subsetdf, id.vars=c("subject", "activity"))
summary <- dcast(msubdf, subject+activity~variable, mean)
write.table( summary , file="summary.txt", row.name=FALSE)
