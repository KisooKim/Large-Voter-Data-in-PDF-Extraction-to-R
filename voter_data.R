## This R file loads the voter pdf file by small parts,
## and save them into csv files. It will take quite a while.
##
## After this file is run, those csv files can be merged by
## voter_data_merge.R.

## Set memory limit to 8000MB
options(java.parameters = "-Xmx8000m")

## Load library and set file location
## Tabulizer installation:
## https://ropensci.org/blog/blog/2017/04/18/tabulizer
library("tabulizer")
directory <- "ListOfRegisteredVoters051616-DC.pdf"

## Divide and conquer:
## Due to memory limit, we divide each 10 pages into an
## individual csv. We may combine the csv files later.
## Determine how many pages there are and how many loops to run
total_pages <- get_n_pages(directory)
divided_pages <- round(total_pages/1000)*1000
j_times <- divided_pages/10


for(j in 0:j_times){
    ## Set a page range to extract
    j<-899
    start <- j*10+1
    end <- start+9
    ## Skip for page numbers larger than total page number
    if(start>total_pages){
        next
    }
    ## Set last page number as total page number when too large
    if(end>=total_pages){
        end<-total_pages;
    }
    ## Extract according to the set range
    tab <- extract_tables(directory, pages=start:end)
    head <- tab[[1]][1,]
    pages <- length(tab)
    tab_use <- tab
    
    ## Remove the first rows (heads)
    for(i in 1:pages){
        rows <- dim(tab_use[[i]])[1]
        tab_use[[i]] <- tab_use[[i]][2:rows,]
    }
    
    ## Combine into a data frame
    tab_df <- setNames(as.data.frame(do.call("rbind", tab_use)), head)
    
    ## Save the data frame into a csv file
    write.csv(tab_df,paste0('./ListOfRegisteredVoters/ListOfRegisteredVoters', j+1 ,'.csv'))
    
    ## Flush memory to keep going
    gc()
}