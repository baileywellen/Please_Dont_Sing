# Please_Dont_Sing
*My undergraduate senior capstone exploring how machine learning can be used to classify whether music is enjoyable.*

Visit [the live site](https://baileywellen.shinyapps.io/Thesis) to rate Happy Birthday recordings and contribute to this research.  


This project is in progress - please see [my project proposal](/Project_Proposal.pdf) for a better idea of where this is headed.  

## Navigating the Files in this Github:

### Data files:   
* `current_ratings.csv` : Over 500 observations of ratings on how enjoyable the recordings are  
* `complete_audio_freqs.csv` : a list of 1,000 datapoints for each recording - some recordings had to be cropped down to this length and some needed to be padded  
* `audio_differences.csv` : All frequencies grouped into 25 averages (there are 25 distinct notes in "Happy Birthday"). Then, I calculated the difference between the first average and each subsequent average. These 25 columns represent the starting pitch and the change between that pitch and the following pitches. This data is what we use as the input features for the ML model.
* `www/` - the raw (anonymized) audio recordings submitted by volunteers  

### Scripts and Code:  
* `Collect_ratings.R` is the RShiny script that allowed volunteers to listen to recordings, rate them, and submit  
* `read_mp3.py` is the Python script that read in all 88 recordings, converted them to lists of frequencies, cleaned the data, and wrote out the data files listed above  
* `Thesis_clean_data.ipynb` prepared the data to be fed into the ML model by finding the z scores of the ratings to standardize by the people who rated them  
* `Thesis_building_ML.ipynb` built a ridge regression model and assessed its accuracy using repeated k fold validation  
* `implement_ML.py` is the script where we begin to implement the machine learning model we have built and prepare it to be deployed  

### Supporting Documents:  
* `Project_Proposal.pdf`  



