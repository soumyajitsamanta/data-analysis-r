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
weekly_open_values <- read.csv('/home/serverpc/Project/DatabaseFiles/RawDataFiles/NSEAnalysis/weekly_open_values.sql.csv')

