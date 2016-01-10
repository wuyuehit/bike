data <- read.csv(file="day.csv", header=TRUE, sep=",")

reg_casual <- lm(casual ~  atemp + hum + windspeed + weathersit + factor(season) + factor(workingday) + factor(season) * atemp, data = data)
summary(reg_casual)

reg_registered <- lm(registered ~  atemp + hum + windspeed + weathersit + factor(season) + factor(workingday) + factor(season) * atemp, data = data)
summary(reg_registered)

reg_cnt <- lm(cnt ~  atemp + hum + windspeed + factor(season) + weathersit +factor(workingday) + factor(season) * atemp, data = data)
summary(reg_cnt)

