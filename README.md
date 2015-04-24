# tidydata
Course project for Getting and Cleaning Data course

## Introduction

This repository contains the file run_analysis.R which performs the required activities in order to obtain a tidy dataset using as input the data on Human Activity Recognition Using Smartphones from:

Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.
activityrecognition@smartlab.ws
www.smartlab.ws

For more information on the dataset, please go to [this site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)

## Code Description

The code contains the following steps:

1. Read all necessary files into R. These include both Test and Train feature sets, as well as labels (included in the test and train sub-folders), both Test and Train subject files (identifies the subject who performed the given activity, there are 30 subjects in total, and 5 activities), and the features.txt which includes a list of all 561 features. This list is used to provide the intermediate data frame with the appropriate column names.
2. Use base functions to find only those columns that represent either mean() or std() for each measurement. Other mean related columns are excluded (meanFreq(), gravityMean, and the angle variables).
3. Extract only such features from the feature (train and test) data frames.
4. Column bind all objects: subjects, labels (activities) and features for both train and test sets, and merge both sets to end up with a large data frame that contains all observations and the features of interest.
5. Check for any missing values.
6. Use descriptive activity names to name the activities in the data set
7. Create a second, independent tidy data set with the average of each variable for each activity and each subject. In this section, the code uses to alternative ways of getting the same result: one with the `reshape` package, and another one with the `dplyr` package.
8. Finally, rename columns to make their labels more descriptive.

## Variable Description & Details

CodeBook.md contains a description of the features used in this project, as well as a detailed explanation of any transformation that was performed on the original data.


