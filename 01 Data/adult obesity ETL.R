require(readr)
require(plyr)

# Set the Working Directory to the 00 Doc folder
file_path = "../../CSVs/PreETL_adultobese.csv"
adultobese <- readr::read_csv(file_path)
names(adultobese)

df <- plyr::rename(adultobese, c("table"="tbl")) # table is a reserved word in Oracle so rename it to tbl.
names(df)
names(df)[1]<-"Location"
names(df)[2]<-"Value"
str(df) # Uncomment this line and  run just the lines to here to get column types to use for getting the list of measures.

measures <- c("Value", "Sample Size")
#measures <- NA # Do this if there are no measures.

dimensions <- setdiff(names(df), measures)
dimensions

# Get rid of special characters in each column.
# Google ASCII Table to understand the following:
for(n in names(df)) {
  df[n] <- data.frame(lapply(df[n], gsub, pattern="[^ -~]",replacement= ""))
}

# The following is an example of dealing with special cases like making state abbreviations be all upper case.
# df["State"] <- data.frame(lapply(df["State"], toupper))

na2emptyString <- function (x) {
  x[is.na(x)] <- ""
  return(x)
}
if( length(dimensions) > 0) {
  for(d in dimensions) {
    # Change NA to the empty string.
    df[d] <- data.frame(lapply(df[d], na2emptyString))
    # Get rid of " and ' in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern=":",replacement= ";"))
  }
}

na2zero <- function (x) {
  x[is.na(x)] <- 0
  return(x)
}
# Get rid of all characters in measures except for numbers, the - sign, and period.dimensions, and change NA to 0.
if( length(measures) > 0) {
  for(m in measures) {
    print(m)
    df[m] <- data.frame(lapply(df[m], gsub, pattern="[^--.0-9]",replacement= ""))
    df[m] <- data.frame(lapply(df[m], na2zero))
    df[m] <- data.frame(lapply(df[m], function(x) as.numeric(as.character(x)))) # This is needed to turn measures back to numeric because gsub turns them into strings.
  }
}
str(df)

write.csv(df, gsub("PreETL_", "", file_path), row.names=FALSE, na = "")

