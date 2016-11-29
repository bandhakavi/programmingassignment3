
#loading training data
train_subject = read.table("./UCI HAR Dataset/train/subject_train.txt")
train_y = read.table("./UCI HAR Dataset/train/y_train.txt")
train_x = read.table("./UCI HAR Dataset/train/X_train.txt")

#loading testing data
test_subject = read.table("./UCI HAR Dataset/test/subject_test.txt")
test_y = read.table("./UCI HAR Dataset/test/y_test.txt")
test_x = read.table("./UCI HAR Dataset/test/X_test.txt")

#task 1: merging testing and training data for corresponding files
master_subject = rbind(train_subject,test_subject)
master_y = rbind(train_y,test_y)
master_x = rbind(train_x,test_x)

#task 4: adding colnames to the master data sets
names(master_subject) = "subject_id"
names(master_y) = "activity_id"
#extract featurenames from features.txt and assign these as colnames
#to the master observation set
feature_df = read.table("./UCI HAR Dataset/features.txt")
names(master_x) = feature_df[,2]

#task 2: extracting only means and standard deviations 
#selecting column names which have either mean or std in their names
col_shortlist = grep("mean\\(\\)|std\\(\\)",names(master_x),value = TRUE)
#using the column names to select only such column values from the master list
master_x_shortlist = master_x[,col_shortlist]

#loading activity_labels 
activity_labels = read.table("./UCI HAR Dataset/activity_labels.txt")

#task 5: 
#cbind the three master data sets
master_data = cbind(master_subject,master_y,master_x_shortlist)
library(plyr)
#master_data_summary contains the means of each variable grouped by subject id and activity id 
master_data_summary = ddply(master_data, .(subject_id,activity_id),colwise(mean))

#writing the table to a text file
write.table(master_data_summary, "tidy_master_data.txt")
