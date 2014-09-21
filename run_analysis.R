#Runs analysis on the raw data set of Human Activity Recognition.


#Read Train and Test data set
trainValues = read.table("UCI HAR Dataset\\train\\X_train.txt")
trainLabels = read.table("UCI HAR Dataset\\train\\Y_train.txt")
trainSubjects = read.table("UCI HAR Dataset\\train\\subject_train.txt")
testValues = read.table("UCI HAR Dataset\\test\\X_test.txt")
testLabels = read.table("UCI HAR Dataset\\test\\Y_test.txt")
testSubjects = read.table("UCI HAR Dataset\\test\\subject_test.txt")

featureLabels = read.table("UCI HAR Dataset\\features.txt")
activityLabels = read.table("CI HAR Dataset\\activity_labels.txt")

#Add Labels to the Columns extracted
names(trainValues) <- featureLabels[,2]
names(trainLabels) <- "Activity"
names(trainSubjects) <- "subjects"

names(testValues) <- featureLabels[,2]
names(testLabels) <- "Activity"
names(testSubjects) <- "subjects"

#Extract the Mean and Std Deviation columns 
onlyStdMeanTrainValues = trainValues[,grepl("mean()", names(trainValues)) | grepl("std()", names(trainValues))]
onlyStdMeanTestValues = testValues[,grepl("mean()", names(testValues)) | grepl("std()", names(testValues))]

#Merge the Rows from the two data set
mergedTrain = cbind(trainSubjects, trainLabels, onlyStdMeanTrainValues)
mergedTest = cbind(testSubjects, testLabels, onlyStdMeanTestValues)

mergedData = rbind(mergedTrain,mergedTest)

#Use Descriptive Activity Names
mergedData$Activity = factor(mergedData$Activity, levels = activityLabels[,1], labels=activityLabels[,2])

#Create new tidy data set with the average of each activity for each Subject
averagedData <- aggregate(mergedData,by=list(mergedData$subjects,mergedData$Activity), FUN=mean)
tidyData <- averagedData[,c(1,2,5:83)]
names(tidyData) <- names(mergedData)

write.table(tidyData, file = "TidyData.txt", row.names=FALSE)