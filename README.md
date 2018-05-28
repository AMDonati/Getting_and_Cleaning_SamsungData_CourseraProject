# Getting_and_Cleaning_SamsungData_CourseraProject
This repo contains the script and codebook to issue a tidy dataset of Samsung Galaxy's accelerometers data.
script name: "run_analysis.R"
Code book name: "CodeBook.md"

## Raw data used 
The raw data has been dowloaded from this link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Outputs of the script
**The script *"run_analysis.R"* creates two tidy datasets (csv format) starting from the raw data:**

* __One dataset named "data" containing 10,999 observations of 68 variables:__
The first two columns called respectively list respectively the subject number, and the activity name performing by the subject when measurements have been taked by the Samsung's Galaxy. 

The columns 3 to 68 measures different features, list in the Code Book: these features represents either the mean, either the standard deviation of the original measures performed by the phone.  

* __A second dataset named "data_mean" containing 180 observations of 68 variables:__
The first 2 columns contains the subject number, and the activity name performed by the subject when the measurements have been recorded by the Samsung phone. They are listing 30 subjects each performing 6 different activities, hence the 180 observations. The listing of the subject and activities can be found in the file "CodeBook.md"
The columns 3 to 68 computes the mean of observations of the "dataset", by subject and by activity. 

## Getting and cleaning process performed in the R scripts
1. After downloading the raw data from the zipfile, the scripts reads the 2 raw datasets, the training set (X_train) and the test set(X_set). 
2. Two columns are added to these 2 sets, which list respectively the subject number (by reading subject_train and subject_test files), and the activity label (by reading the train_labels and test_labels files)
3. The script merges by rows the two sets into one dataset called "dataset"
4. The script reads the general info about the variables of the dataset ("features.txt" and "activity_labels.txt" files), and renames the columns of the dataset (starting from column 3) with the features names. 
5. The script creates a new column in the dataset named "activity" for writing the activity name associated to the activity label. It puts all the activity names in this column in lower cases. 
6. The first final dataset is named "data" and select from the dataframe called "dataset", the columns subject, activity and the columns corresponding to features measuring mean or standard deviation. 
7. From the dataframe "data", the script creates a new dataframe called "data_mean" that computes the mean of each observation containing in "data" by subject and by activity. 
8. The script exports the two final dataframes in two files named respectively "data" and "data_mean". 
