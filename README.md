** README.MD

*run_analysis.R

This script first sets the paths of the data files in the project directory "Dataset"
The script then reads the following.
1. Features data which contains the column names of the test and training data.
2. Activity data which contains the names of the activities
3. Test data which contains the data from the 'Test' pool
4. Test label which contains the activity code for each test data row
5. Test subject which contains the subject/volunteer is for each test data row
6. Similarly reads the train data, train label and train subject

The script then merges the label and subject columns into the respective test/train data frames using cbind
The test and train data frames are then combined into one using rbind

Using the activity data frame, the activity column in the combined data frame is mapped to the activity name.

Then a subset of the combined dataframe is create taking only the columns containing "mean" or "std", case insensitive.

The column names in the subset dataframe is then cleaned by separating the words with a period, eliminating white space and replacing abbrevations with the full word.

A new dataframe is created by grouping the subset dataframe by activity name and subject and taking the mean of all other columns.
This new dataframe is writting to a file name tidy_data.txt

