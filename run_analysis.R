# Load the necessary packages
library(data.table)
library(reshape2)
# Download the dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/dataset.zip")
# Unzip the dataset
unzip(zipfile="./data/dataset.zip",exdir="./data")
# Read the training data files  
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
# Read the test data files  
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
# Read the feature file
features <- read.table("./data/UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])
# Read the activity label file
activity_label <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
activity_label[,2] <- as.character(activity_label[,2])
# Label the training data tables with descriptive variable names
colnames(x_train) <- features [,2]
colnames(y_train) <- "ActivityCode"
colnames(subject_train) <- "VolunteerID"
# Label the test data tables with descriptive variable names
colnames(x_test) <- features [,2]
colnames(y_test) <- "ActivityCode"
colnames(subject_test) <- "VolunteerID"
# Label the activity label table with descriptive variable names
colnames(activity_label) <- c("ActivityCode", "Activity")
# Merge the training and test data sets into one data set
merged_train <- cbind(y_train, subject_train, x_train)
merged_test <- cbind(y_test, subject_test, x_test)
merged_data <- rbind(merged_train, merged_test)
# Extract only the measurements on the mean and standard deviation for each measurement
subset_vector <- grep(paste(subset_vector, collapse='|'), colnames(merged_data), ignore.case=TRUE)
subset_data <- merged_data[, subset_vector]
# Merge the extracted data with the activity label table to use descriptive activity names
complete_data <- merge(subset_data, activity_label, by="ActivityCode", all.x = TRUE)
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject
melted_data <- melt(complete_data, id=c("ActivityCode","Activity","VolunteerID"))
tidy_data <- dcast(melted_data, ActivityCode + Activity + VolunteerID ~variable, mean)
# Create a text file with the tidy data
write.table(tidy_data,"./data/tidy_data", row.name=FALSE)
