filename_id_match_function.R

Created 21.11.2019 under R version 3.6.1 
Contact Rasmus Boman / rasmus.a.boman@gmail.com in case of emergency. Or something.

This function was originally created to locate underwater videos in network hard drive from an ID-column found in survey excels.
Several cases were such that the video ID in excel was for example GOPRO1234 and the filename in computer was 1.3m_GOPRO1234_Seili.mvi
so partial match was included in the function.

This function lists all the files and folders in a given folder (folder.path),
takes an excel (excel.path) and separates 1 column with IDs (ID.column.in.excel) from it.

The function searches full / partial matches of the IDs through all the file names and lists the matches to an
excel (output.filename) into given (output.path) location. 

In excel:

1. original_excel_ID = the unchanged ID from original excel file.
2. filename_in_computer = the best match in computer folders.
3. folder_path_full_match = if the ID-to-file match is perfect, there is a folder path in this column
4. folder_path_partial_match = if the ID-to-file match is imperfect, there is a folder path also in this column

In case there are several matches, the function writes a new row to each of them.

If you want to search through several different excels from a very large amount of folders
consider changing the code so that it lists the folders only once and apply this list straight to kansiot-vector.

