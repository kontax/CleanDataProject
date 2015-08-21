
# Downloads and unzips the data into a "data" directory
getData <- function() {
    if(!file.exists("./data")) dir.create("./data")
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url, "./data/UCI_HAR_Dataset.zip")
    unzip("./data/UCI_HAR_Dataset.zip", exdir = "./data")
}

# Imports the training/test data into a single data frame
getDataFrame <- function() {
    
    # set the location of the files
    features <- "./data/UCI HAR Dataset/features.txt"
    activityLoc <- "./data/UCI HAR Dataset/activity_labels.txt"
    testDataLoc <- "./data/UCI HAR Dataset/test/X_test.txt"
    testLabelsLoc <- "./data/UCI HAR Dataset/test/y_test.txt"
    trainDataLoc <- "./data/UCI HAR Dataset/train/X_train.txt"
    trainLabelsLoc <- "./data/UCI HAR Dataset/train/y_train.txt"
    
    # pull the data into a dataframe
    testData <- read.table(testDataLoc, header = FALSE, strip.white = TRUE)
    trainData <- read.table(trainDataLoc, header = FALSE, strip.white = TRUE)
    
    # label the dataframes with the correct labels
    activity <- read.table(activityLoc, header = FALSE, strip.white = TRUE)
    testActivity <- read.table(testLabelsLoc, header = FALSE, strip.white = TRUE)
    trainActivity <- read.table(trainLabelsLoc, header = FALSE, strip.white = TRUE)
    
    # merge the activity tables
    testActivity <- merge(testActivity, activity)
    trainActivity <- merge(trainActivity, activity)
    names(testActivity) <- c("ID", "Activity")
    names(trainActivity) <- c("ID", "Activity")
    activityData <- rbind(testActivity, trainActivity)
    
    # add the features as headings
    allData <- rbind(testData, trainData)
    names(allData) <- as.vector(read.table(features, header = FALSE)[,2])
    
    # get the relevant columns from the dataset
    relCols <- which(sapply(names(allData), function(x) any(grep('mean\\(\\)', x) || grepl('std\\(\\)', x))))
    allData <- allData[,unname(relCols)]
    
    # add the labels to the dataset
    merged <- cbind(activityData, allData)
    merged
}

run <- function() {
    getData()
    x <- getDataFrame()
    write.table(x, row.names = FALSE, file = "./output.txt")
}
