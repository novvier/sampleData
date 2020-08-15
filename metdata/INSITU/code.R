setwd("C:/Users/USUARIO/Documents/Course Air Modeling/metdata/INSITU")
library(readxl)
library(dplyr)
library(lubridate)
data <- read_excel("84628_RAW.xlsx", sheet = "data") %>% 
  group_by(AÑO, MES, DIA, HORA) %>% 
  summarise(WS = min(WINDSPEED, na.rm = T),
            WD = min(as.numeric(DIRWIN), na.rm = T),
            TEMP = min(TEMP, na.rm = T),
            DEW = min(TEMP, na.rm = T),
            CLOUD = min(as.numeric(CLOUDCOVER), na.rm = T)) %>% 
  ungroup() %>% 
  dplyr::mutate(AÑO = as.numeric(AÑO),
                MES = as.numeric(MES),
                DIA = as.numeric(DIA),
                HORA = as.numeric(HORA),
                CLOUD = ifelse(CLOUD == Inf, NA, CLOUD),
                CLOUD = ifelse(CLOUD == 99, NA, CLOUD),
                CLOUD = ifelse(is.na(CLOUD) & HORA > 17, 10, CLOUD),
                CLOUD = ifelse(is.na(CLOUD) & HORA < 6, 10, CLOUD),
                WS = ifelse(WS == 999.9, NA, WS),
                WD = ifelse(WD == 999, NA, WD))
  

data[which(is.na(data$WD)),]

data$CLOUD[which(is.na(data$CLOUD))] <- sample(10, 3007, replace = T)
