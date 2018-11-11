setwd("/Users/nadiasoares/Documents/TrabalhoIDS/air-quality-prediction-porto/")

dirLocationsList <- list.dirs(path="data", recursive=FALSE)

# For testing only:
dirLocationsList <- list.dirs(path="data", recursive=FALSE)[1]

df <- data.frame(Date=as.POSIXct(character()),
                 Location=as.factor(character()))

for (dir in dirLocationsList) {
  dirVariableSubList <- list.dirs(path=dir, recursive=FALSE)
  location <- strsplit(dir, "data/USense_")[[1]][2]

  for (subDir in dirVariableSubList) {
    files <- list.files(subDir)
    filter <- paste("data/USense_", location, "/USense_", location, "_", sep="")
    varName <- strsplit(strsplit(subDir, filter)[[1]][2], "_")[[1]][1]

    for (file in files) {
      fileName = paste(subDir, file, sep="/")
      print(fileName)
      tryCatch({
        var <- read.csv(file=fileName, skip=4, header = FALSE)
        colnames(var) <- c("Date", varName)
        var$Date<- as.POSIXct(var$Date)
        df <- merge(df, var, by="Date", all.x = TRUE, all.y = TRUE)
      })
    }
  }
  df$Location <- rep(location, times=length(df$Date))
  #print(df)
}

View(df)

#install.packages("mice")
library("mice")

names(df) <- c("Date", "Location", "CO", "Humidity", "Luminosity", "NO2", "Noise", "O3", "Particles1", "Particles2", "Precipitation", "SolarRadiation", "Temperature", "WindDirection", "WindSpeed")
imputedMod <- mice(df[, c("CO", "Humidity", "Luminosity", "NO2", "Noise", "O3", "Particles1", "Particles2", "Precipitation", "SolarRadiation", "Temperature", "WindDirection", "WindSpeed")], method="rf")  # perform mice imputation, based on random forests.
imputedDF <- complete(imputedMod)  # generate the completed data.
anyNA(imputedDF)

# Note: this is just linear correlation. A close to 0 value means there is no LINEAR correlation.
cor(df[, c("CO", "Humidity", "Luminosity", "NO2", "Noise", "O3", "Particles1", "Particles2", "Precipitation", "SolarRadiation", "Temperature", "WindDirection", "WindSpeed")], use="complete.obs")
# cor(df[, c("CO", "Humidity", "Luminosity", "NO2", "Noise", "O3", "Particles1", "Particles2", "Precipitation", "SolarRadiation", "Temperature", "WindDirection", "WindSpeed")], use="complete.obs", method="spearman")
