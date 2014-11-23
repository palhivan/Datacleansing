
#getting column names which needed
columnName <-  read.table("UCI HAR Dataset/features.txt",colClasses="character")

columns <- columnName$V2
columns_needed <- grepl("mean|std", columns, ignore.case=TRUE)

#getting activity labels

label <- read.table("UCI HAR Dataset/activity_labels.txt",colClasses="character")

# reading in test files first
activity <-read.table("UCI HAR Dataset/test/y_test.txt", colClasses="character")
subject <-read.table("UCI HAR Dataset/test/subject_test.txt")
table <-read.table("UCI HAR Dataset/test/X_test.txt")

#labeling table columns
colnames(table) <- columnName$V2

table <- table[,columns_needed]

# merging them together

test_table <- cbind(activity,subject,table)

# renaming first 2 colums
colnames(test_table)[c(1,2)] <- c("activity","subject")

#labeling activity

test_table$activity <- factor(test_table$activity,levels = label$V1, labels=label$V2)

# same for train files

activity <-read.table("UCI HAR Dataset/train/y_train.txt", colClasses = "character")
subject <-read.table("UCI HAR Dataset/train/subject_train.txt")
table <-read.table("UCI HAR Dataset/train/X_train.txt")

#labelling columns ang getting which needed
colnames(table) <- columnName$V2
table <- table[,columns_needed]

# merging them together
train_table <- cbind(activity,subject,table)

# renaming first 2 colums
colnames(train_table)[c(1,2)] <- c("activity","subject")

#labeling activity

train_table$activity <- factor(train_table$activity,levels = label$V1, labels=label$V2)



# merging tables

merged_table <- rbind(test_table,train_table)

#create data set with averages
tidy = aggregate(merged_table[,3:88], by=list(activity = merged_table$activity,
                                              subject=merged_table$subject), mean)

write.table(tidy, file = "./tidy_data.txt", row.names=FALSE)
