# April 24, 2015
# Course Project, Getting and Cleaning Data (Data Science Specialization)
# By: Carlos Patino
#
#
# This code performs the following activities on the Human Activity Recognition
# Using Smartphones Dataset:
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each
# measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. Creates a second, independent tidy data set with the average of each variable
# for each activity and each subject.

# Note: Data must be in the working directory, in folders "train" and "test":
setwd("~/Documents/Data Science Specialization/Getting and Cleaning Data/data/UCI HAR Dataset")

# Variable names (features):
features <- read.table("features.txt", header=FALSE, sep="",
                       colClasses=c("integer","character"))
X.names <- features[,2]

# Test set and labels:
fileName <- "./test/X_test.txt"
X.test <- read.table(fileName,header=FALSE,sep="")
fileName <- "./test/y_test.txt"
y.test <- read.table(fileName,header=FALSE,sep="",col.names=c("Activity"))
fileName <- "./test/subject_test.txt"
sub.test <- read.table(fileName,header=FALSE,sep="",col.names=c("Subject"))

# Train set and labels:
fileName <- "./train/X_train.txt"
X.train <- read.table(fileName,header=FALSE,sep="")
fileName <- "./train/y_train.txt"
y.train <- read.table(fileName,header=FALSE,sep="",col.names=c("Activity"))
fileName <- "./train/subject_train.txt"
sub.train <- read.table(fileName,header=FALSE,sep="",col.names=c("Subject"))

# Rename columns for both X tables:
colnames(X.test) <- X.names; colnames(X.train) <- X.names

# Pre-processing features table in order to grab only those with mean():
mean.indices <- grep("mean()", features[,2], fixed=TRUE)
std.indices <- grep("std()", features[,2], fixed=TRUE)
indices <- c(mean.indices,std.indices)
indices <- sort(indices)

# Extract only measurements on the mean and standard deviation for each
# measurement, using the previously generated indices:
X.test <- X.test[,indices]
X.train <- X.train[,indices]

# cbind subjects, labels, and extracted features for each individual set (train and test):
test <- cbind(sub.test, y.test, X.test)
train <- cbind(sub.train, y.train, X.train)

# Merge test & train sets (use rbind):
DF <- rbind(train,test)

# Check for missing values:
all(colSums(is.na(DF))==0)

# Use descriptive activity names:
act.labels <- read.table("activity_labels.txt", header=FALSE, sep="",
                         colClasses=c("integer","character"),
                         col.names=c("Activity","Activity.Desc"))
DF <- merge(DF,act.labels,"Activity")
DF <- DF[,c(-1)]
DF$Activity.Desc <- as.factor(DF$Activity.Desc)

# Summarize and create new table as output (using reshape):
library(reshape2)
melt.DF <- melt(DF, id=c("Subject", "Activity.Desc"), measure.vars=c(2:67))
final.DF <- dcast(melt.DF, Subject + Activity.Desc ~ variable, mean)

# Alternative, using dplyr´s summarise_each:
library(dplyr)
grp.DF <- group_by(DF, Subject, Activity.Desc)
final.DF2 <- summarise_each(grp.DF, funs(mean))

# Final step: rename final columns to make them more descriptive:
final.cols <- colnames(final.DF2)

for (i in 1:length(final.cols)) {
        if (length(grep("-mean()", final.cols[i], fixed=TRUE))!=0) {
                final.cols[i] <- paste(sub("-mean()", "", final.cols[i],
                                           fixed=TRUE), "-Mean", sep="")
        }
}

for (i in 1:length(final.cols)) {
        if (length(grep("-std()", final.cols[i], fixed=TRUE))!=0) {
                final.cols[i] <- paste(sub("-std()", "", final.cols[i],
                                           fixed=TRUE), "-STD", sep="")
        }
}

colnames(final.DF2) <- final.cols

####### Helper code for documentation:
library(pander)
test <- data.frame(min=sapply(final.DF2[,c(3:68)],min),max=sapply(final.DF2[,c(3:68)],max))
pandoc.table(test,style="markdow") # Generates a nice table for CodeBook.md