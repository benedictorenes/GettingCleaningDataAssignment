library(data.table)
library(dplyr)


# First, load names of variables/features 
dir1 = "./UCI HAR Dataset"
tr = "/train"
tst = "/test"

activities = read.table(paste0(dir1,"/activity_labels.txt"))
activity_labels = activities$V2

feat = read.table(paste0(dir1,"/features.txt"))
features = feat$V2



### Load train data set:
# subject_train.txt / X_train.txt / y_train.txt

# xtr contains all the observations: 7352 from the 561 features
xtr = read.table(paste0(dir1,tr,"/X_train.txt"))
# add column names corresponding to the features
colnames(xtr) = features

#which columns are some kind of mean or std
selecttr = c(grep("mean",names(xtr)),grep("std",names(xtr)))
xtr_sel = xtr[selecttr]

# subtr is a list of length 7352 identifying the subject from which the measurements 
# where recorded, an integer number between 1 and 30
subtr = read.table(paste0(dir1,tr,"/subject_train.txt"))
subtr = subtr$V1
# add a column to the data set with the subject identifier
xtr_sel$subject_id = subtr
# add label column to indicate test or train sets
xtr_sel$set = rep("train",length(subtr))

# ytr is a list of integer values between 1 and 6 identyfying the activity 
# of the subject during the measurements: can be matched to activity_labels
ytr = read.table(paste0(dir1,tr,"/y_train.txt"))
ytr = ytr$V1
# add a column to the data set with the activity identifier
xtr_sel$activity_id = ytr
#create new column matching the activities with their id's
ytr2 = as.character(ytr)
for (i in 1:6){ 
  ind = as.character(i)
  ytr2 = sub(ind,as.character(activity_labels)[i],ytr2)
}
# add that column to the data set
xtr_sel$activity = ytr2





### Load test data set:
# subject_test.txt / X_test.txt / y_test.txt

# xtst contains all the observations: 2947 from the 561 features
xtst = read.table(paste0(dir1,tst,"/X_test.txt"))
colnames(xtst) = features

#which columns are some kind of mean or std
selecttst = c(grep("mean",names(xtst)),grep("std",names(xtst)))
xtst_sel = xtst[selecttst]

# subtst is a list of length 2947 identifying the subject from which the measurements 
# where recorded, an integer number between 1 and 30
subtst = read.table(paste0(dir1,tst,"/subject_test.txt"))
subtst = subtst$V1

xtst_sel$subject_id = subtst

# add label column to indicate test or train sets
xtst_sel$set = rep("test",length(subtst))

# ytst is alist of integer values between 1 and 6 identyfying the activity 
# of the subject during the measurements: can be matched to activity_labels
ytst = read.table(paste0(dir1,tst,"/y_test.txt"))
ytst = ytst$V1

# add a column to the data set with the activity identifier
xtst_sel$activity_id = ytst

#create new column matching the activities with their id's
ytst2 = as.character(ytst)
for (i in 1:6){ 
  ind = as.character(i)
  ytst2 = sub(ind,as.character(activity_labels)[i],ytst2)
}
# add that column to the data set
xtst_sel$activity = ytst2



##### join the data sests
tidyset = rbind(xtr_sel,xtst_sel)

av_summ = lapply(as.character(names(xtr_sel)),
                 function(x) group_by(tidyset,subject_id,activity) %>% summarise(mean(.data[[x]])))

newset = av_summ[[1]]
for (i in 2:79){
  newset = cbind(newset,av_summ[[i]][[3]])
}

newset = as.data.frame(newset)
av_names = lapply(names(xtr_sel)[1:79],function(x) paste0("Mean(",x,")"))
colnames(newset)=c("subject_id","activity",av_names)

dir2 = "./Tidy Dataset"
write.csv(newset,paste0(dir2,"/Reduced_set.csv"))
tidyset %>% relocate(activity)
tidyset = tidyset %>% relocate(c(subject_id,set,activity_id,activity))
write.csv(tidyset,paste0(dir2,"/Tidy_set.csv"))



