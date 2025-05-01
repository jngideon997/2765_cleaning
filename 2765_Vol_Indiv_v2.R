vol_indiv <- function(df_tabs,FacilityInfo,filename,folder_path) {  
  #Designated Facility 
  output_file <- paste(folder_path,"Flattened Data/VoluntaryHolds/",sub('\\.xlsm$', '', basename(filename)),'.csv',sep="")

  if (nrow(df_tabs$VolIndivs)==0)
  {
    print(filename)
    print("No VoluntaryHold data available - skip")
    Sys.sleep(2)
    return()
  }
  
  Data_Voluntary <- data.frame(value=df_tabs$VolIndivs)
  colnames(Data_Voluntary) <- c("ClientID","DateofBirth","GenderIdentity","Race","Ethnicity", "County")
  Data_Voluntary$facilityName <- FacilityInfo$"Facility Name"
  Data_Voluntary$facilityType <- FacilityInfo$"Facility Type"
  Data_Voluntary$year <- FacilityInfo$year
  
  Data_Voluntary <- Data_Voluntary[, c('facilityName','facilityType','year','ClientID',"DateofBirth","GenderIdentity","Race","Ethnicity", "County")]
  
  write.csv(Data_Voluntary,paste(folder_path,"Flattened Data/VoluntaryHolds/VoluntaryHolds_",sub('\\.xlsx$', '', basename(filename)) ,".csv",sep=""), row.names = F)
}