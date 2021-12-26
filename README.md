# Infusing Domain Knowledge to Improve the Detection of Alzheimer’s Disease from Everyday Motion Behaviour

## Publication
[Paper published at Canadian AI Conference 2018](https://www.researchgate.net/profile/Shehroz-Khan-3/publication/323177717_Infusing_Domain_Knowledge_to_Improve_the_Detection_of_Alzheimer%27s_Disease_from_Everyday_Motion_Behaviour/links/5a96423945851535bcdcc83b/Infusing-Domain-Knowledge-to-Improve-the-Detection-of-Alzheimers-Disease-from-Everyday-Motion-Behaviour.pdf)

## Background
Alzheimer’s Diseases (AD) destroy brain cells, impair the thinking ability, and deteriorates memory, which in turn impairs everyday activities of daily living (ADL) by signicantly changing the temporal structure of these activities. An early detection and prediction of such behaviours may allow the application of required interventions to deal with this cognitive degeneration problem.

With the advancements in sensor technologies, it is feasible to perform continuous and longitudinal monitoring of elderly people in smart homes. Dem@Care is an European research project for timely diagnosis, assessment, maintenance and promotion of self-independence of people with dementia. One of their studies is related to detecting the effects of AD from everyday motion behavior. They collected motion data from several dyads (couples) with one partner diagnosed with AD and one partner being a healthy control. They extracted frequency domain and principal component analysis (PCA) features from this data, tested several machine learning algorithms using leave-one-subject-out cross-validation (LOSOCV) and reported high classication accuracy. 

Since both the participants in a dyad lived together, they may bear resemblance in their lifestyle and ADL. During the LOSOCV, an inadvertent bias may be introduced while training the model leading to high detection rates. To circumvent the problems associated with the above cross-validation method, we propose to use leave-one-dyad-out cross-validation (LODOCV) that keeps the dyad for testing separate from the training test. Then, we utilize domain knowledge about the motor behaviour of people with AD and infuse that knowledge to the classiers with corrected evaluation method. Our results show improved detection rate by combining motion based domain features with new evaluation methodology.

## Dataset
The study by Kirste et al. attached an ankle-mounted accelerometer on each participant to collect their everyday motion behavior data. The raw data was the magnitude value of the normalized acceleration measured by the 3 axes accelerometer. The data set included motion data from 78 subjects (39 dyads). In the dataset, there was no data for 2 subjects; therefore, the number of subjects for this paper is 76 (38 dyads). An average of 53:4 hours of data were collected in the original study. We were shared with 5 types of data sets that were prepared by processing the data using a low pass filter with different frequencies (0:5; 5; 25; 50 and 250mHz). The data sets were named F1 to F5 corresponding to the  five frequencies. For instance, the F1 data set was created from the raw data using a 0:5 mHz low pass filter.

## Data processing
To make the samples comparable with each other, an interpolation of data is needed to synchronize data for all subjects. Ignoring this step may lead to undesirable
results. To make the data points consistent with timestamps, we generated a reference array of timestamps between 22:00 on Day 1 to 22:00 on Day 2 based on a sampling rate used to generate the corresponding data set. The starting time for all 5 data sets was exact 22:00. Thus, an array containing reference timestamps can be obtained. For example, for the data set sampled in 50mHz, we obtained an array of 4320 timestamps (24 hour * 60 minutes * 60 seconds * 0.05). Then, we used MATLAB's interp1 function to generate the interpolated data. To prepare for interpolation, data of every subject were trimmed to 24-hour data. Only the data that has timestamps between 22:00 on Day 1 to 22:00 on Day 2 was kept. The rest of data were discarded in this paper.

## Time and frequency features
In order to investigate the performance of revised evaluation methodology, we extracted the following additional 10 time and frequency domain features from the different accelerometer datasets within a time window of 24 hours:
* Mean, maximum, minimum, standard deviation, inter-quartile range,
* Total average power of power spectral density,
* Spectral entropy,
* DC component of energy,
* Normalized energy, and
* FFT entropy
These features have been used earlier for activity recognition tasks. We compared and combined the time / frequency domain features with the proposed features, which are described in the next section.

## Dynamic/Static Interval based Features
People with dementia / AD may exhibit different behaviours than healthy older adults, especially at different times of the day. This is referred to as `sundowning' effect, where a person with dementia / AD can become more agitated, aggressive or confused during late afternoon or early evening. Hsu et al. show that gait and balance based quantitative measurements can be good indicators for early diagnosis of AD. We extend this idea to measure dynamic and static intervals from the accelerometer readings. A dynamic or static interval is defined as the total time period during which a person has more motor activities or not. The level of activity was deduced from the acceleration magnitude values that
was consecutively higher or lower than a pre-de ned value. This pre-defined threshold was empirically set to 4 in the unit of acceleration magnitude. The choice of the value 4 was based on the best accuracy obtained from multiple experiments using values range between 1 - 5. This threshold will determine dynamic and static intervals in the overall motion activities of a person during the whole day. The figures below show the dynamic intervals (in red color) and static intervals (in blue color) for a dyad that has a healthy person and another with AD at di erent times of the day. We can visually observe that the person with AD is more active during the later part of the day. We extracted 12 features
based on these dynamic and static intervals. The features were extracted from the entire 24 hour data to obtain an overall motion pattern. Then, the day's data was divided into four 6-hour periods to capture motion information that may arise due to sundowning e ect or other behaviours in specific quarters of the day. The following is the table of the extracted features:
* Number of points in each dynamic and static intervals in 24 hours
* Number of dynamic and static intervals in 24 hours
* Number of dynamic and static intervals from 12:01 am - 6:00 am
* Number of dynamic and static intervals from 6:01 am - 12:00 pm
* Number of dynamic and static intervals from 12:01 pm - 6:00 pm
* Number of dynamic and static intervals from 6:01 pm - 12:00 am

![image](https://user-images.githubusercontent.com/50496048/147377882-b626c523-03de-478d-941e-fdffaaf53cac.png)
![image](https://user-images.githubusercontent.com/50496048/147377883-ab5c9cbf-6a2a-455d-a0b1-1534b1ef46c6.png)

## Key results
Infusing domain knowledge about motion behaviour of people living with AD improved AD classification accuracy by 17%, compared to baseline without domain knowledge infused. 
![image](https://user-images.githubusercontent.com/50496048/147377896-b04c5d58-3a2c-4120-ba00-9bbd726dacd4.png)

