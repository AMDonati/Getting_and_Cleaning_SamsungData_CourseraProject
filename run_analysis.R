
#downloading the UCI dataset in a folder named data
if (!file.exists("data")){
        dir.create("data")
}
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile="./data/HAR_data_UCI.zip",method="curl")
list.files("./data")

# unzipping the file and setting the wd to the dataset folder
library(readr)
unzip("./data/HAR_data_UCI.zip")
setwd("./UCI HAR Dataset")

library(dplyr)
#reading the training set info
train_set<-read.table("./train/X_train.txt")
train_labels<-read.table("./train/y_train.txt")
subject_train<-read.table("./train/subject_train.txt")
## adding subject and activity labels to the training set
train_set$activity_label<-train_labels$V1
train_set$subject<-subject_train$V1
## ordering the training set by putting the subject and activity labels first
train_set<-select(train_set,subject,activity_label,V1:V561)

#reading the test set info
test_set<-read.table("./test/X_test.txt")
test_labels<-read.table("./test/y_test.txt")
subject_test<-read.table("./test/subject_test.txt")
#adding subject and activity labels to the training set
test_set$activity_label<-test_labels$V1
test_set$subject<-subject_test$V1
#ordering the training set by putting the subject and activity labels first
test_set<-select(test_set,subject,activity_label,V1:V561)

# merging the 2 datasets
dataset<-rbind(train_set,test_set)

# ordering the dataset by subject number and activity_label
dataset<-arrange(dataset,subject,activity_label)

#reading general dataset info
features<-read.table("features.txt")
activity_labels<-read.table("activity_labels.txt")

# naming the dataset columns with the features names
names(dataset)[3:563]<-as.character(features$V2)
# adding the activity names in a column named "activity"
for (i in 1:nrow(dataset)){
        dataset$activity[i]<-tolower(as.character(activity_labels[activity_labels$V1==dataset$activity_label[i],2]))
}

#selecting the columns measuring mean and std
cols_mean<-grep("-mean()",names(dataset),fixed=TRUE) 
# we need to set"fixed" to TRUE to remove "MeanFreq" measures
cols_std<-grep("-std()",names(dataset))
cols_selection<-sort(c(1,cols_mean,cols_std,564)) # selectioning the columns subject(1),activity(564),col_mean,col_rows
data<-dataset[,cols_selection]
# ordering the columns by putting 'activity'in second
data<-select(data,subject,activity,2:67)

# creating the second dataset with mean of each variable by subject and activity
## Creating a new dataframe with 180 rows, with the 2 first columns being the subject and
## activity factor levels
data_mean<-data.frame(activity_subject=unique(interaction(data$activity,data$subject)))
library(tidyr)
data_mean<-data_mean %>% 
        separate(activity_subject,c("activity","subject"),sep="[.]") %>% 
        select(subject,activity)
for (i in 3:68){
        s<-split(data[,i],list(data$activity,data$subject),drop=T)
        data_mean[,i]<-sapply(s,mean,rm.na=T)
}
names(data_mean)[3:68]<-names(data)[3:68]

#Deleting the intermediary dataset
rm(dataset)

#exporting the 2 final datasets
write.table(data,"./data.csv")
write.table(data_mean,"./data_mean.csv")