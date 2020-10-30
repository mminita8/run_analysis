library(base)
library(dplyr)
## Reading activity and features tables
activity_labels<-read.table("activity_labels.txt")
features<-read.table("features.txt")

## Reading training data
subject_train<-read.table("train/subject_train.txt")
X_train<-read.table("train/X_train.txt")
y_train<-read.table("train/y_train.txt")

## Reading test data 
subject_test<-read.table("test/subject_test.txt")
X_test<-read.table("test/X_test.txt")
y_test<-read.table("test/y_test.txt")

## 1. Merging training and test datasets
x_set<-rbind(X_train, X_test)
y_set<-rbind(y_train, y_test)
subject_set<-rbind(subject_train, subject_test)

## 4. Setting the variable names
colnames(x_set)<-features[,2]
colnames(y_set)<-"activity"
colnames(subject_set)<-"subject"

## 2. Extracting mean and std columns
mean_std_col<-grep("mean()|std()", features[,2])
data_set<-x_set[mean_std_col]

## Including in data_set subject and y_test
data_set<-cbind(data_set, subject_set, y_set)

## 3. Naming the activities in the data set
activities<-factor(data_set$activity)
levels(activities)<-activity_labels[,2]
data_set$activity<-activities

## 5. Average data set by activity and subject
tidy_data<-data_set %>% group_by(activity, subject) %>% summarize_if(is.numeric, mean, na.rm=TRUE)
write.table(tidy_data, "tidy_data.txt", row.names = F, col.names=T)
