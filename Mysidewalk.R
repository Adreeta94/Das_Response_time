
#loading the data frame
getwd()
df<-read.csv("/Users/adreetadas/Downloads/Fire_Department_Calls_for_Service.csv")

# I will be using the following packages to tidy the data
install.packages("tidyverse")
library(tidyverse)
library(dplyr)

glimpse(df)#gives a glimpse of the data set

#selecting only those variables which are important for solving the question
response_time <- df%>%
  select(Received.DtTm,On.Scene.DtTm,Battalion)

#lubridate package used to get the correct format of date,time and duration

install.packages("lubridate")
library(lubridate)

str(response_time)

#formatting the date and time for the received and on scene column
response_time1<-response_time%>%
  mutate(received_date=mdy_hm(response_time$Received.DtTm),onscene_date=mdy_hm(response_time$On.Scene.DtTm))
str(response_time1)

#Separately calculating the Response time duration
response_duration<-difftime(response_time1$onscene_date,response_time1$received_date)
response_duration<-as_tibble(response_duration)#converting into tibbles and then arranged in aescending order
response_time_sorted<-response_duration%>%
  arrange(value)%>%
  filter(value>0)

response_time_sorted<-as.numeric(response_time_sorted$value)
summary(response_time_sorted)#summary statistics was taken to see the range of response time.

# the response time duration is added to the dataset
response_time2<-response_time1%>%
  mutate(response_duration=difftime(response_time1$onscene_date,response_time1$received_date))%>%
  drop_na()#dropping all nul values

#rearranging the response time in ascending order
response_time2<-response_time2%>%
  mutate(year=year(onscene_date),month=month(onscene_date))%>%
  filter(year==2021,response_duration>0)%>%#dropping values which are negative and 0
  arrange(desc(response_duration))

#converting the seconds to period for a better grasp of the response time


response_time2<-response_time2%>%
  mutate(response_period=seconds_to_period(response_duration))
#finding out the 10th percentile Response times by month by "Battalion"
response_time2a<-response_time2%>%
  mutate(ninetieth_percentile_response_time=ntile(response_period,100))%>%
  filter(ninetieth_percentile_response_time<=10)%>%#keeping only those response time which are in the 10th percentile
  arrange(desc(ninetieth_percentile_response_time))#sorting the 10th percentile response time
head(response_time2a)


#creating the final table to replicate the example-table-csv provided in the prompt

Final_table1<-response_time2a%>%
  select(Battalion,year,month,response_period,response_duration,ninetieth_percentile_response_time)

glimpse(Final_table1)

head(Final_table1,10)



#finding out the 90th percentile Response Times by month by "Battalion"
response_time2b<-response_time2%>%
  mutate(ninetieth_percentile_response_time=ntile(response_period,100))%>%
  filter(ninetieth_percentile_response_time>=90)%>%#keeping only those response time which are in the 90th percentile
  arrange(desc(ninetieth_percentile_response_time))#sorting the 90th percentile response time
head(response_time2b)


#creating some visuals for communicating the observations using ggplot2 package

#finding unique values in battalion column for creating visualizations
unique_battalions<-unique(response_time2b[c("Battalion")])
count(unique_battalions)

response_time_summary<-response_time2b%>%
  select(month,Battalion,response_duration,response_period)%>%
  mutate(month_names=month(mdy_hm(response_time2b$On.Scene.DtTm),label=TRUE),response_duration1=as.numeric(response_time_summary$response_duration))
  #the response duration has been converted from a time object to numeric to help with visualizations
glimpse(response_time_summary)

response_duration2b<-as.numeric(response_time_summary$response_duration)
summary(response_duration2)#here I have separately calculated the summary statistics of response time


#visualization
install.packages("ggplot2")
library(ggplot2)


a<-ggplot(response_time_summary,aes(y=response_duration2b,x=Battalion,fill=Battalion))
  
a+
  stat_summary(fun=mean,geom="bar",position="dodge")+
  facet_wrap(~month_names,nrow=4)+
  labs(title="Monthly Mean response time of the Battalions", x="Battalions",y="mean response time in seconds")

#creating the final table to replicate the example-table-csv provided in the prompt

Final_table2<-response_time2b%>%
  select(Battalion,year,month,response_period,response_duration,ninetieth_percentile_response_time)

glimpse(Final_table2)

head(Final_table2,10)
