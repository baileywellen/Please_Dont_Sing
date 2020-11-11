# -*- coding: utf-8 -*-
"""
Created on Mon Oct 26 09:05:36 2020

@author: baile
"""

from aubio import source, pitch
import numpy as np
import operator


def read_frequencies(filename):
    #we will use the original amount of samples in the file
    s = source(filename)    
    tolerance = 0.8
    
    #yin is a frequency estimation algorithm
    pitch_o = pitch("yin", samplerate = s.samplerate)
    pitch_o.set_unit("Hz")
    pitch_o.set_tolerance(tolerance)
    
    pitches = []
    confidences = []
        
    # total number of frames read
    total_frames = 0
    while True:
        samples, read = s()
        this_pitch = pitch_o(samples)[0]
        
        confidence = pitch_o.get_confidence()
        
            
        pitches += [this_pitch]
        confidences += [confidence]
        total_frames += read
        if read < s.hop_size: break
    
    
    #close that audio when we are done with it 
    s.close()
    
    return pitches, confidences
    
#here, we are trying to make them all the same length to be fed into the machine learning algorithm
def make_arrays_same_length(pitches, confidences):
    #f.write("RECORDING {} \n".format(recording_num))
    #f.write(str(pitches))
    #f.write("\n")
    
    # strip zeros from beginning and end of each list 
    while (len(pitches) > 0) and (pitches[0] == 0.0) :
        pitches.pop(0)
        confidences.pop(0)
            
    while (len(pitches) > 0) and  (pitches[-1] == 0.0) :
        pitches.pop(-1)
        confidences.pop(-1)
    
    
    #if we need to delete any frequencies
    if len(pitches) > 1000:    
             
        #we will delete the frequencies with the lowest confidence 
        total_to_delete = len(pitches) - 1000
        
        while total_to_delete > 0:
            #print("current confidence:" , sum(confidences) / len(confidences))
            #find the frequency that we are the least confident about 
            min_value = min(confidences)
            min_index = confidences.index(min_value)
                
            #we will delete that value from the confidences and the pitches array so that they don't get out of sync
            del confidences[min_index]
            del pitches[min_index]
            
            total_to_delete -= 1
            
            
    # if we need to add any frequencies       
    elif len(pitches) < 1000:
        total_added = 0 
        total_to_add = 1000 - len(pitches)
        last_confidence = 1
        
        #we will add repeats of the frequencies with the highest confidence 
        while total_added < total_to_add:
            current_confidence = sum(confidences) / len(confidences)
            
            #if we are starting to add low confidence values, we will reset and start adding the high confidence values again
            if current_confidence < last_confidence:
                temp_confidences = confidences.copy()
            
            
            #find the frequency that we are the most confident about 
            max_value = max(temp_confidences)
            max_index = temp_confidences.index(max_value)
            
         
            #we will add that value to the confidences array again
            confidences.insert(max_index, max_value)
            pitches.insert(max_index, pitches[max_index])
            
            #so we don't keep getting the same value as the max 
            temp_confidences[max_index] = 0
            
            #keep it in line with the confidences
            temp_confidences.insert(max_index, 0)
    
            total_added += 1
            last_confidence = current_confidence
            
    print('-------------------------------------------------------------------------------------------------------')
            
        #f.close()
    return pitches
  
#loop through all of the files and read their frequency values
all_pitches = []
all_confidences = []

#reading in all of the audio files and saving the frequencies in lists
for num in range(0, 88):
    filename = 'C://Users//baile//OneDrive//Desktop//Classes//Fall2020Classes//Thesis//Please_Dont_Sing//www//recording' + str(num) + '.mp3'
    these_pitches, these_confidences = read_frequencies(filename)
    all_pitches.append(these_pitches)
    all_confidences.append(these_confidences)
    

f = open("C://Users//baile//OneDrive//Desktop//Classes//Fall2020Classes//Thesis//Please_Dont_Sing//complete_audio_freqs.csv", "w")

csv_titles= []
for i in range(1000):
    csv_titles.append("frequency{}".format(i))

f.write(','.join(csv_titles))
f.write('\n')

#making all of the arrays have the same length so they can be compared
for recording_num in range(0,88):
    pitches = all_pitches[recording_num]
    confidences = all_confidences[recording_num]
    shortened_pitches = make_arrays_same_length(pitches, confidences)
    shortened_pitches_strings = ["%.2f" % number for number in shortened_pitches]
    print("Index {} has a length of {} ".format(recording_num, len(shortened_pitches_strings)))
    f.write(','.join(shortened_pitches_strings))
    f.write('\n')

f.close()
    
#The below section outputs the length, standard deviation, and average frequency of each recording
#f = open("C://Users//baile//OneDrive//Desktop//Classes//Fall2020Classes//Thesis//Please_Dont_Sing//simplified_audio_freq.csv", "w")
#f.write('id, average, std_dev, len')
#for recording_num in range(0, 88):
#    #find the average frequency of that recording
#    average_freq = sum(all_pitches[recording_num]) / len(all_pitches[recording_num])
#    #find the average frequency of that recording
#    std_freq = np.std(np.array(all_pitches[recording_num]))
#    
#    #write those values to a file - recording id, average, std dev, and length
#    f.write("{}, {}, {}, {} \n".format(recording_num, average_freq, std_freq, len(all_pitches[recording_num])))

    
#f.close()
            










