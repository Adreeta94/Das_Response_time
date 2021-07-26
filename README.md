# Das_MySidewalk

# How the table was prepared?

I have prepared two tables "Final_table1" shows the response time for the 10th percentile while "Final_table2" shows the response time for the 90th percentile.
Assuming that for the Fire Department the shortest response time which is in the 10th percentile would be the best response time compared to the 90th percentile (which has the longest response time), I have ensured that my R script and the process of finding the shortest response time of the Battalions represent the assumption I have made.
But, the prompt specifically asks for the 90th percentile response time, I have included that as well as "Final_table2".

Following steps were followed:

Step1: tidyverse, dplyr and lubridate packages were used to select only those variables necessary for finding the response time, getting the date in the right format and tidying up the data .

Step2: Then I calculated the time difference between "On scene date time" and the "received date time". After this I filtered out the months specific to the year 2021 as the prompt directs me to use the recent available months.

Step3: I converted the response time from secons to period for easier interpretation. Then I calculated the percentiles for the response time, filtered those that belonged to the 10th percentile(which is the shortest/fastest response time of the Battalions) and sorted them in descending order.

Step4: To represent those that belonged to the 90th percentile (which is the longest response time), I did the same as I did above for the 10th percentile response time.

Step5: I have also added a facet graph for the response time of the 90th percentile. This graph shows the mean response times of different Batallions in the 90th percentile category according to the months.

# How this task would be made trivial?

Step1: Filtering out only the necessary data- "received date time","on scene date time", and "Battalion"

Step2: Formatting the dates to be recognized as a date object and then finding the difference between the on scene time and the received date time.

Step 3: Calculating the percentiles, filtering and sorting those that belong to the 90th and the 10th percentile can help any individual get a grasp of when the response of the fire department was the slowest and the quickest.
