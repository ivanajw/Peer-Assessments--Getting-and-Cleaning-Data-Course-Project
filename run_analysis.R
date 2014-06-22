# Original Data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# Original Data Description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Package Check and Install
pkg <- "reshape2"
if (!require(pkg, character.only = TRUE)) {
  install.packages(pkg)
  if (!require(pkg, character.only = TRUE)) 
    stop(paste("Load failure: ", pkg))
}

setwd("C:/Users/Ivana/Desktop/Coursera_getting and cleaning data")

# Data Directories

dataBaseDirectory <- "./UCI HAR Dataset/"
dataTestDirectory <- "./UCI HAR Dataset/test/"
dataTrainDirectory <- "UCI HAR Dataset/train/"

activities <- read.table(paste0(dataBaseDirectory, "activity_labels.txt"), header=FALSE, 
                         stringsAsFactors=FALSE)
features <- read.table(paste0(dataBaseDirectory, "features.txt"), header=FALSE, 
                       stringsAsFactors=FALSE)
# Import and prepare testing data
subject_test <- read.table(paste0(dataTestDirectory, "subject_test.txt"), header=FALSE)
x_test <- read.table(paste0(dataTestDirectory, "X_test.txt"), header=FALSE)
y_test <- read.table(paste0(dataTestDirectory, "y_test.txt"), header=FALSE)
tmp <- data.frame(Activity = factor(y_test$V1, labels = activities$V2))
testData <- cbind(tmp, subject_test, x_test)

# Import and prepare training data
subject_train <- read.table(paste0(dataTrainDirectory, "subject_train.txt"), header=FALSE)
x_train <- read.table(paste0(dataTrainDirectory, "X_train.txt"), header=FALSE)
y_train <- read.table(paste0(dataTrainDirectory, "y_train.txt"), header=FALSE)
tmp <- data.frame(Activity = factor(y_train$V1, labels = activities$V2))
trainData <- cbind(tmp, subject_train, x_train)

# Preparing Tidy Data from mean() and std() data.
tmpTidyData <- rbind(testData, trainData)
names(tmpTidyData) <- c("Activity", "Subject", features[,2])
select <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
tidyData <- tmpTidyData[c("Activity", "Subject", select)]

# Write Tidy Data to Disk in tidyData.txt 
write.table(tidyData, file="./tidyData.txt", row.names=FALSE)

# Tidy Data Average/Activity. Melt and Cast
tidyDataMelt <- melt(tidyData, id=c("Activity", "Subject"), measure.vars=select)
tidyDataMean <- dcast(tidyDataMelt, Activity + Subject ~ variable, mean)

# Write Tidy Average Data to tidyAverageData.txt
write.table(tidyDataMean, file="./tidyAverageData.txt", row.names=FALSE)


