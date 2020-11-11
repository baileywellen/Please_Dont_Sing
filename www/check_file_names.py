#confirm that all of the files have the correct file names (because  I created them manually)

import os 

filenames = os.listdir()

#make a list of all of the numbers that we should have in the file names
numbers = [*range(0,88)]

#loop through all of the mp3 files
for num, file in enumerate(filenames):
    if file != "check_file_names.py":
        #extract just the number from the name and cast to an int
        just_number = file.replace(".mp3", "")
        just_number = just_number.replace("recording", "")
        just_number = int(just_number)
        
        #when we extract the number, we remove it from the file - there should be no repeats and none left over at the end
        try:
            numbers.remove(just_number)
        
        #if the number does not exist in the list, it means we have already removed it, so we have a repeated number in the file names
        except ValueError:
            print("There is an invalid file name in the www file ")
            
  
#if there are numbers leftover at the end, that means we missed a number in the filenames
try:       
    assert len(numbers) == 0
except:
    print("There were leftover numbers in the list - this means that there was a number skipped in the file names")

