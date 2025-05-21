# This is the script to obtain plot1 required by the assignment

## reading data selecting only the relevant dates
library(data.table)
hhconsumption <- fread("household_power_consumption.txt", sep = ";")

## transforming date and time into appropriate R classes
hhconsumption[, timestamp := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]
hhconsumption[, `:=`(Date = NULL, Time = NULL)]

## subsetting for the useful date period
date_start <- as.Date("2007-02-01")
date_end <- as.Date("2007-02-02")
date_to_filter <- c(date_start, date_end)
hhconsumption <- hhconsumption[as.Date(hhconsumption$timestamp) %in% date_to_filter, ]

## transforming other columns into appropriate numeric class
cols_to_convert <- names(hhconsumption)[1:7]
for (i in 1:7) {
      column_name <- names(hhconsumption)[i]
      hhconsumption[, (column_name) := as.numeric(unlist(hhconsumption[[column_name]]))]
}

## generating and saving plot
hist(
      hhconsumption$Global_active_power,
      col = "red",
      main = "Global Active power",
      xlab = "Glboal Active Power (kilowatts)",
      ylab = "Frequency",
      xlim = c(0, 6),
      ylim = c(0, 1200)
)
dev.copy(
      png,
      filename = "plot1.png",
      width = 480,
      height = 480,
      units = "px"
)
dev.off()