# Following example in 
# https://medium.com/@traffordDataLab/querying-apis-in-r-39029b73d5f1

library(tidyverse)
#install.packages("httr")
library(httr) 
#install.packages("jsonlite")
library(jsonlite)

#retrieve street level reports of burglary within a mile radius of a specific location
path <- "https://data.police.uk/api/crimes-street/burglary?"

# supply the path to the API endpoint and provide search parameters in the form of a list to the query argument
request <- GET(url = path, 
               query = list(
                 lat = 53.421813,
                 lng = -2.330251,
                 date = "2018-05")
)

# check if the API returned an error
# If the request fails the API will return a non-200 status code
request$status_code

# parse the content returned from the server as text using the content function.
response <- content(request, as = "text", encoding = "UTF-8")

# parse the JSON content and and convert it to a data frame
df <- fromJSON(response, flatten = TRUE) %>% 
  data.frame()

# strip out some of the variables and rename the remaining
df <- select(df,
             month, category, 
             location = location.street.name,
             long = location.longitude,
             lat = location.latitude)
head(df)
length(df)
dim(df)

# Now have dataframe of burglaries with five covariates for each of the 26 instances
# Can use to statistically manipulate for descriptive/explanatory or predictive purposes