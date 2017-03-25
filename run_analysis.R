run_analysis <- function(){
  library(dplyr)
  base_path <- c('Dataset')
  #path to features file
  features_file <- paste(base_path, 'features.txt', sep="/")
  activity_file <- paste(base_path, 'activity_labels.txt', sep="/")
  #paths to test data files
  test_data_file <- paste(base_path, "test/X_test.txt", sep="/")
  test_label_file <- paste(base_path, "test/Y_test.txt", sep="/")
  test_subject_file <- paste(base_path, "test/subject_test.txt", sep="/")
  
  #paths to train data files
  train_data_file <- paste(base_path, "train/X_train.txt", sep="/")
  train_label_file <- paste(base_path, "train/Y_train.txt", sep="/")
  train_subject_file <- paste(base_path, "train/subject_train.txt", sep="/")
  
  #read features data file
  features_data <- read.table(features_file)
  #read activity data file
  activity_data <- read.table(activity_file)
  #read test data file
  test_data <- read.table(test_data_file)
  #set the column names of test data from the features dataframe
  colnames(test_data) <- features_data[,2]
  
  test_label <- read.table(test_label_file)
  test_subject <- read.table(test_subject_file)
  
  #read train data file
  train_data <- read.table(train_data_file)
  #set the column names of test data from the features dataframe
  colnames(train_data) <- features_data[,2]
  train_label <- read.table(train_label_file)
  train_subject <- read.table(train_subject_file)
  
  #combine subject and activity id with the test data
  combo_test_data <- cbind(test_subject, cbind(test_label, test_data))
  
  #combine subject and activity id with the train data
  combo_train_data <- cbind(train_subject, cbind(train_label, train_data))
  
  #combine test and train data
  combo_data <- rbind(combo_test_data, combo_train_data)
  
  #label the subject and activity columns
  colnames(combo_data)[1] <- "subject"
  colnames(combo_data)[2] <- "activity"
  
  #merge the activity data with the combined data to get activity name
  combo_data <- merge(activity_data, combo_data, x.by="V1", y.by="activity")
  
  #remove activity id columns
  combo_data$V1 <- NULL
  combo_data$activity <- NULL
  colnames(combo_data)[1] <- "activity"
  
  #extract only the columns that measure the mean and standard deviation
  col_index <- c(1,2)
  col_index <- c(col_index, grep("[mM][eE][aA][nN]|[sS][tT][dD]", colnames(combo_data)))
  combo_data <- combo_data[,col_index]
  cols <- colnames(combo_data)
  cols <- gsub("tBody", "tbody.", cols)
  cols <- gsub("fBody", "fbody.", cols)
  cols <- gsub("tGravity", "tgravity.", cols)
  cols <- gsub("Acc", "accelerometer", cols)
  cols <- gsub("-", ".", cols)
  cols <- gsub("[gG]yro", "gyroscope", cols)
  cols <- gsub("Freq", ".frequency", cols)
  cols <- gsub("Jerk", ".jerk", cols)
  cols <- gsub("Mag", ".mag", cols)
  cols <- gsub("Mean", ".mean", cols)
  cols <- gsub(".Body", ".", cols)
  cols <- gsub("\\(\\)", "", cols)
  colnames(combo_data) <- cols
  #take the mean of each column grouped by activity and subject
  mean_data <- combo_data %>% group_by(activity, subject) %>% summarize_each(funs(mean))
  #write the resulting dataframe to a file
  write.table(mean_data, paste(base_path, 'tidy_data.txt', sep="/"), col.names = TRUE, row.names = FALSE)
  
}