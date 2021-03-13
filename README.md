# GettingCleaningDataAssignment

### Daniel Benedicto Orenes
Repo for the peer graded assignment of the Coursera Getting and Celaning Data course

  





The repo consist on the following files:
  - CodeBook.md
  - run_Analysis.R

And two folders:
  - UCI HAR Dataset
    - This folder contains the original data and code book   
  - Tidy Dataset
    -This folder contains two tidy dasets, as required in the assignment, which are obtained using the run_Analysis.R file and the original data set. 
      - Tidy_set.csv
      - Reduced_set.txt
      - Reduced_set.csv

The run_Analysis.R file imports the original train and test datasets in UCI HAR Dataset folder. 
For each data set (train/test) it selects the columns that contain some mean() or std() of a measured quantity in the original datasets, and then it merges them adding the labels "train"/"test", and keeping the "subject_id", "activity_id" and "activity" columns. 

From the merged dataset (**tidyset**), using *lapply()* function in R, I apply the average over each quantity within the didyset, grouped by subject and activity, as required for the assignment. 
Then I merge everything and create a new dataset called newset, which I later export as Reduced_set. This last data set is the required dataset to pass the assignment. 

