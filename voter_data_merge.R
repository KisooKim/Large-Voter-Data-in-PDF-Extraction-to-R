## This R file merge all csv files in the path created by
## voter_data.R.

## Load and combine csv files in path
merge_data <- function(path) { 
    files <- dir(path, pattern = '\\.csv', full.names = TRUE)
    tables <- lapply(files, read.csv)
    do.call(rbind,tables)
}
path <- './ListOfRegisteredVoters/'
data_merged <- merge_data(path)

## Remove needless numbering column
data_merged <- data_merged[,2:13]

## Remove white spaces in REG..DATE column
data_merged$REG..DATE <- gsub('\\s+', '', data_merged$REG..DATE)

## And then save it as one csv file
write.csv(data_merged,'./ListOfRegisteredVoters/All_ListOfRegisteredVoters.csv')