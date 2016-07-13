# source 1
# r - Read multiple tables in from a single text file? - Stack Overflow answered by by0 on Sep 28 2012. See \url{http://stackoverflow.com/questions/7264153/read-multiple-tables-in-from-a-single-text-file}.

# source 2
# loop through all files in a directory, read and save them in an object R - Stack Overflow answered by iembry on Jan 13 15. See \url{http://stackoverflow.com/questions/27911604/loop-through-all-files-in-a-directory-read-and-save-them-in-an-object-r/27912952}.

# source 3
# How to create automatic text file from a list in R? - Stack Overflow answered by Richard Scrivenon Sep 26 14 and edited by Richard Scrivenon Sep 27 14. See \url{http://stackoverflow.com/questions/26068156/how-to-create-automatic-text-file-from-a-list-in-r}.

# Data source \url{http://waterdata.usgs.gov/usa/nwis/qwdata?codes_table26_help}
# Table 26. Parameter codes with fixed values

library(data.table)
# source 1 begins
qwdata_codes <- readLines("data-raw/qwdata?codes_table26_help.txt")

begin <- grep("^(\\d{5})(\\s)(\\w+)", qwdata_codes)
edge <- vector("integer", length(qwdata_codes))
edge[begin] <- 1
qwdata_codes_names <- qwdata_codes[begin]

edges <- cumsum(edge)

df <- lapply(split(qwdata_codes, edges), function(dat) {

input <- read.delim(textConnection(dat), skip = 1, header = FALSE, fill = TRUE, sep = "$", colClasses = c("character", "numeric", "character"), stringsAsFactors = FALSE)
attr(input, "name") <- dat[1]  # save the name

colnames(input) <- c("Parameter Code", "Fixed Value", "Fixed Text")

input

})

names(df) <- sapply(df, attr, "name")
# source 1 ends

longnames <- names(df)

names(df) <- paste0("pmcode_", substr(names(df), 1, 5))

# source 2 and 3
invisible(lapply(names(df), function(u) {
assign(u, df[[u]])
save(list = u, file = paste0("data/", u, ".RData"))
}))

