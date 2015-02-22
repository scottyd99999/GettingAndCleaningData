### The script (run_Analysis.R) merges datasets pertaining to wearable device readings, removes all columns not related to means or standard deviations and then creates a summarised data set with the average of each of a number of types of feature readings stored for each subject and activity type

###The steps involved are as follows:


1. Read the various data files, specifically:
  + the training data set of feature observations (x_train.txt)
  + the link to the activity completed on a given observation (row) (y_train.txt)
  + the descriptive labels for each of the feature observation types (features.txt)
  + the link to the subject who completed a given observation (row) (subject_train.txt)


2. Then repeat the same for the test dataset counterparts
  + x_test.txt
  + y_test.txt
  + subject_test.txt


3. And finally the descriptive labels for each of the 6 types of activities within the study (activity_labels.txt)


4. UNION the test and training datasets together using row binding,

5. The column names in use (V1, V2,... Vn) aren't of much use so retrieve a more appropriate list by reading the list of 561 feature names and use this as the new (descriptive list) of column names for the combined data set.


6. Now do the same with all of the related data - i.e. activities and subjects. Doing it now to ensure that the order is preserved as we'll need that to properly relate the feature observations to the correct activity being performed and the subject performing them. This gives combined sets for training and test activities and training and test subjects.


7. We are only concerned with columns that measure mean and standard deviation from the readme file supplied with the [original] data we can see that these column names will contain mean(), std() or Mean()


8. [Using grep] Get the feature columns which contain a mean or a stadard deviation

9. Reduce the data frame down to only the features for means or standard deviations found in the prior step.

10. Column bind the subject and activity columns to this reduced set to relate the information for the activity performed and the subject performing it to the set of observations.

11. Use the merge command to join the [descriptive] activity labels to the main set, thus enabling the activity numeric id to be replaced by a human readable description of the activity. 

12. Use the group_by and summarise_each functions from dplyr to reduce the data set down to just one set of observations (row) for each combination of subject and area (e.g. subject 24, Walking; Subject 3, Laying; etc) taking the mean of all observations for the subject, activity pairings.

13. Finally write out the resulting tidy data set to a file named newData.txt. The first row of the file contains the column names. The file can be read using read.table("newData.txt")


