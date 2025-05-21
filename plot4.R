# This is the script to obtain plot4 required by the assignment

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

## calculating needed additional values
start <- min(hhconsumption$timestamp)
end <- max(hhconsumption$timestamp) + as.difftime(1, units="days")
## including Saturday which is not in the data
ticks <- seq(from = start, to = end, by = "day")

## setting the 2x2 grid 
par(mfrow = c(2, 2))

## generating plot 1
plot(hhconsumption$timestamp, hhconsumption$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)",
     xaxt = "n")

## adding days on x-axis
axis.POSIXct(1, at = ticks, format = "%a")

## generating plot 2
plot(hhconsumption$timestamp, hhconsumption$Voltage,
     type = "l",
     xlab = "datetime",
     ylab = "Voltage",
     xaxt = "n")

## adding days on x-axis
axis.POSIXct(1, at = ticks, format = "%a")

## generating plot 3
plot(hhconsumption$timestamp, hhconsumption$Sub_metering_1,
     type = "n",
     xlab = "",
     ylab = "Energy sub metering",
     xaxt = "n")
lines(hhconsumption$timestamp, hhconsumption$Sub_metering_1, col = "black")
lines(hhconsumption$timestamp, hhconsumption$Sub_metering_2, col = "red")
lines(hhconsumption$timestamp, hhconsumption$Sub_metering_3, col = "blue")

## adding days on x-axis
axis.POSIXct(1, at = ticks, format = "%a")

## adding the legend
legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = 1)

##generating plot4
plot(hhconsumption$timestamp, hhconsumption$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power",
     xaxt = "n",
     ylim=c(0.0, 0.5)
)

## adding days on x-axis
axis.POSIXct(1, at = ticks, format = "%a")

## saving plot
dev.copy(
      png,
      filename = "plot4.png",
      width = 480,
      height = 480,
      units = "px"
)
dev.off()