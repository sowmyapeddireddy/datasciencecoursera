library(dplyr)
filename <- "dataset"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

XTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
YTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
SubjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

XTest <- read.table("UCI HAR Dataset/test/X_test.txt")
YTest <- read.table("UCI HAR Dataset/test/y_test.txt")
SubjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Step 1
# Mergin all datasets together.
X <- rbind(XTrain, XTest)
Y <- rbind(YTrain, YTest)
Subject <- rbind(SubjectTrain, SubjectTest)

features <- read.table("UCI HAR Dataset/features.txt")

# There are 561 features, but we need only mean and std features
meanAndStdFeatures <- grep("-(mean|std)\\(\\)", features[, 2])

# Step 2
X <- X %>% select(meanAndStdFeatures)
names(X) <- features[meanAndStdFeatures, 2]

# Step 3
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
Y[,1] = activities[Y[,1], 2]

# Step 4
names(Y) = c("activity")
names(Subject) = c("subject")

# Binding everything together
finalData <- cbind(Subject, Y, X)

# Step 5
groupedBySubjectAndAcitivity <- finalData %>% group_by(subject, activity) %>% summarise_each(funs(mean))

write.table(groupedBySubjectAndAcitivity, "grouped_data.txt", row.name=FALSE)

