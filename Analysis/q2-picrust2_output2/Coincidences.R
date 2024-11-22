# Required libraries
library(dplyr)
library(stringr)
library(purrr)

# Sample data frame
df <- data.frame(
  SampleID = c("Sample1", "Sample2", "Sample3"),
  Pathways = c("pathwayA,pathwayB,pathwayC", 
               "pathwayB,pathwayC,pathwayD", 
               "pathwayA,pathwayC,pathwayE")
)

# Function to detect coincidences
detect_coincidences <- function(df) {
  # Split pathways into a list
  df$Pathways_list <- str_split(df$diff_features, ",")
  
  # Initialize a list to store the coincidences
  coincidences <- vector("list", nrow(df))
  
  # Loop over each row to find overlaps
  for (i in 1:nrow(df)) {
    # Compare current row with all others
    overlaps <- map(df$Pathways_list, function(x) {
      intersect(df$Pathways_list[[i]], x)
    })
    
    # Store coincidences for the current row
    coincidences[[i]] <- overlaps
  }
  
  # Add the coincidences to the data frame
  df$Coincidences <- coincidences
  return(df)
}

# Apply the function
result <- detect_coincidences(comparison_results2_Level_3)

# Print the result
print(result)
