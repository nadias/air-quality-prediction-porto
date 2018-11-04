setwd("/Users/nadiasoares/Documents/TrabalhoIDS/air-quality-prediction-porto/")

dirLocationsList <- list.dirs(path="data", recursive=FALSE)

df <- data.frame(Date=as.POSIXct(character()), 
                 CO=as.numeric(),
                 Humidity=as.numeric(),
                 Luminosity=as.numeric(),
                 NO2=as.numeric(),
                 Noise=as.numeric(),
                 O3=as.numeric(),
                 Particles1=as.numeric(),
                 Particles2=as.numeric(),
                 Precipitation=as.numeric(),
                 SolarRadiation=as.numeric(),
                 Temperature=as.numeric(),
                 WindDirection=as.numeric(),
                 WindSpeed=as.numeric(),
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