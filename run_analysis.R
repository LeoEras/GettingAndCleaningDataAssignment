if(!file.exists("data")){
  dir.create("data")
}

#URL and file download:
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "data/dataset.zip")

# Unzip dataset to /data directory
unzip(zipfile="data/dataset.zip", exdir="data")


#Step 1.Merges the training and the test sets to create one data set.

#Reading trainings data:
x_train <- read.table("data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("data/UCI HAR Dataset/train/subject_train.txt")

#Reading testing data:
x_test <- read.table("data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt")

#Reading features:
features <- read.table('data/UCI HAR Dataset/features.txt')

#Reading activity:
activityLabels = read.table('data/UCI HAR Dataset/activity_labels.txt')

# Assigning column names:
colnames(x_train) <- features[,2]
colnames(y_train) <-"activity_id"
colnames(subject_train) <- "subject_id"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activity_id"
colnames(subject_test) <- "subject_id"
colnames(activityLabels) <- c('activity_id','activityType')

#Merging all data in one set:
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)


#Step 2.-Extracts only the measurements on the mean and standard deviation for each measurement.

#Reading column names:
colNames <- colnames(setAllInOne)

#Create vector for defining ID, mean and standard deviation:
mean_and_std <- (grepl("activity_id" , colNames) | 
                   grepl("subject_id" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)


setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]


#Step 3. Uses descriptive activity names to name the activities in the data set

setWithActivityNames <- merge(setForMeanAndStd, activityLabels, by='activity_id', all.x=TRUE)


#Step 4. Appropriately labels the data set with descriptive variable names.
#Already done

#Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#5.1 Making a second tidy data set

secTidySet <- aggregate(. ~subject_id + activity_id, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subject_id, secTidySet$activity_id),]
write.table(secTidySet, "tidySet.txt", row.name=FALSE)
