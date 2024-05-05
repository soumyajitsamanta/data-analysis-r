# Author: Soumyajit Samanta
# LICENSE
# The code is copyright of authors mentioned above 
# and may not be reproduced or used in other form 
# without permission.
# 
# Problem: Look at the market OHLC data to find out 
#     the days which have given mostly positive 
#     changes and explore if there is any relation 
#     between the day of week and the price of the 
#     Nifty 50 index.
# Solution: We use the data from NSE site at 
# [Historical Index Data](https://www.nseindia.com/reports-indices-historical-index-data)
# We can then calculate the day of week and the change
# of the day using. Then we can use the linear model in
# R with change as dependent variable and all other 
# numeric parameters as independent variable. Then we 
# can plot and draw our own conclusion.

library(dplyr)
library(tidyverse)

# Load data
niftyData <-
  read.csv(
    "Datasets/NIFTY 50-14-09-2023-to-14-03-2024.csv",
    header = TRUE
  )

# Calculate the change, date and the dayname.
niftyData$change <- niftyData$Close - niftyData$Open
# niftyData$changePercent <- round((niftyData$change / niftyData$Open)*100, 3)
niftyData$dateParsed <- as.Date(niftyData$Date, format = "%d-%b-%Y")
niftyData$dayName <- weekdays(niftyData$dateParsed)

# Split the date into components and add in data set
niftyData$day = as.integer(format(niftyData$dateParsed, format="%d"))
niftyData$month = as.integer(format(niftyData$dateParsed, format="%m"))
niftyData$year = as.integer(format(niftyData$dateParsed, format="%Y"))

# # Get previous day's close value to this ones prev close value
# # Do not use unless required, day to day following analysis not done.
# niftyData$previousDate <- niftyData$dateParsed-1
# for(rown in 2:nrow(niftyData)) {
#   pd <- niftyData$previousDate[rown]
#   if(!(pd %in% niftyData$dateParsed)) {
#     # TODO : Use date numeric and filter between pd and pd -5 only.
#     dateBelow <- niftyData %>%
#       select(dateParsed) %>%
#       filter(., .$dateParsed < pd & .$dateParsed > pd-5) %>%
#       arrange(desc(dateParsed)) %>%
#       top_n(1)
#     niftyData$previousDate[rown] = dateBelow$dateParsed[1]
#   }
# }
# remove(rown)
# remove(pd)
# remove(dateBelow)

summary(niftyData)

# Perform linear regression analysis with change as dependent variable.
# All other numeric values as independent variable.
linearModel <-
  lm(
    niftyData$change ~ niftyData$Open + niftyData$High + niftyData$Low + niftyData$Close +
      niftyData$dateParsed + niftyData$Open + niftyData$dayName,
    niftyData
  )
linearModel
summary(linearModel)

# Convert category of days name into numeric value.
dayNameFactor <- factor(niftyData$dayName)
niftyData$dayNameNumeric <- as.numeric(dayNameFactor)

levels_day_name <- levels(dayNameFactor)
factorReference <- data.frame(
  level = levels_day_name,
  index = rank(levels_day_name, ties.method = "first"),
)

# Plot the change values grouped by its day names numeric value from above.
plot(niftyData$change, niftyData$dayNameNumeric)
lines(c(0,0),c(1,7))

# Matching error may occur
countOfPositivesAndNegatives <- niftyData %>%
  select(dayNameNumeric, change) %>%
  group_by(dayNameNumeric) %>%
  summarise(positives=sum(change>0), negatives=sum(change<0), sumOfChanges = sum(change))

# Matching error may occur
factorReference$positives <- countOfPositivesAndNegatives$positives
factorReference$negatives <- countOfPositivesAndNegatives$negatives
factorReference$ratio <- factorReference$positives/factorReference$negatives

# niftyData$Shares.Traded

niftyData %>%
  ggplot() +
  geom_line(aes(dateParsed, Open), colour="red") +
  geom_line(aes(dateParsed, Shares.Traded/100000), colour="blue") +
  theme_bw()

ggsave("images/plot-time-vs-price-&-volume.svg", device = "svg")


# ============== NIFTY DATA From HTML

# xmlNodes <- xml2::read_xml(file("table-hist-nifty-data.html"))

# list_nodes <- xmlNodes %>%
#   xml2::xml_find_all("/table/tbody/tr") %>%
#   as.array()

# values <- data.frame()

# for (rowV in list_nodes) {
#   valuesOfRows <- rowV %>%
#     xml2::xml_find_all("*")
#   values <- rbind(values, data.frame(date=xml2::xml_text(valuesOfRows[1]), 
#              open=xml2::xml_text(valuesOfRows[2]), 
#              high=xml2::xml_text(valuesOfRows[3]), 
#              low=xml2::xml_text(valuesOfRows[4]), 
#              close=xml2::xml_text(valuesOfRows[5]), 
#              adj_close=xml2::xml_text(valuesOfRows[6]), 
#              volume=xml2::xml_text(valuesOfRows[7]))
#         )
# }

# write_csv(values, "Datasets/NIFTY 50-26-03-2024-to-26-03-2023.csv")

# ============== NIFTY DATA From HTML END
