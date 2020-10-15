setwd("~/Desktop/Coursera_R_Programming/course3")

# Download Datasets
library(data.table)

fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("./UCI HAR Dataset.zip")){
    download.file(fileurl, "./UCI HAR Dataset.zip", mode = "wb")
    unzip("UCI HAR Dataset.zip", exdir = getwd())
}

# Prepare Datasets
act.label <- read.table("./UCI HAR Dataset/activity_labels.txt", header = F, sep = "")
act.label <- as.character(act.label[,2])

features <- read.table("./UCI HAR Dataset/features.txt", header = F, sep = "")
features <- as.character(features[,2])

data.test <- read.table("./UCI HAR Dataset/test/X_test.txt")
act.test <- read.table("./UCI HAR Dataset/test/y_test.txt")
sub.test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

data.test <- cbind(act.test, sub.test, data.test)
colnames(data.test) <- c(c("act", "sub"), features)

data.train <- read.table("./UCI HAR Dataset/train/X_train.txt")
act.train <- read.table("./UCI HAR Dataset/train/y_train.txt")
sub.train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

data.train <- cbind(act.train, sub.train, data.train)
colnames(data.train) <- c(c("act", "sub"), features)

# Merge test and train into one dataset
data <- rbind(data.test, data.train)

# Extract only mean and std measurements
mean.std <- grep("mean|std", features)
data.mean.std <- data[, c(1:2, mean.std + 2)]

# Apply activity labels to dataset
data.mean.std$act <- act.label[data.mean.std$act]

# Label dataset with descriptive variable names
gsub("\\()", "",colnames(data.mean.std))

# Creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject
data.tidy <- aggregate(data.mean.std[,3:81], by=list(act = data.mean.std$act, 
                                                     sub = data.mean.std$sub), 
                       FUN = mean, na.rm=T)
write.table(x=data.tidy, file = "./UCI HAR Dataset/tidydataset.txt", row.names = F)




