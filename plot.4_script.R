library(data.table)
library(tidyverse)

sizeEst <- 8*9*2075259 # assuming average bytes per cell = 8
round(sizeEst/1e9,2) # in Gb

powerConsumption <- fread('unzip -p exdata_data_household_power_consumption.zip')
print(object.size(powerConsumption), units = "Gb")

str(powerConsumption)
powerConsumption$Date <- as.Date(powerConsumption$Date, format = "%d/%m/%Y")
powerConsumption<- subset(powerConsumption,
                          Date >= "2007-02-01" & Date <= "2007-02-02")

print(object.size(powerConsumption), units = "Kb") # waaaayyy smaller

powerConsumption$Time <- strptime(powerConsumption$Time, format = "%H:%M:%S")
powerConsumption$Time <- as.POSIXct(paste(powerConsumption$Date,
                                          as.character(powerConsumption$Time)),
                                    format = "%Y-%m-%d %H:%M:%S")

powerConsumption <- powerConsumption %>% 
    mutate(Global_active_power = as.numeric(Global_active_power),
           Global_reactive_power = as.numeric(Global_reactive_power),
           Voltage = as.numeric(Voltage),
           Global_intensity = as.numeric(Global_intensity),
           Sub_metering_1 = as.numeric(Sub_metering_1),
           Sub_metering_2 = as.numeric(Sub_metering_2))

str(powerConsumption)

par(mfrow = c(2,2))

plot.4a <- plot(powerConsumption$Time, powerConsumption$Global_active_power,
                type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")

plot.4b <- plot(powerConsumption$Time, powerConsumption$Voltage,
                type = "l", xlab = "datetime", ylab = "Voltage")

plot.4c <- plot(powerConsumption$Time, powerConsumption$Sub_metering_1,
                type = "n", xlab = "", ylab = "Energy sub metering")
points(powerConsumption$Time, powerConsumption$Sub_metering_1,
       col = "black", type = "l")
points(powerConsumption$Time, powerConsumption$Sub_metering_2,
       col = "red", type = "l")
points(powerConsumption$Time, powerConsumption$Sub_metering_3,
       col = "blue", type = "l")
legend("topright", col = c("black", "red", "blue"), lty = 1,
       legend = c("Sub_metering_1",
                  "Sub_metering_2",
                  "Sub_metering_3"))

plot.4d <- plot(powerConsumption$Time, powerConsumption$Global_reactive_power,
                type = "l", xlab = "datetime", ylab = "Global_reactive_power")

dev.copy(png, file = "plot.4.png", width = 480, height = 480)
dev.off()
