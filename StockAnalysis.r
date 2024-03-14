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

# Load data
niftyData <-
  read.csv(
    "NIFTY 50-14-09-2023-to-14-03-2024.csv",
    header = TRUE
  )

# Calculate the change, date and the dayname.
niftyData$change <- niftyData$Close - niftyData$Open
niftyData$changePercent <- round((niftyData$change / niftyData$Open)*100, 3)
niftyData$dateParsed <- as.Date(niftyData$Date, format = "%d-%b-%Y")
niftyData$dayName <- weekdays(niftyData$dateParsed)

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

factorReference <- data.frame(
  level = levels(dayNameFactor),
  index = rank(levels(dayNameFactor), ties.method = "first")
)

# Plot the change values grouped by its day names numeric value from above.
plot(
  niftyData$change
  , 
  niftyData$dayNameNumeric
)

factorReference