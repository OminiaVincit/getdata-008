Codebook
========
This codebook is created with great references from this github link.
https://github.com/benjamin-chan/GettingAndCleaningData

Variable list and descriptions
------------------------------

Variable name    | Description
-----------------|------------
Subject          | ID the subject who performed the activity for each window sample. Its range is from 1 to 30.
ActivityName     | Activity name
Domain           | Feature: Time domain signal or frequency domain signal (Time or Freq)
Instrument       | Feature: Measuring instrument (Accelerometer or Gyroscope)
Acceleration     | Feature: Acceleration signal (Body or Gravity)
Variable         | Feature: Variable (Mean or SD)
Jerk             | Feature: Jerk signal
Magnitude        | Feature: Magnitude of the signals calculated using the Euclidean norm
Axis             | Feature: 3-axial signals in the X, Y and Z directions (X, Y, or Z)
Count            | Feature: Count of data points used to compute `average`
Avg              | Feature: Average of each variable for each activity and each subject

Dataset structure
-----------------


```r
str(tidyData)
```

```
## Classes 'data.table' and 'data.frame':	6120 obs. of  10 variables:
##  $ Subject     : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ ActivityName: Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ Domain      : Factor w/ 2 levels "Time","Freq": 1 1 1 1 1 1 1 1 1 1 ...
##  $ Acceleration: Factor w/ 3 levels NA,"Body","Gravity": 1 1 1 1 1 1 1 1 2 2 ...
##  $ Instrument  : Factor w/ 2 levels "Accelerometer",..: 2 2 2 2 2 2 2 2 1 1 ...
##  $ Jerk        : Factor w/ 2 levels NA,"Jerk": 1 1 1 1 2 2 2 2 1 1 ...
##  $ Magnitude   : Factor w/ 2 levels NA,"Magnitude": 1 1 2 2 1 1 2 2 1 1 ...
##  $ Variable    : Factor w/ 2 levels "Mean","SD": 1 2 1 2 1 2 1 2 1 2 ...
##  $ Count       : int  150 150 50 50 150 150 50 50 150 150 ...
##  $ Avg         : num  0.0226 -0.911 -0.8748 -0.819 -0.0743 ...
##  - attr(*, "sorted")= chr  "Subject" "ActivityName" "Domain" "Acceleration" ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

List the key variables
----------------------------------------


```r
key(tidyData)
```

```
## [1] "Subject"      "ActivityName" "Domain"       "Acceleration"
## [5] "Instrument"   "Jerk"         "Magnitude"    "Variable"
```

Head of data set
------------------------------


```r
head(tidyData)
```

```
##    Subject ActivityName Domain Acceleration Instrument Jerk Magnitude
## 1:       1       LAYING   Time           NA  Gyroscope   NA        NA
## 2:       1       LAYING   Time           NA  Gyroscope   NA        NA
## 3:       1       LAYING   Time           NA  Gyroscope   NA Magnitude
## 4:       1       LAYING   Time           NA  Gyroscope   NA Magnitude
## 5:       1       LAYING   Time           NA  Gyroscope Jerk        NA
## 6:       1       LAYING   Time           NA  Gyroscope Jerk        NA
##    Variable Count         Avg
## 1:     Mean   150  0.02255007
## 2:       SD   150 -0.91097299
## 3:     Mean    50 -0.87475955
## 4:       SD    50 -0.81901017
## 5:     Mean   150 -0.07427945
## 6:       SD   150 -0.94810197
```

Summary of variables
--------------------


```r
summary(tidyData)
```

```
##     Subject                 ActivityName   Domain      Acceleration 
##  Min.   : 1.0   LAYING            :1020   Time:3600   NA     :2520  
##  1st Qu.: 8.0   SITTING           :1020   Freq:2520   Body   :2880  
##  Median :15.5   STANDING          :1020               Gravity: 720  
##  Mean   :15.5   WALKING           :1020                             
##  3rd Qu.:23.0   WALKING_DOWNSTAIRS:1020                             
##  Max.   :30.0   WALKING_UPSTAIRS  :1020                             
##          Instrument     Jerk          Magnitude    Variable   
##  Accelerometer:3600   NA  :3600   NA       :2880   Mean:3060  
##  Gyroscope    :2520   Jerk:2520   Magnitude:3240   SD  :3060  
##                                                               
##                                                               
##                                                               
##                                                               
##      Count            Avg         
##  Min.   : 36.0   Min.   :-0.9977  
##  1st Qu.: 54.0   1st Qu.:-0.9632  
##  Median : 78.0   Median :-0.5313  
##  Mean   :111.1   Mean   :-0.5323  
##  3rd Qu.:162.0   3rd Qu.:-0.1302  
##  Max.   :285.0   Max.   : 0.6446
```

Save to file
------------


```r
f <- file.path(path, "tidy-UCI-HAR-Dataset.txt")
write.table(tidyData, f, row.names=FALSE)
```
