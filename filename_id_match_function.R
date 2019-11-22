# Created 21.11.2019 under R version 3.6.1 
# Contact Rasmus Boman / rasmus.a.boman@gmail.com in case of emergency. Or something.

# This function (below) lists all the files and folders in a given folder (folder.path),
# takes an excel (excel.path) and separates 1 column with IDs (ID.column.in.excel) from it.

# The function searches full / partial matches of the IDs through all the file names and lists the matches to an
# excel (output.filename) into given (output.path) location. 

# In excel:

# 1. original_excel_ID = the unchanged ID from original excel file.
# 2. filename_in_computer = the best match in computer folders.
# 3. folder_path_full_match = if the ID-to-file match is perfect, there is a folder path in this column
# 4. folder_path_partial_match = if the ID-to-file match is imperfect, there is a folder path also in this column

# In case there are several matches, the function writes a new row to each of them.
# If you want to search through several different excels from a very large amount of folders
# consider changing the code so that it lists the folders only once and apply this list straight to kansiot-vector.

# install.packages(c("tidyverse", "readxl", "openxlsx", "fuzzyjoin")) #if needed

match_ids_to_filenames <- function(folder.path, excel.path, ID.column.in.excel, output.path, output.filename){
  
  library(tidyverse)
  library(readxl)
  library(openxlsx)
  library(fuzzyjoin)
  
  kansiot <- list.dirs(path = folder.path) # Creates a list of directories inside given folder
  
  koko_tiedostonimet <- map(kansiot, list.files, full.names = T) %>% # Takes each of the folders and applies list.files-function to it (full.name = T, full path)
    flatten() %>% # Flattens the contents of these folders into one list of lists 
    unlist() %>% # Unlist the separate lists into one long list
    as_tibble # Turn the list into a dataframe for further joining
  
  tiedostoja_df <- map(kansiot, list.files) %>% # Takes each of the folders and applies list.files-function to it (full.name = F, only file name)
    flatten() %>%       # Flattens them into a list of lists
    unlist()  %>%       # Joins the lists into one long list
    as_tibble() %>%     # Turn the list into a dataframe for further joining
    bind_cols(koko_tiedostonimet) # Combine these two dataframes into one, with long path and just the filename
  
  tibble_with_IDs <-  read_xlsx(path = excel.path) %>% #Read in the excel file with ID to be matched to files
    as_tibble() %>% # Turning it into dataframe (for joining)
    select(value = ID.column.in.excel) %>% # Selecting only the defined column
    unique() # Keeping the unique IDs
  
  full_match <- tibble_with_IDs %>% # Perfect matches, simple to join by value 
    left_join(tiedostoja_df, by = "value") # Attaching perfectly matching filenames into IDs from excel.  
  
  fuzzy_match <- tiedostoja_df %>% # Starting with the filenames (long list)
    fuzzy_inner_join(tibble_with_IDs, by = "value", match_fun = str_detect) # Inner join keeps only matching rows (fuzzy join also partial matches).

  final_df <- full_match %>%
    left_join(fuzzy_match, by = c("value" = "value.y")) %>% #value.y is from fuzzy_match and originally from excel_ID (still unchanged)
    select(original_excel_ID = value, # From original excel-file
           filename_in_computer = value.x, # Closest (or fully) matching file in the computer.
           folder_path_full_match = value1.x, # If filename is 100% match, there is folder path in this variable.
           folder_path_partial_match = value1.y) # If filename is not 100% match, there is folder path also in this variable.
  
  write.xlsx(final_df, paste(output.path, output.filename, sep = "")) # Writing an excel-file for easier usage.

}

# Below an example, note the exact form of the paths.
# The function won't overwrite xlsx-files -> the output needs to be renamed every time!!

testi_result <- match_ids_to_filenames(folder.path = "C:/Users/", 
                                       excel.path = "C:/Users/Rasmusbo/testexcelhere.xlsx",
                                       ID.column.in.excel = 35,
                                       output.path = "C:/Users/Rasmusbo/R_results/",
                                       output.filename = "test10.xlsx")

