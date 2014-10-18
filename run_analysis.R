#-------------------------------------------------------------------
#  RUN_ANALYSIS.R does the following
#    1. Merges the training and the test sets to create one data set
#    2. Extracts only the measurements on the mean and standard deviation
#         for each measurement
#    3. Uses descriptive activity names to name the activities in
#         the data set
#    4. Appropriately labels the data set with descriptive activity names
#    5. Creates a second, independent tidy data set with the average
#       of each variable for each activity and each subject
#
#   This codebook is created with great references from this github link.
#      https://github.com/benjamin-chan/GettingAndCleaningData
#-------------------------------------------------------------------

library("data.table")
library("reshape2")

# Utils function
ReadFile <- function(f){
  tb <- read.table(f)
  dt <- data.table(tb)
  return(dt)
}

# Open the downloaded data
path <- file.path("UCI-HAR-Dataset")

# # Read the subject files
subjTrain <- ReadFile(file.path(path, "train", "subject_train.txt"))
subjTest  <- ReadFile(file.path(path, "test",  "subject_test.txt"))

# Read the activity files
actTrain <- ReadFile(file.path(path, "train", "y_train.txt"))
actTest  <- ReadFile(file.path(path, "test", "y_test.txt"))

xTrain   <- ReadFile(file.path(path, "train", "X_train.txt"))
xTest    <- ReadFile(file.path(path, "test", "X_test.txt")) 

# 1. Merge the training and the test sets

## Merge rows
subjMerge <- rbind(subjTrain, subjTest)
setnames(subjMerge, "V1", "Subject")
actMerge  <- rbind(actTrain, actTest)
setnames(actMerge, "V1", "ActivityIndex")
data      <- rbind(xTrain, xTest)

# Merge the columns
subjMerge <- cbind(subjMerge, actMerge)
data      <- cbind(subjMerge, data)

setkey(data, Subject, ActivityIndex)

# 2. Extracts only the measurements on the mean and standard deviation
#   for each measurement
features <- ReadFile(file.path(path, "features.txt"))
setnames(features, names(features), c("FeatureIndex", "FeatureName"))
features <- features[grepl("mean\\(\\)|std\\(\\)", FeatureName)]

#  Add feature code
features$FeatureCode <- features[, paste0("V", FeatureIndex)]

# Using feature code to extract
select <- c(key(data), features$FeatureCode)
data   <- data[, select, with=FALSE]

# 3. Uses descriptive activity names to name the activities in
#   the data set (in activity_labels.txt)
actName <- ReadFile(file.path(path, "activity_labels.txt"))
setnames(actName, names(actName), c("ActivityIndex", "ActivityName"))

# 4. Appropriately labels the data set with descriptive activity names

#   Merge activity labels
data <- merge(data, actName, by="ActivityIndex", all.x = TRUE)

#  Set key again
setkey(data, Subject, ActivityIndex, ActivityName)

#  Melt data
data <- data.table(melt(data, key(data), variable.name="FeatureCode"))

# Merge with activity name
data <- merge(data, features[, list(FeatureIndex, FeatureCode, FeatureName)], by="FeatureCode", all.x=TRUE)

# Create a factor class
data$ActivityName <- factor(data$ActivityName)
data$FeatureName  <- factor(data$FeatureName)

# Helper function
GrepText <- function (regex) {
  grepl(regex, data$FeatureName)
}

## Features with 1 category
data$Jerk <- factor(GrepText("Jerk"), labels=c(NA, "Jerk"))
data$Magnitude <- factor(GrepText("Mag"), labels=c(NA, "Magnitude"))

## Features with 2 categories
n <- 2
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(GrepText("^t"), GrepText("^f")), ncol=nrow(y))
data$Domain <- factor(x %*% y, labels=c("Time", "Freq"))
x <- matrix(c(GrepText("Acc"), GrepText("Gyro")), ncol=nrow(y))
data$Instrument <- factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))
x <- matrix(c(GrepText("BodyAcc"), GrepText("GravityAcc")), ncol=nrow(y))
data$Acceleration <- factor(x %*% y, labels=c(NA, "Body", "Gravity"))
x <- matrix(c(GrepText("mean()"), GrepText("std()")), ncol=nrow(y))
data$Variable <- factor(x %*% y, labels=c("Mean", "SD"))

## Features with 3 categories
n <- 3
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(GrepText("-X"), GrepText("-Y"), GrepText("-Z")), ncol=nrow(y))
data$Axis <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))

# 5. Creates a second, independent tidy data set with the average
#   of each variable for each activity and each subject
setkey(data, Subject, ActivityName, Domain, Acceleration, Instrument, Jerk, Magnitude, Variable)
tidyData <- data[, list(Count = .N, Avg = mean(value)), by=key(data)]
# write.table(tidyData, file = "tidy-UCI-HAR-Dataset.txt", row.names = FALSE)
