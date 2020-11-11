# Please_Dont_Sing
*My undergraduate senior capstone exploring how machine learning can be used to classify whether music is enjoyable.*

Visit [the live site](https://baileywellen.shinyapps.io/Thesis) to rate Happy Birthday recordings and contribute to this research.  


This project is in progress - please see [my project proposal](/Project_Proposal.pdf) for a better idea of where this is headed.  

## Data files in this Github:   
* current_ratings.csv : Over 500 observations of ratings on how enjoyable the recordings are  
* audio_arrays.txt : the frequencies of the audio files - only modification was stripping zeros from the beginning and ends  
* simplified_audio_freq.csv : summary statistics on the audio features of each recording (mean, standard deviation, and length)  
* complete_audio_freqs.csv : a list of 1,000 datapoints for each recording - some recordings had to be cropped down to this length and some needed to be padded  
* grouped_frequencies.csv : the above file, but finding the mean of every 40 columns. There are now 25 columns per recording (there are 25 distinct notes in "Happy Birthday") 
* www/ - the raw (anonymized) audio recordings submitted by volunteers  


