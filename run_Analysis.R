## merges datasets pertaining to wearable device readings, removes all columns not related to means or standard deviations
## and then creates a summarised data set with the average of each of a number of types of feature readings stored for each subject and activity type
library(plyr)
library(dplyr)

## read the various data files
## the training data set of feature observations
x_train <- read.table("X_train.txt")

## the link to the activity completed on a given observation (row)
y_train <- read.table("Y_train.txt") 

## the descriptive labels for each of the feature observation types
features <- read.table("features.txt")

## the descriptive labels for each of the 6 types of activities within the study
activityLabels <- read.table("activity_labels.txt")

## the link to the subject who completed a given observation (row)
subjectTrain <- read.table("subject_train.txt") 

## and repeat the same for the test dataset counterparts
x_test <- read.table("X_test.txt")
y_test <- read.table("Y_test.txt")
subjectTest <- read.table("subject_test.txt") ## the link to the subject who completed a given observation (row)

##"UNION" row bind test and training sets together as they are simply more observations (i.e. the link between the columns is not important and in fact doesn't exist in the real world)

combinedData <- rbind(x_train, x_test)

## get the list of features to give a better set of column names
featureNames <- features$V2
colnames(combinedData) <- featureNames

## now do the same with all of the related data - i.e. activities and subjects. Doing it now to ensure that the order is preserved as we'll need that to properly relate the 
## feature observations to the correct activity being performed and the subject performing them

combinedSubject <- rbind(subjectTrain, subjectTest)
combinedActivity <- rbind(y_train, y_test)

## We are only concerned with columns that measure mean and standard deviation
## from the readme file supplied with the [original] data we can see that these column names will contain mean(), std() or Mean()


## Get the feature numbers which contain a mean or a stadard deviation
reqdCols <- c(grep("mean()" ,features$V2), grep("mean()" ,features$V2), grep ("Mean", features$V2))

## reduce the data frame down to only the required columns
combinedData <- combinedData[, reqdCols]

## cbind the subjects to the main set to add them in 
combinedData[, "Subject"] <- combinedSubject$V1
## and do the same with activities
combinedData[, "Activity"] <- combinedActivity$V1

## set some more meaningful names for the Activity Label set
colnames(activityLabels) <- c("ID", "ActvityName")

## bring in the descriptive activity name to the main data set
combinedData <- merge(x = combinedData, y= activityLabels, by.x="Activity", by.y = "ID")
## remove the now redundant activity id
combinedData$Activity <- NULL



## summarise the data by subject and activity with the average of each feature measurement
newData <- combinedData %>% group_by(Subject,ActvityName) %>% summarise_each(funs(mean))

## Write the result out to a file on disk
write.table(newData, file = "newData.txt", row.names = FALSE, col.names = TRUE)

