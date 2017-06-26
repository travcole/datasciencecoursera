## Getting and Cleaning Data Codebook

### Source Data
Description of the data used in this project, as well as in depth information of the data generation process, can be found at the UCI Machine Learning Repo, here (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
The source data can be found [here] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Step 1. Merge training and test sets to create one data set
First, set your working directory for the files, then read the tables into R.  Below are the files that are used.
- features.txt
- activity_labels.txt
- subject_train.txt
- x_train.txt
- y_train.txt
- subject_test.txt
- x_test.txt
- y_test.txt

Then, assign column names and merge into a single data set.

### Step 2. Extract only the measurements on the mean and standard deviation for each measurement. 
One manner to do this is to create a logical vector that has TRUE values for mean, ID, and standard deviation columns.  The others are set to FALSE.
Use this to subset the necessary columns.

### Step 3. Use descriptive activity names to name the activities in the data set.
Merge with the updated activity_labels.txt file.

### Step 4. Appropriately label the data set with descriptive activity names.
The gsub function can be used to accomplish this task.  It will search patterns and replace as needed.

### Step 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

