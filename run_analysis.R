##### Coursera Getting and Cleaning Data Project #####


#Set directory

#create new file for data in area if it doesn't yet exist
if (!file.exists("data")) {
  dir.create("data")
}

#Download data, then unzip
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/FullUCI.zip")
unzip(zipfile = "./data/FullUCI.zip", exdir = "./data")  # will create new folder called UCI HAR Dataset

# Read data in from files, including the needed test and train data
features <- read.table("./data/UCI HAR Dataset/features.txt", header = FALSE)
activity_type <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE)
subject_Train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
x_Train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_Train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_Test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
x_Test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_Test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)

# Assign column names to data, this step also gives descriptive activity names
colnames(activity_type) <- c("activityID","activityType")
colnames(subject_Train) <- "Subject_ID"
colnames(subject_Test) <- "Subject_ID"
colnames(x_Train) <- features[,2]
colnames(x_Test) <- features[,2]
colnames(y_Train) <- "activityID"
colnames(y_Test) <- "activityID"

# Mearge training data together, then merge test data together.
trainingSet <- cbind(y_Train, x_Train, subject_Train)
testSet <- cbind(y_Test, x_Test, subject_Test)

#Bind both sets together for final dataset
final_Data <- rbind(trainingSet, testSet)

# Using logical vector to extract only measurements on mean and std dev.
columnNames <- colnames(final_Data)
logicalVector = (grepl("activity..",columnNames) | grepl("subject..",columnNames) | grepl("-mean..",columnNames) & !grepl("-meanFreq..",columnNames) & !grepl("mean..-",columnNames) | grepl("-std..",columnNames) & !grepl("-std()..-",columnNames))
final_Data <- final_Data[logicalVector == TRUE]

#Merge with activity_type
final_Data <- merge(final_Data,activity_type, by = "activityID", all.x = TRUE)
columnNames <- colnames(final_Data)

#Now, make variables easily readable and descriptive, ^(t) for time, ^(f) for freq, etc.

for (i in 1:length(columnNames)) {
    columnNames[i] = gsub("\\()", "",columnNames[i])
    columnNames[i] = gsub("-std$", "Std_Dev", columnNames[i])
    columnNames[i] = gsub("-mean", "Mean", columnNames[i])
    columnNames[i] = gsub("^(t)","time", columnNames[i])
    columnNames[i] = gsub("^(f)","freq",columnNames[i])
    columnNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",columnNames[i])
    columnNames[i] = gsub("[Gg]yro","Gyro",columnNames[i])
    columnNames[i] = gsub("AccMag","AccMagnitude",columnNames[i])
    columnNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",columnNames[i])
    columnNames[i] = gsub("JerkMag","JerkMagnitude",columnNames[i])
    columnNames[i] = gsub("GyroMag","GyroMagnitude",columnNames[i])
}

colnames(final_Data) = columnNames

#Create a tidy data set, with average of each variable per activity and subject
library(dplyr)
tidy_Data <- final_Data %>%
  group_by(activityID) %>%
  summarise_each(funs(mean))

tidy_Data <- merge(tidy_Data,activity_type,by="activityID",all.x=TRUE)

write.table(tidy_Data, './tidy_Data.txt',row.names=FALSE,sep='\t')

