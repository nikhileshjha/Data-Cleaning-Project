rm(list=ls())
library(data.table)
library(base)
library(utils)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
wd <- getwd()
download.file(url, file.path(wd, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")
activities <- fread(file.path(wd, "UCI HAR Dataset/activity_labels.txt")
                        , col.names = c("Category", "Activity"))
features <- fread(file.path(wd, "UCI HAR Dataset/features.txt"), col.names = c("Number","Name"))
features_sub <- grepl('-(mean|std)[(]', features$Name)


training <- fread(file.path(wd,"UCI HAR Dataset/train/X_train.txt"))[, features_sub, with = FALSE]
trnActivities <- fread(file.path(wd, "UCI HAR Dataset/train/Y_train.txt")
                         , col.names = c("Activity"))
trnSubjects <- fread(file.path(wd, "UCI HAR Dataset/train/subject_train.txt")
                       , col.names = c("User"))
training <- cbind(trnSubjects,trnActivities,training)
testActivities <- fread(file.path(wd, "UCI HAR Dataset/test/Y_test.txt")
                        , col.names = c("Activity"))
testSubjects <- fread(file.path(wd, "UCI HAR Dataset/test/subject_test.txt")
                      , col.names = c("User"))
testing <- fread(file.path(wd,"UCI HAR Dataset/test/X_test.txt"))[, features_sub, with = FALSE]
testing <- cbind(testSubjects,testActivities,testing)

# Combining the two datasets
all <- rbind(training,testing)
write.table(all, './tidyData.txt',row.names=FALSE,sep='\t')
